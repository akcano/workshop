.. _how_use_secrets:

.. meta::
   :description: How-to guide on consuming a credential in an SDK
                 through a secret plug: requesting it on demand
                 with workshopctl get-secret, passing it to a tool,
                 or receiving it in a systemd service,
                 covering failures, request records, and exposure limits.

How to use secrets in an SDK
============================

.. @artefact secret interface
.. @artefact workshopctl get-secret

An SDK that needs a credential at runtime,
such as an API key,
declares a :samp:`secret` plug.
After the plug is connected to a :samp:`secret` slot,
|ws_markup| looks the value up through that slot
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
     - :command:`workshopctl get-secret`,
       called from a credential helper, a pipe, or a wrapper
     - The value is fetched only when the tool needs it
       and goes only to the process that asked

   * - A long-running systemd service
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

The examples use an SDK named :samp:`secret-demo`
whose tool, :file:`bin/secret-demo-tool`,
reads an API key from :envvar:`SECRET_DEMO_API_KEY`.
Add a plug with the :samp:`secret` interface to :file:`sdkcraft.yaml`:

.. code-block:: yaml
   :caption: sdkcraft.yaml
   :emphasize-lines: 1,4-6

   name: secret-demo
   # ...

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
  the secret is identified as :samp:`<SDK>.<PLUG>`,
  the SDK's name and the plug's name joined by a dot:
  here, :samp:`secret-demo.api-key`.


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


Request the secret
------------------

Inside the workshop,
:command:`workshopctl get-secret` requests the value
of a connected :samp:`secret` plug
and writes it to standard output;
the integrations below build on it.
Nothing is fetched in advance:
|ws_markup| looks the value up through the connected slot
only when a process makes the request,
returns it only to that process,
and keeps no copy in the workshop.

Request the value before connecting the plug
to see what the SDK gets when the secret is unavailable:

.. code-block:: console

   $ workshop exec dev -- workshopctl get-secret secret-demo.api-key

     secret plug "secret-demo.api-key" is not connected


The message on standard error names the plug and the cause,
and the exit status tells the causes apart:
for example, 3 means that the plug isn't connected,
and 2 that the keyring is locked.
The :command:`workshopctl get-secret` reference lists every status.

Connect the plug and request the value again,
counting its characters instead of printing it:

.. code-block:: console

   $ workshop connect dev/secret-demo:api-key dev/system:demo-key
   $ workshop exec dev -- sh -c 'workshopctl get-secret secret-demo.api-key | wc -c'

     23


Each request leaves a record without the value.
|ws_markup| runs it as a change named after the plug,
so :command:`workshop changes` lists every request,
when it happened, and whether it succeeded:

.. code-block:: console

   $ workshop changes

     ID  STATUS  SPAWN               READY               SUMMARY
     ...
     2   Done    today at 11:58 UTC  today at 11:58 UTC  Execute command "workshopctl"
     3   Error   today at 11:58 UTC  today at 11:58 UTC  Retrieve secret "dev/secret-demo:api-key"
     4   Done    today at 11:58 UTC  today at 11:58 UTC  Connect dev/secret-demo:api-key
     5   Done    today at 11:58 UTC  today at 11:58 UTC  Execute command "sh"
     6   Done    today at 11:58 UTC  today at 11:58 UTC  Retrieve secret "dev/secret-demo:api-key"


A :samp:`Done` change delivered the value to the process that asked;
an :samp:`Error` change didn't.
For a failed request,
:command:`workshop tasks` with the change's ID shows the cause:

.. code-block:: console

   $ workshop tasks 3

     STATUS  DURATION  SUMMARY
     Error       41ms  Retrieve secret "dev/secret-demo:api-key"

     ......................................................................
     Retrieve secret "dev/secret-demo:api-key"

     2026-10-09T11:58:40Z ERROR getting secret value for sdk "secret-demo" and plug "api-key" in workshop "dev": plug is not connected


This record stays available
even when an integration doesn't pass the error on to the user.


Pass the secret to a tool
-------------------------

How the SDK hands the value to a tool
depends on how the tool accepts a credential.
In order of preference:

