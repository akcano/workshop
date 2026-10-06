.. _how_provide_secrets:

.. meta::
   :description: How-to guide on providing a credential to an SDK in a workshop,
                 either from the host keyring through a secret slot
                 and an explicitly connected plug,
                 or as an environment variable for a single command,
                 covering lookup failures and exposure limits.

How to provide secrets to a workshop
====================================

.. @artefact secret interface
.. @artefact workshop exec

Some SDKs need a credential at runtime,
such as an API key for an AI coding agent.
|ws_markup| can deliver that credential to the workshop
without the value ever landing in the workshop definition,
the project directory, or your shell history.
There are two ways to do it,
so pick one before you start:

.. list-table::
   :header-rows: 1
   :widths: 1 2 2

   * -
     - From the host keyring
     - For a single command
   * - What persists
     - The value stays in your keyring;
       the workshop keeps only the connection,
       which survives refreshes until you disconnect it
     - Nothing; the next command in the workshop doesn't see the value
   * - Who can read the value
     - Any command in the workshop,
       through the connected plug,
       each time it asks for the value
     - The command you run and the processes it starts,
       for that run only
   * - Retyping
     - None once you connect the plug
     - Every run
   * - Suits
     - An SDK you use repeatedly
     - A one-off command that you run yourself


.. warning::

   Don't put a secret in the workshop definition, its actions,
   project files, or shell profiles.
   These are plain files:
   the project directory, definition included,
   is visible inside the workshop and often ends up in version control,
   and a shell profile exports its variables to every command you run.


Prerequisites
-------------

Before starting, ensure you have these requirements satisfied:

- A |ws_markup| installation that supports the :samp:`secret` interface.
- A desktop session that runs a keyring service
  implementing the freedesktop.org Secret Service,
  such as GNOME Keyring.
  |ws_markup| looks the secret up through the D-Bus session bus
  of the user who runs the workshop command,
  so the keyring service must be running in that session.
- The :program:`secret-tool` utility,
  shipped in the :samp:`libsecret-tools` package on Ubuntu,
  to store and check keyring items.
- A workshop definition that includes an SDK declaring a :samp:`secret` plug.
  The SDK's documentation names the plug
  and the credential it expects.


Use a secret from the host keyring
----------------------------------

The host keyring holds the value;
the workshop definition only says where to find it,
and you decide which SDK may ask for it.


Store the credential
~~~~~~~~~~~~~~~~~~~~

Store the credential in the host keyring
under attributes that identify it.
Attributes are name and value pairs you choose;
the workshop finds the item by them,
so pick a combination that no other item shares.
:program:`secret-tool` prompts for the value,
so it never appears on the command line:

.. code-block:: console

   $ secret-tool store --label="OpenAI API key" --collection=default service openai account work


To check that the item is stored,
look it up by the same attributes;
:program:`secret-tool` prints the value:

.. code-block:: console

   $ secret-tool lookup service openai account work


Add a secret slot
~~~~~~~~~~~~~~~~~

Describe where the secret lives
by adding a :samp:`secret` slot to the :samp:`system` SDK
in the workshop definition.
The slot carries lookup attributes only, never the value:

.. code-block:: yaml
   :caption: workshop.yaml
   :emphasize-lines: 4-10

   name: dev
   base: ubuntu@24.04
   sdks:
     - name: system
       slots:
         openai-key:
           interface: secret
           attributes:
             service: openai
             account: work
     - name: <SDK>


The slot accepts two keys:

- :samp:`attributes` is required
  and holds at least one attribute with a string value.
  The lookup matches an item that carries all of them.
- :samp:`collection` is optional and selects the keyring collection to search.
  Without it, the lookup searches the collection
  that the keyring's :samp:`default` alias points to,
  which is the Login keyring in GNOME Keyring.
  Any other value is matched against collection labels.

Only the :samp:`system` SDK can declare a :samp:`secret` slot,
and |ws_markup| refuses a slot with any other key.

Apply the definition with :command:`workshop launch` for a new workshop,
or refresh an existing one:

.. code-block:: console

   $ workshop refresh


.. _how_provide_secrets_connect:

Connect the plug
~~~~~~~~~~~~~~~~

|ws_markup| never connects a :samp:`secret` plug on its own,
so after a launch or a refresh
the plug and the slot remain unconnected:

.. code-block:: console

   $ workshop connections <WORKSHOP>

     INTERFACE  PLUG                     SLOT                          NOTES
     ...
     secret     -                        <WORKSHOP>/system:openai-key  -
     secret     <WORKSHOP>/<SDK>:<PLUG>  -                             -


Connect the SDK's plug to the slot
to let the workshop ask the keyring for the secret:

.. code-block:: console

   $ workshop connect <WORKSHOP>/<SDK>:<PLUG> <WORKSHOP>/system:openai-key


Confirm the connection in the connections listing:

.. code-block:: console

   $ workshop connections <WORKSHOP>

     INTERFACE  PLUG                     SLOT                          NOTES
     ...
     secret     <WORKSHOP>/<SDK>:<PLUG>  <WORKSHOP>/system:openai-key  manual


The connection persists across :command:`workshop refresh`,
including a refresh that changes the slot's attributes.
To withdraw access, disconnect the plug:

.. code-block:: console

   $ workshop disconnect <WORKSHOP>/<SDK>:<PLUG>


Use the secret
~~~~~~~~~~~~~~

Run the SDK's commands as usual.
The SDK asks for the secret at the moment it needs the value,
and |ws_markup| looks it up in the host keyring for each request,
so the workshop never stores the value.
While the plug stays connected,
any command in the workshop can request the value the same way.


Fix failed lookups
~~~~~~~~~~~~~~~~~~

A connection doesn't guarantee that the lookup succeeds,
because |ws_markup| asks the keyring only when the value is requested.
How a failure surfaces depends on the SDK.
To see the reason,
request the value yourself and discard it,
so that only an error reaches your terminal:

.. code-block:: console

   $ workshop exec <WORKSHOP> -- sh -c 'workshopctl get-secret <SDK>.<PLUG> > /dev/null'

     error: checking secret retrieval change <ID>: cannot perform the following tasks:
     - Retrieve secret "<WORKSHOP>/<SDK>:<PLUG>" (... retrieving system secret: secret provider is locked)


The end of the error names the cause:

.. list-table::
   :header-rows: 1
   :widths: 2 3 4

   * - Error ends with
     - Cause
     - Fix
   * - :samp:`secret provider is locked`
     - The keyring collection is locked.
     - Unlock the keyring in your desktop session,
       then run the command again.
   * - :samp:`secret not found`
     - No item in the collection carries all the slot's attributes.
     - Compare the slot with :command:`secret-tool lookup`
       using the same attributes,
       correct the slot's :samp:`attributes` or :samp:`collection`,
       then run :command:`workshop refresh`;
       the connection stays in place.
   * - :samp:`multiple secrets match the request`
     - Several items carry all the slot's attributes.
     - Add an attribute to the slot that only the intended item carries,
       then run :command:`workshop refresh`,
       or remove the other items from the keyring.
   * - :samp:`secret plug is not connected`
     - The plug isn't connected to the slot.
     - Connect it as described in :ref:`how_provide_secrets_connect`.


Pass a secret to a single command
---------------------------------

For a one-off command that you run yourself,
pass the value as an environment variable
of a single :command:`workshop exec` or :command:`workshop run` invocation
with the :option:`!--env` flag.

The safer form takes the value from your calling shell.
Set the variable without typing the value on the command line,
then name it in :option:`!--env`:

.. code-block:: console

   $ read -rs OPENAI_API_KEY && export OPENAI_API_KEY
   $ workshop exec --env OPENAI_API_KEY <WORKSHOP> -- <COMMAND>


If the named variable isn't set in your calling shell,
|ws_markup| skips it without an error
and runs the command without it,
so check that the variable is set first.

You can also supply the value directly,
but then it lands in your shell history:

.. code-block:: console

   $ workshop exec --env OPENAI_API_KEY=<VALUE> <WORKSHOP> -- <COMMAND>


Either way, the value exists only for that invocation:
the command and every process it starts can read it,
and the next command in the workshop doesn't see it.
Nothing persists in the workshop,
but the variable stays in your calling shell until you remove it:

.. code-block:: console

   $ unset OPENAI_API_KEY


See also
--------

Explanation:

- :ref:`exp_plugs_slots`


Reference:

- :ref:`ref_workshop_connect`
- :ref:`ref_workshop_connections`
- :ref:`ref_workshop_disconnect`
- :ref:`ref_workshop_exec`
- :ref:`ref_workshop_run`
