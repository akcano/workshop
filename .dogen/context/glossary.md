# Workshop glossary

These terms are taken from the documentation prose under `docs/` on the `dogen`
branch at HEAD 7e2f3b79, as the pages use them. Definitions follow the pages that
use each term most consistently. The Notes column flags each place where pages
disagree or a term goes undefined. Product names follow `docs/doc-style-guide.md`:
"Workshop" for the product, "workshop" for an environment, "SDK" and "SDKs", and
"SDKcraft".

| Term | Definition | Aliases | Notes |
|------|------------|---------|-------|
| `$SDK` | Variable set for hooks and mounts: the path where the SDK's content is mounted in the workshop. | `:envvar:`SDK`` | Written both with and without the `$` inside `:envvar:` (build-an-sdk.rst vs declare-plugs-slots.rst). It expands in mount paths. |
| `$SDK_STATE_DIR` | Variable set for hooks: a per-SDK directory for state that `save-state` and `restore-state` carry across a refresh. | SDK state | Its lifetime is contradicted: "gone as soon as the workshop stops" (build-an-sdk.rst) vs "survives the refresh" (write-runtime-hooks.rst). |
| `.workshop.lock` | Hidden file that binds a project directory to its workshops; it must not be committed or copied. | — | explanation/workshops/projects.rst says workshops update if a project is "moved or copied", but says the lock "must not be copied". |
| action | A named shell script under `actions:` in a workshop definition, run with `workshop run`. Actions are read from the definition on every run. | named action (readme.rst) | Collides with task: "*tasks*, or individual actions" (debug-issues.rst). The invocation appears three ways: `run -- analyzer` (readme.rst), `run dev -- pull` (tutorial part 1), `run dev lint` (contributing/development.rst). |
| auto-connection | A connection that Workshop makes without user action when the interface's policy allows it. | auto-connect (verb), auto-connected | Always hyphenated; never "autoconnect". Per-interface policy is in plugs-and-slots.rst, which marks mount "Partial". interfaces/concepts.rst lists mount simply as "(auto-connected)". |
| base | The Ubuntu image that a workshop or SDK builds on, written `ubuntu@<VERSION>`. | base image, base system | Defined at `exp_base`, never in the tutorial. The reference lists 22.04, 24.04 and 26.04. The code still accepts 20.04, with a deprecation warning. |
| base snapshot | The snapshot taken after `setup-base` runs, which later refreshes reuse. | — | Ambiguous: architecture/runtime-behavior.rst also uses it for "restoring to base snapshot" before a refresh. |
| binding | Making one plug share another plug's target, written `bind: <SDK>:<PLUG>`. `workshop connections` shows it as a `bind.1` note. | plug binding, bound plug | plugs-and-slots.rst says bindings suit plugs "with overlapping attributes". The code requires identical attributes. |
| camera interface | Passes the host's video4linux and media devices into a workshop. | — | The `_interfaces/camera.rst` snippet says the plug name must be `camera`. reference/sdks.rst shows `<NAME>`. |
| change | A major workshop operation (launch, refresh, connect and so on) that the daemon tracks and `workshop changes` lists. A change is made of tasks. | — | Defined in tutorial part 1 and changes-tasks.rst. components.rst defines it differently ("high-level modification to the system state"). The STATUS values (Do, Doing, Done, Undo, Undoing, Undone, Hold, Error, Wait, Abort) are never explained. |
| channel | Where an SDK is tracked in the Store, written `[<TRACK>/]<RISK>[/<BRANCH>]`. The default is `latest/stable`. | — | Only Store SDKs have channels. Examples vary: `1.26`, `1.26/stable`, `edge`, `latest/edge`. |
| check-health | The runtime hook that reports SDK health with `workshopctl set-health`. It is retried up to 10 times. | health check | use-virtual-machines.rst uses "health check" without defining it. |
| connection | A link between a plug and a slot. It is made automatically, at runtime with `workshop connect`, or declaratively under `connections:`. | manual connection (NOTES column: `manual`) | workshops/concepts.rst separates three kinds: auto-connections, manual runtime connections, and manual disconnects of an auto-connection. |
| `connections:` | The top-level list in a workshop definition that wires plugs to slots. | connections entry, connections block | Called an "entry" on most pages and a "block" in manage-python-environments.rst. |
| custom-device interface | Passes a host device into a workshop, matched by `subsystem`, `vendorid` or `productid`. | custom device interface, Custom device (page title) | `custom-device` in literals, "custom device" in prose. That the IDs must be hexadecimal is not documented. |
| desktop interface | Exposes the host display server (Wayland or X11) and its environment variables to a workshop. | — | reference/sdks.rst describes only "host's Wayland socket". |
| eject | Turning a sketch SDK into an in-project SDK under `.workshop/`, with `workshop sketch-sdk --eject`. | — | Covered only in tutorial part 3. |
| endpoint | The tunnel attribute that names a TCP or UDP port, or a Unix socket. | — | The reference types it as a string. The examples (and the code) also take an integer port. |
| gpu interface | GPU pass-through into a workshop; auto-connected. | GPU interface | `gpu` in literals, "GPU interface" in prose. |
| graft | Adding plugs or slots to an SDK from a workshop definition. | — | Used in workshops/concepts.rst and best-practices.rst. sdk-vs-dockerfile.rst contradicts it: "the user can't create arbitrary mounts". |
| guardrail | A Store restriction on which tracks a publisher may create. | — | Defined only in publish-an-sdk.rst ("Guardrails are not self-service."). lifecycle.rst uses it undefined. |
| health | The `okay`, `waiting` or `error` value that an SDK reports through `check-health`. | SDK health, SDK state, status | workshop-status.rst calls these "SDK states" to distinguish them from workshop statuses. reference/sdks.rst also uses "SDK state" for `$SDK_STATE_DIR` data. build-an-sdk.rst greps for `status: okay`. |
| hostname | The DNS name a workshop gets: `<WORKSHOP>.<PROJECT>.wp`, with an ID-based fallback (`hostname-fallback` note). | host names (v0.9.2), `.wp` name | Pages disagree on which name is canonical (workshops/concepts.rst vs architecture/components.rst). |
| in-project SDK | An SDK defined under `.workshop/<NAME>/` in the project and referenced as `project-<NAME>`. | project SDK (v0.9.2) | Its `name` must match the directory name; the code enforces this but no page says so. share-content-between-sdks.rst uses the `project-` prefix without explaining it. |
| interface | A typed mechanism for sharing a resource between SDKs, workshops and the host. Users cannot add new types. | — | Seven are implemented: camera, custom-device, desktop, gpu, mount, ssh-agent, tunnel. Grammar slip in interfaces/concepts.rst: "Interfaces are… It is". |
| launch | Building a workshop from its definition for the first time, with `workshop launch`. | — | "the one-time builder"; it fails if the workshop already exists. |
| LXD project | The LXD namespace that holds a user's workshops, `workshop.<USERNAME>`, with snapshots in `workshop-snapshots.<USERNAME>`. | — | Easily confused with a Workshop *project*. fix-installation.rst writes `workshop.<USER>`; purge.rst writes `workshop.<USERNAME>`. |
| mount interface | Shares a directory into a workshop at `workshop-target`, optionally from `workshop-source`, or from a `host-source` set by remount. | — | Attributes: `read-only`, `mode`, `uid`, `gid`. `$SDK` expands in paths. `$$` escapes a literal `$`, which is undocumented. |
| orphaned workshop | A workshop whose project directory was deleted; it is flagged with the `missing-project` note. | — | Covered in purge.rst and projects.rst. fix-installation.rst skips the safer recovery steps that purge.rst describes. |
| part | A Craft Parts build unit in `sdkcraft.yaml`, built by a plugin such as `dump`, `nil` or `rust`. | building block | `nil` is never explained. Parts forbid `stage-packages`: sdkcraft-definition.rst says "forbids", reference/sdks.rst says "aren't enabled yet". |
| platform | Where an SDK builds and runs, given as `build-on` and `build-for` pairs. | — | reference/sdks.rst and sdkcraft-definition.rst give different types for both keys. |
| plug | The consumer end of an interface, declared by an SDK or grafted onto it by a workshop. Written `<WORKSHOP>/<SDK>:<PLUG>`. | — | forward-ports.rst glosses it as "the listening side". The `:mount` shorthand for the system SDK's slot goes unexplained. |
| project | A host directory holding one or more workshop definitions. It is mounted at `/project/` in each workshop. | project directory | Collides with LXD project. Written both `/project` and `/project/`. |
| project ID | The final dash-separated segment of a workshop's container name. | `<PROJECT-ID>` | Defined in purge.rst. |
| refresh | Applying definition edits and SDK updates to an existing workshop, incrementally, with rollback on failure. | — | Keeps manual connections; restore discards them. |
| remount | Pointing an existing mount plug at a different host source with `workshop remount`. Undone with `disconnect --forget` followed by a refresh. | source override, share source, custom source, override | add-mounts.rst uses five names for this one concept. |
| restore | Reverting a workshop to its last good state, ignoring edits to the definition. | — | Tutorial part 1 describes it as "the most recent snapshot" but never runs it. It resets connections. |
| revision | An immutable upload of an SDK to the Store. | — | Sketch SDKs show `x1`. |
| risk | The stability level in a channel: stable, candidate, beta or edge. | risk level | Tutorial part 1 says "four risk levels". |
| runtime | The workshop backend: `lxd-container` (the default) or the experimental `lxd-vm`. | confinement (v0.9.7 release notes) | Renamed from `confinement` after 0.9.7. The workshop-definition reference has no row for it. "run-time" with a hyphen means execution time elsewhere. |
| runtime hook | A bash script an SDK ships, which Workshop runs at a fixed point: `setup-base`, `setup-project`, `save-state`, `restore-state`, `check-health`. | hook, lifecycle hook, setup hook | "Lifecycle" is overloaded across workshop, SDK, parts and service lifecycles. |
| SDK | A versioned, reusable bundle of tools, content, hooks and interfaces, composed into a workshop. | — | Defined in three ways: "packages of software dependencies", "pre-built, reusable blocks", "independent units of functionality". Always uppercase; the plural is "SDKs". |
| `sdk` CLI | The host command for discovering SDKs: `sdk find`, `sdk info`, `sdk list`. | — | publish-an-sdk.rst names it once without introducing it. |
| SDK definition | The files that describe an SDK: `sdkcraft.yaml` (build-time, read by SDKcraft) and `sdk.yaml` (runtime, read by Workshop). | SDKcraft project definition (for `sdkcraft.yaml`) | Tutorial parts 3 and 4 each call a different file "the definition" while linking the same label. |
| SDK Store | The service where SDKs are registered, uploaded and released. | the Store, the store | Lowercase "store" appears in the generated sdkcraft pages. |
| SDK volume | How `sdk list` counts an SDK on disk. | — | Never defined beyond tutorial part 1. |
| SDKcraft | Workshop's sibling tool, which builds, tests and publishes SDKs; written `|sdk_markup|`. | `sdkcraft` (the CLI, under `:program:`) | Never "Sdkcraft". Called "the user-oriented CLI utility" (part 4) but "aimed at publishers" (index.rst). |
| secret interface | Interface used by use-secrets.rst and provide-secrets.rst to read host keyring values with `workshopctl get-secret`. | — | Appears only on the `dogen` branch, ahead of the code: this checkout implements no `secret` interface and no `get-secret`. No explanation, reference snippet or schema exists. |
| sketch SDK | A local draft SDK named `sketch`, edited with `workshop sketch-sdk` and installed last. | sketch, sketching | Stored under `$XDG_DATA_HOME/workshop/`. sdks/concepts.rst says "you define it inside the workshop", and readme.rst says sketches live in the repository. |
| slot | The provider end of an interface. | — | The system SDK owns every host-backed slot. |
| snapshot | A ZFS or Btrfs snapshot of workshop state, taken per SDK. Restore returns to the latest good one. | chain of snapshots | The tutorial uses it without a definition. |
| Sphinx Stack | Canonical's documentation starter pack, which builds these docs. | starter pack, SP | Appears only in the contributing pages. |
| ssh-agent interface | Exposes the user's SSH agent socket inside a workshop. | SSH agent interface, SSH interface, `ssh` | Four names for one interface. reference/sdks.rst instead says it proxies "keys and configuration". |
| stash | Setting the sketch SDK aside without deleting it (`--stash`, `--restore`). | — | Appears in debug output without explanation. |
| system SDK | The built-in SDK embedded in the daemon. It installs first and owns the host-backed slots. | `system`, built-in system SDK | Notation: `system:mount`, or the shorthand `:mount`. Pages contradict each other on whether it runs hooks (sdks/concepts.rst vs workshops/concepts.rst). |
| task | One step within a change, listed by `workshop tasks <CHANGE-ID>`. | — | Collides with "action" in debug-issues.rst. |
| track | The first segment of a channel, usually an upstream release line (`1.26`, `24`). | — | Defined only in publish-an-sdk.rst. explanation/cli.rst and lifecycle.rst use it undefined. |
| try SDK | A locally built SDK that `sdkcraft try` places in the try area (`$XDG_DATA_HOME/workshop/try/`), referenced as `try-<NAME>`. | try area, locally tried SDK | Defined in tutorial part 4 and build-an-sdk.rst. |
| tunnel interface | Forwards a TCP, UDP or Unix-socket endpoint between the plug side and the slot side. | — | `$HOME` and `$XDG_RUNTIME_DIR` expand in socket paths. Endpoints must be loopback unless stated otherwise. |
| virtual machine | The experimental workshop runtime `lxd-vm`, enabled with the `workshop.experimental-vms` snap option. | VM | Explanation pages describe workshops as containers only. |
| warnings | System-wide notices from the daemon, read with `workshop warnings` and acknowledged with `workshop okay`. | — | The banner the CLI prints after a command is undocumented. |
| Workshop | The product; written `|ws_markup|` in rST. | Workshop (plain text in Markdown and the readme) | Always capitalized. Plain "Workshop" sometimes slips into rST prose. |
| workshop | One development environment: an LXD system container (or a VM) built from a workshop definition. | workshop container | Lowercase: "(lowercase; not to be confused with |ws_markup| itself)" (workshops/concepts.rst). |
| workshop definition | The YAML file Workshop reads to launch a workshop: name, base, SDKs, plugs, slots, connections, actions. | definition, definition file, workshop definition file, workshop file, `workshop.yaml`, `.workshop.yaml`, `.workshop/<NAME>.yaml` | The most variant-heavy term in the docs. definition-files/index.rst names only `workshop.yaml`, while its examples use `.workshop/<NAME>.yaml`. |
| workshop status | The state Workshop reports for a workshop: Off, Ready, Stopped, Waiting, Pending or Error. | state | Written italic and capitalized in prose (*Ready*), uppercase in diagrams, and lowercase `ready` in `workshop info`. The style guide's sample output shows "Running", which is not a status. Pages mix "state" and "status". |
| workshopctl | The helper CLI available inside a workshop to hooks. Its documented command is `set-health`. | — | components.rst says it serves "service-related and reporting tasks". runtime-hooks.rst says health is "The only possible use at the moment". |
| workshopd | The host daemon. It exposes a REST API over Unix sockets and orchestrates changes. | the daemon | Its debug switch (snap option `workshop.debug`) is undocumented outside contributing/development.rst. |

Closing note: this table covers the whole prose set except the generated CLI command
pages, which were sampled. It deliberately leaves out generic terms (API, YAML,
container) and LXD vocabulary used only in passing.
