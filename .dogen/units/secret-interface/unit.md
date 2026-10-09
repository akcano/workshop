---
title: "Secret interface"
intent: "explanation"
audience: "Workshop users who write the secret slot in a workshop definition and SDK authors who declare the secret plug in an SDK definition, the same readers as the two secrets how-tos. The runtime behavior (connection and delivery) is explained mainly for SDK authors."
targets:
  - "explanation/interfaces/secret-interface.rst"
  - "reference/definition-files/_interfaces/secret.rst"
  - "reference/definition-files/workshop-definition.rst"
  - "reference/definition-files/sdk-definition.rst"
  - "reference/definition-files/sdkcraft-definition.rst"
  - "reference/sdks.rst"
  - "explanation/interfaces/index.rst"
  - "explanation/interfaces/concepts.rst"
  - "explanation/interfaces/plugs-and-slots.rst"
  - "index.rst"
  - "security.md"
sources:
  - "internal/interfaces/builtin/secret.go"
  - "internal/overlord/ifacestate/helpers.go"
  - "internal/overlord/secretstate/getsecret.go"
  - "internal/overlord/secretstate/failure.go"
  - "internal/overlord/hookstate/ctlcmd/getsecret.go"
  - "internal/overlord/hookstate/handlers.go"
  - "internal/secrets/provider/secretservice/secretprovider.go"
  - "internal/workshop/lxd/cloudconfig.go"
  - "cmd/workshopctl/getsecret.go"
  - "tests/main/interface-secret/task.yaml"
  - "docs/how-to/develop-with-workshops/provide-secrets.rst"
  - "docs/how-to/develop-sdks/use-secrets.rst"
  - "docs/reference/cli/workshopctl.rst"
  - "docs/explanation/interfaces/ssh-interface.rst"
  - "docs/reference/definition-files/_interfaces/ssh-agent.rst"
notes: "Base branch: docs/secrets-how-tos (secrets-implementation at 7786e6b3 plus the reviewed how-tos), merged into dogen at 14025eda; read every source at that tip and describe only behavior it implements. Pages pop off onto docs/secrets-how-tos, not main. Anchors: exp_secret_interface on the explanation page, with exp_secret_plug and exp_secret_slot section labels as on ssh-interface.rst; ref_secret_interface for the new section in reference/sdks.rst. The _interfaces/secret.rst snippet follows its siblings: header comment, no top-level label, plug and slot described in the ssh-agent.rst shape plus an attribute table for the slot keys; include it after mount.rst in all three definition pages (the walked use-secrets how-to declares interface: secret in sdkcraft.yaml). The extra targets mirror their reference siblings and are not explanation prose. Toctree: secret-interface goes between mount-interface and ssh-interface in the Data and connectivity group, whose intro sentence gains host keyring secrets. Home page: a Secrets slice in Shared resources with the explanation, the reference, how_provide_secrets and how_use_secrets. plugs-and-slots.rst: a row secret / regular / system / No, and the connections: paragraph names secret beside ssh-agent as not wirable, because the base declaration denies auto-connection outright (ifacestate/helpers.go auto-explicit applies only where policy allows it). Terminology: name the freedesktop Secret Service once, then say host keyring; describe delivery as an on-demand lookup, never as a value passed down or configured into the workshop. Out of scope: back-links from use-secrets.rst and provide-secrets.rst (follow-up steering on those units), the workshopctl reference, schema-sdk.json and schema-sdkcraft.json (regenerated from sdkcraft), schema.json (interface-agnostic), coverage.md, release notes, the tutorial."
---
## Intent & scope

Every other interface has an explanation page, a definition-reference snippet,
and an entry in each interface listing; the secret interface has only its two
how-tos and the workshopctl reference. This unit brings it to parity.

Workshop users write the secret slot in the workshop definition and SDK authors
declare the secret plug in the SDK definition, so both read the grammar. The
explanation of runtime behavior is written mainly for SDK authors.

The explanation covers the minutiae the how-tos leave out: the YAML grammar of
the plug and the slot, how connections behave at runtime, and how a secret
value reaches a process in the workshop through an on-demand lookup.

## Outline / acceptance

Explanation page:

- What the interface does: it lets a regular SDK use a credential held in the
  user's host keyring without the value appearing in any definition.
- The plug: declared by a regular SDK only, under any name, with no attributes.
- The slot: provided only by the system SDK and written in the workshop
  definition; it carries lookup attributes and an optional collection, never
  the value.
- Connection: never connected automatically and not wirable through the
  workshop definition's connections list; the user connects and disconnects it
  explicitly; the connection persists across refresh, including a refresh that
  changes the slot's attributes; what the connections listing shows.
- Delivery: nothing is fetched in advance; every request is a fresh lookup in
  the host keyring; the value goes only to the requesting process and no copy
  stays in the workshop; the two request paths are a command calling
  workshopctl get-secret and a systemd unit loading the value as a credential
  through the workshop secret socket.
- Each request leaves a change in the workshop's change history, which is the
  audit trail.
- The failure causes a reader meets, with exit codes left to the workshopctl
  reference.
- Exposure: while the plug is connected, any process in the workshop can
  request the value; disconnect it when it isn't needed.
- See also: both how-tos, the workshopctl reference, the interface concepts,
  plugs and slots, and the definition references.

Reference:

- A secret snippet in the shape of its siblings, included in the workshop,
  SDK and SDKcraft definition pages.
- A secret interface section in the SDKs reference, plus its entry in the list
  of supported interfaces.

Listings:

- The interface concepts list and its paragraph on manually connected
  interfaces, the auto-connection table in plugs and slots, the interfaces
  toctree, the home page's shared resources domain, and the providers list in
  the security overview.

Acceptance: every place that lists the seven existing interfaces lists the
secret interface too, and every claim checks out against the sources at the
base branch tip.