- **A credential helper.**
  If the tool can run a command to obtain its credential,
  configure it to call :command:`workshopctl get-secret`.
  The tool then requests the value only when it needs it,
  and the value never enters its environment.
  The `Claude Code SDK <https://github.com/canonical/claude-code-sdk/>`_
  uses Claude Code's :samp:`apiKeyHelper` for this purpose.
- **Standard input.**
  If the tool reads the credential from standard input,
  pipe the output of :command:`workshopctl get-secret` into it.
- **An environment variable.**
  If the tool reads the credential only from an environment variable,
  wrap the tool in a script that sets the variable for that tool alone.
  The `Copilot SDK <https://github.com/canonical/copilot-sdk/>`_
  uses a wrapper for its token.

Whichever you choose,
capture the value in a variable or a pipe
instead of echoing it, exporting it from a shell profile,
or writing it to a file,
and keep shell tracing (:samp:`set -x`) out of the script,
because it prints assignments, values included.


Wrap a tool that reads an environment variable
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A wrapper requests the secret each time it runs
and passes it to the tool,
without exporting it to the calling shell.
This wrapper runs :file:`bin/secret-demo-tool`
with the key in :envvar:`SECRET_DEMO_API_KEY`:

.. code-block:: shell
   :caption: files/bin/secret-demo

   #!/usr/bin/bash
   # Runs secret-demo-tool with the API key from the connected secret plug.
   # A key already set in the environment takes precedence.
   sdk_dir=$(dirname "$(dirname "$(readlink -f "$0")")")

   if [[ -z "${SECRET_DEMO_API_KEY:-}" ]]; then
     if key=$(workshopctl get-secret secret-demo.api-key); then
       export SECRET_DEMO_API_KEY="$key"
     fi
     unset key
   fi

   exec "$sdk_dir/bin/secret-demo-tool" "$@"


When the request fails,
:command:`workshopctl get-secret` already prints a message
that names the plug and the cause,
so the wrapper doesn't add its own or exit;
it starts the tool without the key,
and the tool can fall back to its own login
or report the missing key.
To treat causes differently,
for example to stay silent about an unconnected plug
because the tool has another way to log in,
branch on the exit status of :command:`workshopctl get-secret`.

Save the wrapper next to the tool,
in the :file:`files/` directory that the SDK's :samp:`dump` part
copies into the SDK:

.. code-block:: yaml
   :caption: sdkcraft.yaml

   parts:
     secret-demo:
       plugin: dump
       source: files


Put the wrapper on the :envvar:`PATH` from the :samp:`setup-base` hook:

.. code-block:: shell
   :caption: hooks/setup-base

   cat >/etc/profile.d/secret-demo.sh <<PROFILE
   export PATH="${SDK}/bin:\$PATH"
   PROFILE


The test workshop still runs the earlier build,
so build the SDK again
and refresh the workshop to install the new build.
The plug stays connected:

.. code-block:: console

   $ sdkcraft try
   $ workshop refresh
   $ workshop connections dev

     INTERFACE  PLUG                     SLOT                 NOTES
     secret     dev/secret-demo:api-key  dev/system:demo-key  manual


With the plug connected,
the tool receives the key,
and the calling shell doesn't:

.. code-block:: console

   $ workshop exec dev -- sh -c 'secret-demo; echo "after: ${SECRET_DEMO_API_KEY-<unset>}"'

     secret-demo-tool: authenticated with a 23-character key
     after: <unset>


Without the plug,
the message from :command:`workshopctl get-secret` comes first,
then the tool's own:

.. code-block:: console

   $ workshop disconnect dev/secret-demo:api-key
   $ workshop exec dev -- secret-demo

     secret plug "secret-demo.api-key" is not connected
     secret-demo-tool: no API key


Receive the secret in a systemd service
---------------------------------------

For a long-running service,
let systemd request the secret when it starts the service.
In the same :samp:`setup-base` hook, install the service as a systemd system unit;
the hook runs as :samp:`root`
and has :envvar:`SDK_SYSTEMD_SECRET_SOCKET` set
to the workshop's secret socket.
Run the service itself as the :samp:`workshop` user,
and name the credential :samp:`<SDK>.<PLUG>`:

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


