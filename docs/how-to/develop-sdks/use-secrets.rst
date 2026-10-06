.. _how_use_secrets:

.. meta::
   :description: How-to guide on consuming a user's credential in an SDK
                 through a secret plug, in a command integration
                 with workshopctl get-secret or in a service
                 with a systemd credential, covering failures,
                 exposure limits, and user-supplied values.

How to use secrets in an SDK
============================

.. @artefact secret interface
.. @artefact workshopctl get-secret

An SDK that needs a user's credential at runtime,
such as an API key,
declares a :samp:`secret` plug.
After the user connects the plug,
|ws_markup| fetches the value from the user's host keyring
whenever the SDK asks for it,
so the SDK doesn't need to ship or store the value.

Prerequisites
-------------

Before starting, ensure you have these requirements satisfied:

- A |ws_markup| installation that supports the :samp:`secret` interface.
- An |sdk_markup| version that accepts :samp:`secret` plugs.
- Familiarity with :ref:`declaring plugs <how_declare_plugs_slots>`
  and :ref:`writing runtime hooks <how_write_runtime_hooks>`.
- A credential in your own host keyring to test with,
  stored as described in :ref:`how_provide_secrets`.


Choose how the SDK receives the value by what consumes it:

.. list-table::
   :header-rows: 1
   :widths: 2 3 4

   * - What needs it
     - Mechanism
     - Why

   * - A command the user runs
     - A wrapper or tool-native helper that calls
       :command:`workshopctl get-secret`
     - The integration fetches the value when the tool needs it
       without storing it in the SDK

   * - A long-running service
     - :samp:`LoadCredential=` in the service's unit
     - systemd requests the value on every start
       and, if available, gives the service a private file

   * - A value the user picks for a single run
     - Nothing the SDK depends on
     - Users pass it with :option:`!--env` themselves;
       the SDK must work without it


.. warning::

   Never put a secret in SDK content, :file:`sdkcraft.yaml`,
   workshop definitions, hooks, shell profiles, examples, or logs.
   Each of these is a file that ships, persists, or is shared,
   so a value written there outlives the moment it was needed.


Declare the secret plug
-----------------------

Add a plug with the :samp:`secret` interface to :file:`sdkcraft.yaml`:

.. code-block:: yaml
   :caption: sdkcraft.yaml

   plugs:
     api-key:
       interface: secret


The plug's behavior shapes the rest of the SDK:

- |ws_markup| never connects a :samp:`secret` plug automatically,
  so every user has to connect it explicitly,
  and the SDK must cope with a plug that isn't connected yet.
- The slot that names the keyring item
  belongs to the user's workshop definition, not to the SDK.
  Tell users which plug to connect and what credential it expects,
  and point them to :ref:`how_provide_secrets` for the steps.
- Inside the workshop,
  the secret is identified as :samp:`{SDK}.{PLUG}`,
  for example :samp:`secret-demo.api-key`
  for the :samp:`api-key` plug of an SDK named :samp:`secret-demo`.


Try the SDK in a test workshop
------------------------------

Build the SDK into the try area:

.. code-block:: console

   $ sdkcraft try


Store a test credential in your host keyring
under the attributes that the test slot below uses:

.. code-block:: console

   $ secret-tool store --label="secret-demo test key" --collection=default service secret-demo account test


Then add the SDK to a test workshop
next to a :samp:`system` slot that points at that credential:

.. code-block:: yaml
   :caption: workshop.yaml

   name: dev
   base: ubuntu@24.04
   sdks:
     - name: system
       slots:
         demo-key:
           interface: secret
           attributes:
             service: secret-demo
             account: test
     - name: try-secret-demo


Launch the workshop.
The SDK keeps its own name inside the workshop,
so its plug is listed without the :samp:`try-` prefix,
and it starts out unconnected:

.. code-block:: console

   $ workshop launch
   $ workshop connections dev

     INTERFACE  PLUG                     SLOT                 NOTES
     secret     -                        dev/system:demo-key  -
     secret     dev/secret-demo:api-key  -                    -


Run the examples below once before connecting the plug,
to see how the SDK behaves without the secret,
then connect it:

