# Workshop documentation structure and coverage

Scope: the user documentation under `docs/`, which comes to 97 prose pages plus the
generated CLI reference. It was cross-read against the product surface in `cmd/`,
`internal/`, `client/` and `snap/` at HEAD 7e2f3b79 on the `dogen` branch. The code
on this branch is identical to `main`. The docs differ from `main` only by two
secrets how-tos and one linking sentence in `explanation/sdks/best-practices.rst`.

## 1. Documentation topology

**Root: `docs/index.rst`.**
- Its toctrees are hidden. The first holds Home, tutorial, how-to, reference and
  explanation. The second holds Release notes, Contribute and Security.
- The visible body is a subject directory, "In this documentation", built with the
  `sphinx_structured_toc` directives `.. domain::` and `.. slice::` (adapter in
  `docs/_extensions/structured_toc.py`). It has ten subjects, in this order:
  1. Getting started
  2. Concepts and architecture
  3. Using workshops
  4. Workshop configuration
  5. SDK development
  6. Shared resources
  7. Tool integrations
  8. Maintenance
  9. Security
  10. Use cases
- Directory items cut across the Diátaxis pillars and link to section labels. A
  trailing `domain` token marks an item listed under more than one subject on
  purpose.
- After the directory come "How this documentation is organized" (a Diátaxis
  explainer) and "Project and community".

**Pillar landings:**
- `tutorial/index.rst`: a visible toctree, Part 1 to Part 4.
- `how-to/index.rst`: Customize workshops, Develop with workshops, Develop SDKs, Fix
  workshops.
- `explanation/index.rst`: Architecture, Workshops and projects, SDKs, Interfaces,
  Command-line tools, Security considerations.
- `reference/index.rst`: CLI, Definition files, SDK internals, Workshop internals,
  Workshop status, AI agents, Reference implementations.

**Sub-landings.**
- Each pillar index reaches its sub-landings through single-entry flat toctrees.
- Inside a sub-landing, pages are ordered alphabetically by file name, not by
  workflow. For example, develop-sdks runs Build, Configure a mount, Declare plugs
  and slots, Publish, Share content, Use secrets, Write runtime hooks, so Publish
  sits mid-list.
- Several sub-landings have no anchor label, and their titles diverge from the
  pillar text. `how-to/customize-workshops/index.rst` is titled "How to use
  workshops".

**CLI reference.**
- `reference/cli/index.rst` leads to four tool pages: `workshop.rst`, `sdk.rst`,
  `sdkcraft.rst` and `workshopctl.rst`.
- The per-command files are generated and pulled into their tool page with
  `.. include::`. `docs/conf.py` excludes them from building standalone, so a label
  such as `ref_workshop_launch` resolves to a section of `workshop.rst`.
- The sdkcraft pages are copied over from the SDKcraft repository.
  `workshopctl.rst` is hand-written.

**Definition files.** `workshop-definition.rst`, `sdk-definition.rst` and
`sdkcraft-definition.rst` each include the seven `_interfaces/*.rst` snippets and a
JSON Schema dropdown.

**Release notes.** An index with a Workshop/SDKcraft version-pairing table and a
hidden toctree, newest first, duplicated by `:doc:` lists.

**Outside the navigation:**
- `doc-style-guide.md` and `coding-style-guide.md` (`:orphan:`).
- `readme.rst` (excluded from the build; rendered on GitHub).
- `404.rst`.

**Navigation verdict.**
- A new reader has two good entry points: the Getting started slice and the
  tutorial landing.
- The subject directory is thorough but long. It reaches many pages only as
  sections of other pages, such as the CLI commands.
- The pillar sub-landings are thin, and their titles and toctree text disagree with
  the pages they list.

## 2. Diátaxis coverage and balance

**Tutorial (5 pages).** A complete four-part arc: use, then interfaces, then sketch,
then craft.
- Concepts appear before they are introduced. Part 1 shows mounts, the system SDK,
  hook output and plugs before parts 2 to 4 introduce them.
- Part 1 links `tut_remove`, which lives at the end of part 3.
- Part 3 drifts toward a how-to ("your first option is", "In this guide").
- Part 4 explains hook semantics more than it exercises them, and it ends on
  "Summary" with no next steps.

**How-to (31 leaf pages, 6 landings).** The broadest pillar, but the most mixed.
- Explanation inside how-tos:
  - the intro of add-mounts.rst
  - the "Why do this?" section of forward-ports.rst
  - the networking section of use-multiple-workshops.rst
  - "SDK-installed software versions" in debug-issues.rst