The request happens only when systemd starts the unit:
the :samp:`LoadCredential=` entry makes systemd connect to the secret socket,
and for each connection a :samp:`workshop-secret@` service
looks the value up the same way :command:`workshopctl get-secret` does.

The service reads the value from the file named after the credential
in :envvar:`CREDENTIALS_DIRECTORY`,
and stops when the file is missing or empty;
:samp:`sleep infinity` stands in for the service's own process:

.. code-block:: shell
   :caption: files/bin/secret-demo-service

   #!/usr/bin/bash
   # Reads the API key from a systemd credential, then runs the service.
   key_file="$CREDENTIALS_DIRECTORY/secret-demo.api-key"
   if [[ ! -s "$key_file" ]]; then
     echo "secret-demo-service: no API key in the secret-demo.api-key credential" >&2
     exit 1
   fi
   echo "secret-demo-service: started with a $(wc -c <"$key_file")-character key"
   exec sleep infinity


Build the SDK again and refresh the workshop.
The :samp:`setup-base` hook runs before the workshop reconnects the plug,
so the service's first start gets an empty credential and stops;
:samp:`Restart=on-failure` starts it again 30 seconds later,
and that start receives the value:

.. code-block:: console

   $ sdkcraft try
   $ workshop refresh
   $ workshop exec dev -- systemctl is-active secret-demo.service

     activating

   $ sleep 30
   $ workshop exec dev -- systemctl is-active secret-demo.service

     active


An active service has received a nonempty credential in this example.
Whenever the plug isn't connected or the lookup fails,
systemd still starts the service, with an empty credential;
the service's check then exits,
and :samp:`Restart=on-failure` schedules another attempt.
After you connect the plug or fix the lookup,
the next attempt receives the value;
to request it right away, restart the service:

.. code-block:: console

   $ workshop exec dev -- sudo systemctl restart secret-demo.service


To find out why the service has no value,
check the service's journal and the :samp:`workshop-secret@` journal,
which records each request and its error:

.. code-block:: console

   $ workshop exec dev -- sudo journalctl --no-pager -u secret-demo.service -u 'workshop-secret@*'

     ...
     Oct 09 12:00:20 dev workshopctl[544]: processed systemd load credential request for unit "secret-demo.service", "secret-demo" SDK and secret "api-key"
     Oct 09 12:00:21 dev workshopctl[544]: secret plug "secret-demo.api-key" is not connected
     Oct 09 12:00:21 dev systemd[1]: workshop-secret@1-543-0.service: Deactivated successfully.
     Oct 09 12:00:21 dev secret-demo-service[542]: secret-demo-service: no API key in the secret-demo.api-key credential
     Oct 09 12:00:21 dev systemd[1]: secret-demo.service: Main process exited, code=exited, status=1/FAILURE


Each start also leaves a :samp:`Retrieve secret` change
in :command:`workshop changes`;
for an unconnected plug, the change ends in :samp:`Error`
even though systemd started the service.
Follow :ref:`how_provide_secrets` to fix the reported cause,
then restart the service.


Leave one-off values to users
-----------------------------

Users can pass a value to a single command themselves
with :option:`!--env` on :command:`workshop exec` or :command:`workshop run`,
naming a variable whose value is inherited from their calling environment.
An inherited name that isn't set
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

   * - Tool-native helper
     - The tool receives the value when it calls the helper.
       An on-demand helper can avoid putting it in the tool's environment.
     - The tool controls how long it keeps the value
       and whether its child processes can access it;
       a connected plug remains available to other commands
       in the workshop.

   * - Command wrapper
     - The value lives in the tool's environment for that run;
       the tool and every process it starts can read it.
       Nothing is written to disk,
       and the calling shell never holds it.
     - While the plug is connected,
       any command in the workshop can request the value
       with :command:`workshopctl get-secret`.

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
     - A variable that the user's shell or direnv exports
       stays available to every command they run there.


See also
--------

How-to guides:

- :ref:`how_declare_plugs_slots`
- :ref:`how_provide_secrets`
- :ref:`how_write_runtime_hooks`


Reference:

- :ref:`ref_workshop_changes`
- :ref:`ref_workshop_exec`
- :ref:`ref_workshop_run`
- :ref:`ref_workshop_tasks`
- :ref:`ref_workshopctl__cli`