.. code-block:: console

   $ workshop connect dev/secret-demo:api-key dev/system:demo-key
   $ workshop connections dev

     INTERFACE  PLUG                     SLOT                 NOTES
     secret     dev/secret-demo:api-key  dev/system:demo-key  manual


Fetch the secret in a command wrapper
-------------------------------------

If a command reads its credential from an environment variable,
a wrapper can fetch the secret each time it runs
and pass it to that command without exporting it to the calling shell.
This wrapper runs :file:`bin/secret-demo-tool`,
a tool that reads its key from :envvar:`SECRET_DEMO_API_KEY`:

.. code-block:: shell
   :caption: bin/secret-demo

   #!/usr/bin/bash
   # Runs secret-demo-tool with the API key from the connected secret plug.
   # A key the user already passed in the environment takes precedence.
   set -euo pipefail
   sdk_dir=$(dirname "$(dirname "$(readlink -f "$0")")")

   if [[ -z "${SECRET_DEMO_API_KEY:-}" ]]; then
     SECRET_DEMO_API_KEY=$(workshopctl get-secret secret-demo.api-key) || {
       rc=$?
       echo "secret-demo: cannot read the API key; check that secret-demo:api-key is connected and that its slot matches one unlocked keyring item" >&2
       exit "$rc"
     }
   fi

   SECRET_DEMO_API_KEY="$SECRET_DEMO_API_KEY" exec "$sdk_dir/bin/secret-demo-tool" "$@"


If the tool supports a credential helper,
configure it to call :command:`workshopctl get-secret` on demand instead.
The `Claude Code SDK <https://github.com/canonical/claude-code-sdk/>`_
uses Claude Code's :samp:`apiKeyHelper` for this purpose,
so the API key doesn't enter the tool's environment.
The `Copilot SDK <https://github.com/canonical/copilot-sdk/>`_
uses an environment wrapper for its token.
Choose the integration supported by the tool.


:command:`workshopctl get-secret` writes the value to standard output,
so the wrapper captures it in a variable
instead of echoing it,
exporting it from a shell profile,
or writing it to a file.
Keep shell tracing (:samp:`set -x`) out of the wrapper,
because it prints the assignment, value included.
Put the wrapper on the :envvar:`PATH` from the :samp:`setup-base` hook:

.. code-block:: shell
   :caption: hooks/setup-base

   cat >/etc/profile.d/secret-demo.sh <<PROFILE
   export PATH="${SDK}/bin:\$PATH"
   PROFILE


With the plug connected,
the tool receives the key,
and the calling shell doesn't:

.. code-block:: console

   $ workshop exec dev -- sh -c 'secret-demo; echo "after: ${SECRET_DEMO_API_KEY-<unset>}"'

     secret-demo-tool: authenticated with a 23-character key
     after: <unset>


When the lookup fails,
:command:`workshopctl get-secret` exits with status 1
and names the cause on standard error.
Let that message through,
add what the user should check,
and exit with a non-zero status:

.. code-block:: console

   $ workshop exec dev -- secret-demo


The error can end with one of these causes:
:samp:`secret plug is not connected`,
:samp:`secret provider is locked`,
:samp:`secret not found`,
or :samp:`multiple secrets match the request`.
:ref:`how_provide_secrets` tells users how to fix each one.


Receive the secret in a service
-------------------------------

For a long-running service,
let systemd request the secret when the service starts.
In the same :samp:`setup-base` hook, install the service as a system unit;
the hook runs as :samp:`root`
and has :envvar:`SDK_SYSTEMD_SECRET_SOCKET` set
to the workshop's secret socket.
Run the service itself as the :samp:`workshop` user,
and name the credential :samp:`{SDK}.{PLUG}`:

.. code-block:: shell
   :caption: hooks/setup-base

   cat >/etc/systemd/system/secret-demo.service <<UNIT
   [Unit]
   Description=Secret demo service

   [Service]
   User=workshop
   LoadCredential=secret-demo.api-key:${SDK_SYSTEMD_SECRET_SOCKET}
   ExecStart=${SDK}/bin/secret-demo-service
   Restart=on-failure
   RestartSec=30

   [Install]
   WantedBy=multi-user.target
   UNIT

   systemctl daemon-reload
   systemctl enable --now secret-demo.service


The service reads the value from the file named after the credential
in :envvar:`CREDENTIALS_DIRECTORY`,
and stops with a clear message when the file is missing or empty;
:samp:`sleep infinity` stands in for the service's own process:

.. code-block:: shell
   :caption: bin/secret-demo-service

   #!/usr/bin/bash
   # Reads the API key from a systemd credential, then runs the service.
   key_file="$CREDENTIALS_DIRECTORY/secret-demo.api-key"
   if [[ ! -s "$key_file" ]]; then
     echo "secret-demo-service: cannot read the API key; check that secret-demo:api-key is connected and that its slot matches one unlocked keyring item, then restart secret-demo.service" >&2
     exit 1
   fi
   echo "secret-demo-service: started with a $(wc -c <"$key_file")-character key"
   exec sleep infinity


When the service starts, systemd requests the credential.
After connecting the plug or fixing a keyring lookup,
restart the service to request the value again,
then check whether it started:

.. code-block:: console

   $ workshop exec dev -- sudo systemctl restart secret-demo.service
   $ workshop exec dev -- systemctl is-active secret-demo.service


An active service has received a nonempty credential in this example.
If the plug isn't connected, systemd can start the service
without a usable value;
the service's check then exits,
and :samp:`Restart=on-failure` schedules another attempt.
A failed keyring lookup can also leave the service without a usable value.
If it doesn't start, or starts but stops,
check its status, the service journal,
and the :samp:`workshop-secret@` resolver journal.
The resolver journal can name a disconnected plug,
a locked keyring, or a missing item
even when the service's own process never starts:

.. code-block:: console

   $ workshop exec dev -- sudo systemctl status --no-pager secret-demo.service
   $ workshop exec dev -- sudo journalctl --no-pager -u secret-demo.service -u 'workshop-secret@*'
   $ workshop exec dev -- sh -c 'workshopctl get-secret secret-demo.api-key > /dev/null'


The last command discards the value but prints a lookup error.
Follow :ref:`how_provide_secrets` to fix the reported cause,
then restart the service and check its status again.


Leave one-off values to users
-----------------------------

Users can pass a value to a single command themselves
with :option:`!--env` on :command:`workshop exec` or :command:`workshop run`,
either directly as :samp:`NAME=value`
or by name only, which inherits the value from their calling shell.
An inherited name that isn't set in the calling shell
is skipped without an error.

The SDK must not depend on this path.
The wrapper above lets a value from the environment take precedence,
and falls back to the plug when the variable is absent,
so an inherited name that isn't set doesn't break it:

.. code-block:: console

   $ unset SECRET_DEMO_API_KEY
   $ workshop exec --env SECRET_DEMO_API_KEY dev -- secret-demo

     secret-demo-tool: authenticated with a 23-character key


Know the exposure limits
------------------------

Each mechanism keeps the value out of SDK content,
but the value is still readable somewhere while it's in use,
and some of that is beyond the SDK's control:

.. list-table::
   :header-rows: 1
   :widths: 2 4 4

   * - Mechanism
     - What lives on, and who can read it
     - What the SDK can't clean up

   * - Command wrapper
     - The value lives in the tool's environment for that run;
       the tool and every process it starts can read it.
       Nothing is written to disk,
       and the calling shell never holds it.
     - While the plug is connected,
       any command in the workshop can request the value
       with :command:`workshopctl get-secret`.

   * - Tool-native helper
     - The tool receives the value when it calls the helper.
       An on-demand helper can avoid putting it in the tool's environment.
     - The tool controls how long it keeps the value
       and whether its child processes can access it;
       a connected plug remains available to other commands
       in the workshop.

   * - Service credential
     - The value lives in a file under :file:`/run/credentials/`
       that only the service's user and :samp:`root` can read,
       for as long as the service runs;
       systemd removes the file when the service stops.
       It isn't in the service's environment.
     - Processes running as the service's user can read the file
       while the service runs.

   * - User-supplied value
     - The value lives in the environment of that one invocation.
     - A value the user exported stays in their calling shell,
       and one typed on the command line stays in their shell history.


See also
--------

How-to guides:

- :ref:`how_provide_secrets`
- :ref:`how_declare_plugs_slots`
- :ref:`how_write_runtime_hooks`


Reference:

- :ref:`ref_workshopctl__cli`
- :ref:`ref_workshop_exec`
- :ref:`ref_workshop_run`
