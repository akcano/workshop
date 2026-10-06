---
title: "How to use secrets in an SDK"
intent: "how-to"
audience: "SDK authors whose SDK runs a one-shot command or a long-running service that needs a user's credential at runtime, and who must choose how the SDK receives it without shipping or logging the value. Assumes they already declare plugs and write runtime hooks."
targets:
  - "how-to/develop-sdks/use-secrets.rst"
  - "how-to/develop-sdks/index.rst"
  - "how-to/develop-sdks/declare-plugs-slots.rst"
  - "explanation/sdks/best-practices.rst"
sources:
  - "cmd/workshop/exec.go"
  - "docs/how-to/develop-sdks/declare-plugs-slots.rst"
  - "docs/how-to/develop-sdks/write-runtime-hooks.rst"
  - "docs/explanation/sdks/best-practices.rst"
  - "docs/reference/cli/workshopctl.rst"
  - "docs/reference/cli/workshop-exec.rst"
  - "docs/reference/cli/workshop-run.rst"
notes: "Anchor how_use_secrets. Index entry 'Use secrets in an SDK <use-secrets>' goes alphabetically in the develop-sdks toctree. Cross-links: one pointer sentence in declare-plugs-slots.rst next to the line scoping its examples to mount and tunnel, and one in the 'System services' section of best-practices.rst, both pointing to how_use_secrets. use-secrets links one-way to how_provide_secrets for the user side; provide-secrets does not link back. WALK GATE: run the evidence walk against a workshop build of canonical/workshop secrets-implementation at ae7134e8, where the secrets provider stack (#1037, #1040, #1055) and its follow-ups have merged; drop any checkpoint that build does not support instead of describing planned behavior. This docs PR targets main and does not open until secrets-implementation merges into main; then steer, re-plan the steps without reuse, re-read the branch-only sources and re-walk against main's build, and redraft from that walk. Branch-only sources to read at ae7134e8: internal/interfaces/builtin/secret.go, cmd/workshopctl/getsecret.go, internal/overlord/hookstate/handlers.go (SDK_SYSTEMD_SECRET_SOCKET in hooks), internal/secrets/provider/secretservice/, and the workshopctl reference as it stands there. Link to WSP-1164 explanation and reference anchors only if they exist at draft time. No '.. @tests' marker: regression coverage is WSP-1164. Out of scope: docs/reference/cli/workshop-exec.rst and workshop-run.rst (generated from cmd/workshop/exec.go; link one-way to ref_workshop_exec and ref_workshop_run instead), the workshopctl get-secret reference, secrets-interface explanation, definition and schema reference, runtime socket and hook contracts, architecture, security, release notes, generated schemas."
---
## Intent & scope

SDK authors whose SDK needs a user's credential at runtime choose how the SDK
receives it, then implement that choice without the value ever appearing in
SDK content or logs. The page is organized around the decision: a reusable
one-shot command fetches the secret through a wrapper at call time, a
reusable long-running service receives it as a systemd credential, and
invocation-time environment injection stays a user-controlled, ad hoc path
the SDK never depends on.

Scope is choosing, implementing, verifying, and handling failures for each
mechanism. The page describes only behavior the merged secrets build
exhibits, and it leaves the interface explanation, the definition and schema
reference, the workshopctl reference, and the runtime contracts to their own
pages.

## Outline / acceptance

Start state: an SDK project the author can build and try in a workshop, with
plugs and runtime hooks already familiar, and a Workshop build that carries
the secrets interface.

End state: the SDK declares a secret plug, and after a user connects it,
either the SDK's command or its service obtains the credential. The author
has exercised the success path and the expected failures in a test workshop.

Checkpoints the page must land:

- A short decision guide opens the page: one-shot command, long-running
  service, or deliberate user-supplied value, each mapped to its mechanism
  with the reason.
- Declaring the secret plug, with its limits stated as consequences: users
  must connect it explicitly, it is never connected automatically, and the
  slot describing the keyring item belongs to the user's workshop, not the
  SDK. The author points users to the Workshop-user guide for connecting.
- For a one-shot command, a wrapper fetches the secret with workshopctl
  get-secret each time it runs and hands it to the tool without echoing it,
  exporting it to a profile, or writing it to disk. The wrapper turns each
  retrieval failure (keyring locked, no single matching item, system error)
  into an actionable message and a non-zero exit.
- For a long-running service, the unit the SDK installs requests the secret
  with LoadCredential= against the workshop's secret socket, and the service
  reads it from its file under $CREDENTIALS_DIRECTORY. The page shows what a
  failed retrieval does to the service start and where the author and user
  see why.
- The ad hoc path appears only as something users do: workshop exec --env
  and workshop run --env, with inheritance, direct assignment, and the
  silently skipped absent name. The SDK must work without it.
- Each mechanism states its exposure, lifetime, and cleanup limits: what
  outlives the call or the service run, what child processes can read, and
  what the SDK cannot clean up for the user.
- A warning names the places a secret must never go: SDK content,
  sdkcraft.yaml, workshop definitions, hooks, shell profiles, examples, and
  logs.