- Pages that are not how-tos:
  - `customize-workshops/move-projects.rst` is explanation.
  - `develop-with-workshops/use-git.rst` and `use-workshops-with-ai-agents.rst` read
    as a tutorial and an essay.
  - `connect-vscode.rst` is a tutorial-shaped walkthrough.
  - `run-jupyterlab-in-browser.rst` is a stub.
- Absent how-tos:
  - the camera, desktop and ssh-agent interfaces (their worked examples live only in
    explanation pages)
  - restoring a workshop
  - asynchronous operation and change tracking
  - turning on Workshop daemon debug logging

**Reference.** The definition files, generated CLI and workshop-status pages are
strong. Elsewhere:
- `reference/sdks.rst` ("SDK internals") and `reference/workshops.rst` ("Workshop
  internals") are narrative and lean explanation. sdks.rst duplicates the interface
  reference and now contradicts it.
- `reference/ai-agents.rst` embeds procedures.
- No reference page exists for snap configuration options, environment variables, or
  change and task status values.

**Explanation (27 pages).** The richest pillar, with these weak spots:
- The per-interface pages follow one template that mixes reference (attributes) with
  how-to steps (connect, check, shell).
- `explanation/cli.rst` is mostly reference tables.
- `workshops/concepts.rst` is very long and mixes a status table, a compatibility
  policy and an origins table.
- `architecture/components.rst` and `runtime-behavior.rst` assume containers only
  and have no See also.
- No page explains the VM runtime.

## 3. Coverage gaps (code versus docs)

### Missing entirely

- [CODE↔DOCS GAP] Snap option `workshop.debug` (`snap/local/commands/run_daemon:6`
  exports `WORKSHOP_DEBUG`, which `internal/logger/logger.go` reads) is not mentioned
  in any user page. The one hit is contributing/development.rst, for a development
  build. debug-issues.rst and fix-installation.rst never say how to turn on daemon
  debug logging.
- [CODE↔DOCS GAP] Snap option `store.url` (`run_daemon:3` sets `SDK_STORE_URL`, read
  by `internal/sdkstore/client.go`) has 0 doc hits. The configure hook is empty, so a
  change takes effect only after `snap restart workshop.workshopd`. The code shows
  the option exists; whether it is meant for end users is a product call.
- [CODE↔DOCS GAP] Snap option `workshop.image.server.url` (`run_daemon:9` sets
  `WORKSHOP_IMAGE_SERVER`, read by `internal/workshop/lxd/lxd_backend.go`) has 0 doc
  hits. It is relevant to image mirrors and air-gapped hosts. As with `store.url`,
  whether it is meant for end users is a product call.
- [CODE↔DOCS GAP] CLI output controls `NO_COLOR`, `TERM=xterm-mono|linux-m` and
  `LANG`/`LC_*` (`cmd/internal/cmdutil/color.go`) have 0 doc hits. No `--color` flag
  exists, so the environment is the only control over table color and Unicode output.
- [CODE↔DOCS GAP] Change and task STATUS values (`internal/overlord/state/change.go`:
  Do, Doing, Done, Undo, Undoing, Undone, Hold, Error, Wait, Abort) are explained
  nowhere. The CLI pages say only "Reflects the change's progress", and
  explanation/workshops/changes-tasks.rst lists none of them.
- [CODE↔DOCS GAP] Path-variable rules for mount and tunnel paths
  (`internal/interfaces/builtin/mount.go`, `tunnel.go`) are not documented. `$$`
  escapes a literal `$`, and any variable other than `$SDK` (mount) or `$HOME` and
  `$XDG_RUNTIME_DIR` (tunnel) fails with "unexpected variable". `_interfaces/mount.rst`
  and `tunnel.rst` list only the supported expansions.
- [CODE↔DOCS GAP] An in-project SDK's `name` must equal its `.workshop/<NAME>/`
  directory, or the launch fails with "SDK must be named …"
  (`internal/workshop/workshop.go:121`). No page states the rule.
- [CODE↔DOCS GAP] custom-device `vendorid` and `productid` must be hexadecimal
  (`internal/interfaces/builtin/custom_device.go`: an optional `0x` prefix, "must be a
  hexadecimal number"). `_interfaces/custom-device.rst` says only that the value is
  quoted so it reads as a string.

### Raw reference only (no task workflow)

- [CODE↔DOCS GAP] Flag `--no-wait` on launch, refresh, restore, connect, disconnect
  and remount (`cmd/workshop/launch.go` and siblings) appears only on CLI pages. No
  page pairs it with `workshop changes` or `workshop tasks <ID>` to show asynchronous
  use.
- [CODE↔DOCS GAP] Flags `--uid`, `--gid`, `--timeout`, `-i/--interactive` and
  `-I/--non-interactive` on `workshop exec` and `workshop run` (`cmd/workshop/exec.go`)
  appear only on CLI pages. Task pages use `workshop exec dev -- sudo …` instead.
- [CODE↔DOCS GAP] `workshop warnings` flags `--all`, `--verbose`, `--abs-time` and
  `--unicode` (`cmd/workshop/warnings.go`) appear only on CLI pages.
  debug-issues.rst shows only the bare `workshop warnings` and `workshop okay`.
- [CODE↔DOCS GAP] Flag `--no-headers` on list, changes, tasks, connections,
  sketches, `sdk find` and `sdk list` appears only on CLI pages, so no scripting
  workflow uses it.
- [CODE↔DOCS GAP] Flags `--base` and `--arch` on `sdk info` (`cmd/sdk/info.go`)
  appear only on CLI pages.
- [CODE↔DOCS GAP] Flag `--code` on `workshopctl set-health`
  (`internal/overlord/hookstate/ctlcmd/health.go`) appears only on
  `reference/cli/workshopctl.rst`. No hook example passes a problem code.
- [CODE↔DOCS GAP] Plug and slot shorthand (`internal/sdk/sdk.go`,
  `convertToSlotOrPlugData`) is described only in schema.json. A string value names
  the interface, and `null` uses the key as the interface name.
  workshop-definition.rst and sdk-definition.rst present only the mapping form.

### Undiscoverable

- [CODE↔DOCS GAP] workshop.yaml field `runtime` (`lxd-container` or `lxd-vm`;
  `internal/workshop/workshop_file.go:246`) appears in
  how-to/customize-workshops/use-virtual-machines.rst, in `workshop init --runtime`
  and in the schema dropdown, but not in the field table of
  `reference/definition-files/workshop-definition.rst`. No explanation page mentions
  the VM runtime.
- [CODE↔DOCS GAP] Sketch SDK definition shape (`SketchSDKYaml` in
  `internal/sdk/sdk.go:143`; strict parse in `internal/sdk/validate.go`) appears only
  in tutorial part 3. The file accepts only `name`, `title`, `summary`,
  `description`, `hooks` (an inline hook-name-to-script map), `plugs` and `slots`.
  Yet sdk-definition.rst tells sketch authors to write `sdk.yaml` directly, and its
  table offers fields the sketch parser rejects.
- [CODE↔DOCS GAP] `workshop exec` and `workshop run` pass the command's exit status
  through (`cmd/workshop/main.go:43`, `client.ExitError`). No page says so, including
  run-workshops-in-github-actions.rst, which depends on it.
- [CODE↔DOCS GAP] Default exec environment (`internal/daemon/api_exec.go`):
  - Only `TERM` is forwarded from the host.
  - `HOME` and `USER` are set for the default user.
  - `LANG` defaults to `C.UTF-8`.

  The CLI page says only that "reasonable defaults are provided".
- [CODE↔DOCS GAP] The CLI prints a banner after a command, "WARNING: There are N new
  warnings. See "workshop warnings"." (`cmd/workshop/warnings.go:316`). No page says
  where warnings surface.
- [CODE↔DOCS GAP] SSH client configuration (`snap/local/lib/host-config`,
  `configure_openssh_client`) is installed into `/etc/ssh/ssh_config.d` only when
  that directory is writable. Pages say Workshop "generates an OpenSSH
  configuration" but give no path, so users on other hosts cannot wire it up by
  hand.

### Reference contradicts code

- [CODE↔DOCS GAP] Unknown keys in workshop.yaml are silently ignored:
  `internal/workshop/workshop_file.go` uses plain `yaml.Unmarshal`, without
  `KnownFields`. schema.json declares `additionalProperties: false`, and
  workshop-definition.rst is silent. A typo such as `chanel:` is dropped. So is the
  0.9.7 field `confinement: virtual-machine` (renamed to `runtime` after the tag), so
  a definition that uses it now launches a container instead.
- [CODE↔DOCS GAP] Base `ubuntu@20.04` is still accepted (`internal/sdk/validate.go:65`
  `AllowedBases`, reused for workshops), with a deprecation warning for workshops only.
  workshop-definition.rst, sdk-definition.rst and schema.json list only 22.04, 24.04
  and 26.04.
- [CODE↔DOCS GAP] Plug binding requires identical attributes and label
  (`internal/overlord/ifacestate/ifacemgr.go`, "plugs … have different attributes").
  explanation/interfaces/plugs-and-slots.rst says bindings suit plugs "with overlapping
  attributes", and workshop-definition.rst does not state the rule.
- [CODE↔DOCS GAP] The tunnel `endpoint` also accepts an integer port
  (`internal/interfaces/builtin/tunnel.go`, `normalizeEndpoint`), but
  `_interfaces/tunnel.rst` and schema-sdk.json type it as a string. The docs' own
  examples use integers (`endpoint: 11434`).
- [CODE↔DOCS GAP] sdk.yaml `website`: sdk-definition.rst says "|ws_markup| ignores
  it", but `sdk info` prints it (`cmd/sdk/info.go:120`).
- [CODE↔DOCS GAP] sdkcraft.yaml `website` is in
  `reference/definition-files/schema-sdkcraft.json`, and sdkcraft-definition.rst's
  own prose says SDKcraft copies it into sdk.yaml. The page's field table has no
  `website` row.
- [CODE↔DOCS GAP] The connection-entry example in workshop-definition.rst and
  schema.json uses `:ssh-agent` as a plug reference. The system SDK has only slots,
  and ssh-agent denies auto-connection, so a `connections:` entry cannot wire it.
  plugs-and-slots.rst explains this; the reference does not.
- [CODE↔DOCS GAP] Shell completion: tutorial/part-1-get-started.rst says it exists
  "for Bash, Zsh, Fish, and PowerShell" and is already enabled by the snap.
  `snap/local/lib/host-config` installs completion only for Bash, Fish and Zsh, and
  for Zsh only when `/usr/local/share` is writable.

## 4. Structural gaps and risks

- **Two interface references.**
  - `reference/sdks.rst` has per-interface sections, labelled `ref_camera_interface`
    to `ref_tunnel_interface`.
  - The `_interfaces/*.rst` snippets are included in all three definition pages but
    carry no per-interface anchors.
  - The home page's "… interface reference" links resolve to the older copy in
    sdks.rst, which contradicts the snippets on plug names, custom-device
    attributes, and desktop and ssh-agent scope.
- **Snippets publish as pages.** `_interfaces/*.rst` is not in `exclude_patterns`
  (`docs/conf.py`), so each snippet also builds as a standalone page that nothing
  links to. Local builds contain `_build/reference/definition-files/_interfaces/camera`.
- **Interface explanations don't link out.** No explanation interface page links its
  reference section, except tunnel. Only custom-device and tunnel link a how-to.
  mount-interface.rst describes remount and reset without linking add-mounts.rst,
  configure-mount.rst or `how_reset_remount`.
- **Missing or broken cross-links:**
  - debug-issues.rst does not link fix-installation.rst or resolve-plug-conflicts.rst.
  - fix-installation.rst's orphan advice goes straight to `sudo lxc delete`. It skips
    purge.rst's safer recovery and does not link it.
  - provide-secrets.rst never links back to use-secrets.rst.
  - multi-workshop-patterns.rst promises links "to the how-to that covers the
    mechanics" but has none.
  - sdk-vs-dockerfile.rst and run-github-actions-locally.rst point readers to "See
    also" sections that do not hold what they promise.
  - The two architecture pages have no See also.
  - use-host-devices.rst explains in-project and system SDKs without linking
    `exp_in_project_sdk` or `exp_system_sdk`.
  - ai-agents cites `how_add_actions` for Git worktrees, but that page has no
    worktree content.
- **Concepts used but explained nowhere a reader would look:**
  - snapshot, and base (in the tutorial)
  - track and guardrail (outside publish-an-sdk.rst)
  - stash (as it appears in debug output)
  - the `project-` prefix, and the `:mount` slot shorthand
  - "per-user authority"
  - the `workshopbr0` bridge
  - proxy and audio devices (runtime-behavior.rst)
  - the VM runtime
- **Labels, titles and toctree text disagree:**
  - fix-installation.rst
  - resolve-plug-conflicts.rst
  - run-jetbrains-gateway.rst
  - connect-vscode.rst (`how_vscode_connect_remote`)
  - tutorial part 1: titled "Get started with workshops", listed as "Get started with
    Workshop" and "Part 1: Get started"
  - tutorial/index.rst: its meta description says "three-stage"; the body says four
    parts.
- **Unlabelled pages.** The sub-landings, `reference/definition-files/index.rst`,
  `reference/cli/index.rst` and every release note lack anchor labels.
  - `:ref:` targets such as `exp_sdks` land on pillar-index sections, not on the
    sub-landing pages.
  - Release notes never link a new feature to its reference page.
- **Security has no hub.** explanation/index.rst promises a security "overview" but
  only links `/security`. `docs/security.md` is fill-wrapped MyST and contains an
  escaped `\:ref:` that renders as raw text.
- **Pre-merge pages on this branch.** use-secrets.rst and provide-secrets.rst
  document a `secret` interface and `workshopctl get-secret`, but this checkout's
  code implements neither. No explanation page, `_interfaces` snippet or schema
  exists for them either. Treat both pages as ahead of the code: until the
  implementation lands, units must not cite them as current behavior.
- **Version skew around VMs.**
  - use-virtual-machines.rst and `workshop init --runtime` describe the post-0.9.7
    `runtime` field.
  - The v0.9.7 release notes describe the released `confinement` field.
  - Readers on the 0.9.7 snap and readers of the current docs see different field
    names.

## 5. Prioritized improvements

1. [CODE↔DOCS GAP] **Make the workshop definition reference match the parser.**
   - Add a `runtime` row (`lxd-container`, `lxd-vm`) to workshop-definition.rst.
   - State that unknown keys are ignored without error, so `confinement:` and typos
     are dropped.
   - Reconcile the supported bases with `AllowedBases`.
   - Document the plug/slot shorthand and the binding equality rule.

   Why: this table is the contract users write YAML against, and the parser fails
   silently. Each omission becomes an error that the user cannot see.
2. [CODE↔DOCS GAP] **Collapse the two interface references into one.**
   - Move the `ref_<iface>_interface` labels onto the `_interfaces` snippets (or onto
     the definition-page sections that include them).
   - Delete the stale per-interface sections from reference/sdks.rst.
   - Add `_interfaces/*` to `exclude_patterns`.
   - Link each explanation interface page to its reference section and its how-to.
   - While there, document the custom-device hex format, `$$` escaping and the
     unexpected-variable rule, and the integer tunnel endpoint.

   Why: readers following the home page today land on the copy that contradicts the
   code.
3. [CODE↔DOCS GAP] **Add a reference page for configuration and environment.**
   - Cover the snap options `workshop.debug`, `workshop.experimental-vms`,
     `store.url` and `workshop.image.server.url`, and note that each needs a daemon
     restart.
   - Cover the client variables `NO_COLOR`, `TERM` and `LANG`.
   - Cover the exec environment defaults.
   - Link the page from debug-issues.rst and fix-installation.rst.

   Why: these are the only switches for debugging, mirrors and output, and today
   they appear only in the source.
4. [CODE↔DOCS GAP] **Document the operations contract that scripts and CI rely on.**
   - Exit-status passthrough for `exec` and `run`.
   - `--no-wait` together with `workshop changes` and `workshop tasks <ID>`.
   - The change and task STATUS values.
   - The warnings banner and the `warnings` flags.

   Extend changes-tasks.rst for the concepts and debug-issues.rst for the task, and
   link both from run-workshops-in-github-actions.rst.
5. **Re-file misplaced pages and repair navigation.**
   - Fold move-projects.rst into explanation/workshops/projects.rst, keeping a
     task-only how-to.
   - Recast use-git.rst and use-workshops-with-ai-agents.rst as how-tos, or move them
     to the tutorial or explanation pillar.
   - Expand run-jupyterlab-in-browser.rst into a full how-to.
   - Order the develop-sdks sub-landing by workflow.
   - Make each page's label, title and toctree text agree.
   - Give every sub-landing an anchor label.
   - Add See also sections to the architecture pages.

   Why: page purpose is unclear today, and readers who browse by pillar miss content.

## Limitations

- Of the 49 generated CLI pages, 12 were read in full. The rest were checked by grep
  against the cobra definitions; every flag and help string matched, so no stale
  generation was found.
- The sdkcraft CLI pages and the sdkcraft.yaml fields could not be checked against
  code, which lives in the separate SDKcraft repository. Only their internal
  consistency and the exported schema were checked.
- The code was mapped at directory granularity, then by targeted symbols. `client/`
  was treated as the CLI's private library (no package documentation; only `cmd/`
  consumes it), not as a public API, so no gap is asserted for it.
- These were left out as internal or test-only: `WORKSHOP_DATA`, `WORKSHOP_COMMON`,
  `WORKSHOP_CACHE` and `WORKSHOP_SOCKET`, plus `WORKSHOP_REBOOT_DELAY`,
  `WORKSHOP_COOKIE`, the hidden `generate-docs` commands, the sdk.yaml `type` key and
  the plug `label` key.
- These were left out because they could not be verified:
  - whether the check-health 5-second limit is enforced on refresh
  - DNS behavior on hosts without systemd-resolved
  - architecture names beyond those the reference lists
- `docs/coverage.md` was not used; it is known to be stale.
- No forge discussion (issues, pull requests) was consulted, so there are no
  `[SDLC]` findings.
