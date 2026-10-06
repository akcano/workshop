---
title: "How to provide secrets to a workshop"
intent: "how-to"
audience: "Workshop users whose workshop includes an SDK that needs a credential at runtime (for example, an API key for an AI coding agent), who keep that credential in their host keyring and want the SDK to use it without writing it into the workshop definition, the project, or shell history. Readers who need a one-off value for a single command are pointed to invocation-time environment injection."
targets:
  - "how-to/develop-with-workshops/provide-secrets.rst"
  - "how-to/develop-with-workshops/index.rst"
sources:
  - "cmd/workshop/exec.go"
  - "docs/reference/cli/workshop-exec.rst"
  - "docs/reference/cli/workshop-run.rst"
  - "docs/reference/cli/workshop-connect.rst"
  - "docs/reference/cli/workshop-connections.rst"
  - "docs/how-to/develop-with-workshops/use-workshops-with-ai-agents.rst"
  - "docs/how-to/customize-workshops/add-mounts.rst"
notes: "Anchor how_provide_secrets. Index entry 'Provide secrets to a workshop <provide-secrets>' goes alphabetically in the 'Integrate with development workflows' toctree. WALK GATE: run the evidence walk against a workshop build of canonical/workshop secrets-implementation at ae7134e8, where the secrets provider stack (#1037, #1040, #1055) and its follow-ups have merged; drop any checkpoint that build does not support instead of describing planned behavior. This docs PR targets main and does not open until secrets-implementation merges into main; then steer, re-plan the steps without reuse, re-read the branch-only sources and re-walk against main's build, and redraft from that walk. Branch-only sources to read at ae7134e8: internal/interfaces/builtin/secret.go, cmd/workshopctl/getsecret.go, internal/secrets/provider/secretservice/, tests/main/interface-secret/. Scenario: an OpenAI API key consumed by opencode or a similar Store SDK; use whichever candidate declares a secret plug at walk time, and stop to re-plan if none does. Terminology: name the freedesktop Secret Service once, then say 'host keyring'. Link to WSP-1164 explanation and reference anchors only if they exist at draft time. No '.. @tests' marker: regression coverage is WSP-1164. Out of scope: docs/reference/cli/workshop-exec.rst and workshop-run.rst (generated from cmd/workshop/exec.go; link one-way to ref_workshop_exec and ref_workshop_run instead), secrets-interface explanation, definition and schema reference, workshopctl reference, runtime socket and hook contracts, architecture, security, release notes, generated schemas. Optional code follow-up outside this unit: extend the --env flag help in cmd/workshop/exec.go to say an absent inherited name is skipped."
---
## Intent & scope

Readers run a workshop whose SDK needs a credential at runtime, such as an
OpenAI API key for an AI coding agent, and they keep that credential in their
host keyring. This page gets the credential to the SDK without the value ever
landing in the workshop definition, the project, or shell history.

The page offers two paths and helps the reader pick one first. The reusable
path points a system slot at the keyring item and grants access by connecting
the SDK's plug; it survives refreshes and needs no retyping. The ad hoc path
injects an environment variable into a single exec or run invocation; it
suits a one-off command the reader controls directly.

Scope is the procedure, its verification, and failure handling. The page
describes only behavior the merged secrets build exhibits, and it leaves the
concept explanation, the definition and schema reference, and the workshopctl
reference to their own pages.

## Outline / acceptance

Start state: a Workshop build that carries the secrets interface, a desktop
session whose Secret Service keyring holds the credential, and a workshop
definition that includes an SDK declaring a secret plug.

End state: the SDK's command inside the workshop authenticates with the
credential from the host keyring, the reader has confirmed the connection,
and they know what to do when retrieval fails. For the ad hoc path, one
invocation received the value and nothing persisted in the workshop.

Checkpoints the page must land:

- The choice between the two paths comes first, framed by what persists and
  who can see the value, not by mechanism names.
- Prerequisites name the supported host keyring and what lookup depends on:
  the keyring service running in the desktop session, the item stored with
  identifying attributes, and the collection the lookup searches by default.
- The reader describes where the secret lives by adding a slot to the
  workshop definition that carries lookup attributes only, never the value.
- Consent is explicit: the plug stays disconnected after launch and refresh
  until the reader connects it. The reader confirms the connection in the
  connections listing, and learns that it persists across refresh and that
  disconnecting withdraws access.
- The reader runs the SDK's command as usual, and the SDK fetches the
  credential at the moment of use.
- Connecting does not guarantee retrieval: at consumption time the keyring
  may be locked, or the attributes may match no item or several. Each case
  is described by what the reader sees and how to fix it.
- The ad hoc path covers both forms: an inherited name takes the value from
  the calling shell, and a name with a value supplies it directly. An
  inherited name that is absent from the calling shell is skipped without
  any error, so the command runs without it.
- The ad hoc path states its exposure and cleanup limits: the value is
  visible to the process and its children for that invocation, an explicit
  value lands in shell history, and the inherited form is the safer default.
  Nothing persists in the workshop, but the calling shell is the reader's to
  clean up.
- The page warns against placing a secret in the workshop definition,
  actions, project files, or shell profiles.
