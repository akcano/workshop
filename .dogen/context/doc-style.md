# Workshop documentation style

Grounding: a full read of the prose under `docs/` on the `dogen` branch (HEAD
7e2f3b79): the landings, the tutorial, every how-to page, every explanation page
and every hand-written reference page, plus the release notes, the contributing
pages and `docs/doc-style-guide.md`. Of the 49 generated CLI pages under
`docs/reference/cli/`, 12 were sampled. The house guide is `docs/doc-style-guide.md` (MyST, `:orphan:`, label
`doc_style_guide`). `docs/contributing/documentation.rst` links to it, and it calls
itself "subordinate to Canonical's documentation standards", deferring to the
Sphinx Stack reST style guide. Where the guide and practice disagree, this profile
says which one a new page should follow.

## 1. Voice & tone

- **Register.** The guide sets it: "authoritative but relaxed, confident but
  approachable", "water cooler conversation, not classroom session".
  - How-to and tutorial pages meet that register.
  - Explanation is a notch more formal and neutral.
  - Reference is terse and table-driven.
- **Person.** Second person for the reader, often implied by the imperative.
  - The product is a third-person actor, always written `|ws_markup|`: "|ws_markup|
    allocates a host directory for the plug" (how-to/customize-workshops/add-mounts.rst).
  - "We" and "let's" belong to the tutorial narrator only: "let's use the
    :samp:`ollama` SDK" (tutorial/part-1-get-started.rst). Anywhere else they are
    drift; see section 5.
- **Mood.** Imperative for steps, declarative present tense for behavior. A step
  usually opens with an infinitive purpose clause and ends in a colon that
  introduces the code block. Examples:
  - "To revoke access, disconnect the plug:"
    (how-to/customize-workshops/use-host-devices.rst)
  - "Refresh the workshop to bind the target:" (add-mounts.rst)
- **Contractions** are normal in every pillar except generated reference: "don't",
  "won't", "you'll", "here's".
- **Humor** is light and appears only in the tutorial:
  - "the workshop is just a fancy container" (part-1)
  - ":samp:`sketch-final-final`, and so on." (part-3)
- **Guidance sentences** in the newer pages are short and aphoristic:
  - "A useful SDK rarely needs all five." (how-to/develop-sdks/build-an-sdk.rst)
  - "Keep the hook idempotent and tolerant of missing input" (write-runtime-hooks.rst)
- **Openings vary by pillar.**
  - How-tos open on context or the goal, sometimes with "This guide shows how
    to…" (configure-mount.rst, declare-plugs-slots.rst).
  - Explanation pages open on a definitional sentence: "A workshop is a graph of
    capabilities." (explanation/interfaces/plugs-and-slots.rst), or "Technically, a
    project is a directory" (explanation/workshops/projects.rst).
  - Newer explanation pages open on a scenario: "One workshop per project is the
    default," (explanation/workshops/multi-workshop-patterns.rst).
- **Generated CLI pages** use an imperative summary, such as "Construct one or many
  workshops using their definitions." (reference/cli/workshop-launch.rst). The
  description that follows opens with "This command …".
- **Release notes** are changelog bullets, mostly in the past tense ("Added",
  "Fixed", "Switched").
- **Avoid** these:
  - "you can" for a required action. The guide forbids it, but 81 instances remain
    across the prose.
  - Marketing register, such as "provides a powerful way to develop"
    (how-to/develop-with-workshops/run-github-actions-locally.rst).
  - "Conclusion" sections. Only add-actions.rst and use-workshops-with-ai-agents.rst
    have one.
  - "e.g." and "firstly" (purge.rst, several develop-with-workshops pages). The norm
    is "for example".

## 2. Audience assumptions

- **The guide states the reader:** "developers and DevOps professionals"
  (doc-style-guide.md). In practice two readers share the docs:
  - Workshop *users*: tutorial parts 1 to 3, plus how-to/customize-workshops,
    develop-with-workshops and fix-workshops.
  - SDK *publishers*: tutorial part 4, how-to/develop-sdks and the sdkcraft
    reference. index.rst frames |sdk_markup| as "aimed at publishers who create and
    distribute SDKs".
- **Assumed fluency:** shell, YAML, Git, SSH, systemd and snaps, on an Ubuntu or WSL
  host. The guide's prerequisites rule lets pages omit that baseline, including "an
  Ubuntu or snap-enabled host".
- **Workshop jargon is explained at first use**, usually with italics or a link.
  Examples include *plug*, *slot*, *tunnel interface*, *tasks* and *change* (how-to
  pages), and *sketching* (tutorial/part-3-sketch-sdks.rst).
- **LXD jargon is assumed, not explained.** The fix-workshops pages use LXD
  projects, profiles and `lxc` commands without explanation. The architecture pages
  assume LXD system containers, ZFS and Btrfs.
- **Some concepts have no definition where a reader would look:** base, snapshot,
  track, guardrail, stash (as it appears in task output) and health check. See
  glossary.md.

## 3. Formatting conventions

**Page skeleton (rST).** A label, then `.. meta::` with `:description:`, then the
title:

```
.. _how_add_mounts:

.. meta::
   :description: How-to guide on ...

How to add mounts
=================
```

Every rST page in the build has a meta description. The only page without one is
`docs/readme.rst`, which is excluded from the build.

- How-to meta descriptions begin "How-to guide on…", and explanation ones begin
  "Explanation of…".
- Two optional page fields appear:
  - `:relatedlinks:`, on the index and contributing pages only.
  - `:hide-toc:`, on pages whose only subsection is "See also".

**Labels** follow `<prefix>_<snake_case>`.
- Prefix counts: `tut_` (24), `how_` (58), `exp_` (95), `ref_` (93), plus
  `contributing_`, `security_`, `release_` and `home_`.
- Section labels extend the page label: `how_publish_sdk_ci`,
  `exp_workshop_definition_actions`.
- CLI tool pages use a double underscore: `ref_workshop__cli`.
- Sub-index pages often have no label at all.

**Headings.**
- `=` for the title, `-` for H2, `~` for H3. Pages essentially never go deeper.
- All headings are in sentence case.
- How-to titles follow "How to <verb> <object>". Navigation text drops the "How to"
  ("Forward ports").
- Explanation titles are noun phrases, sometimes compressed with commas ("Changes,
  tasks", "Plugs, slots, connections").
- H2s in how-tos are imperative steps ("Pack the SDK", "Connect the plug").

**Line breaks and spacing.**
- Every rST page uses semantic line breaks, one clause per source line. The only
  fill-wrapped prose is `docs/security.md` and the intro paragraph of
  `docs/index.rst`.
- Two blank lines follow every code block, list and table, and precede every
  heading.
- Directive content is indented three spaces.
- Multi-line list items are separated by blank lines.

**Code blocks.**
- `console` blocks:
  - Use the `$ ` prompt, which `copybutton_prompt_text` strips on copy.
  - Show output after a blank line, indented two extra spaces.
  - Use `...` to elide output.
  - Show in-workshop prompts as `workshop@dev:/project$`.
- `yaml` blocks always have a `:caption:` with the file path (`.workshop/dev.yaml`,
  `workshop.yaml`, `sdkcraft.yaml`) and often `:emphasize-lines:`.
- Hook scripts use `shell` with a caption. Directory trees use `none`.
- Examples shared across pages live in `docs/examples/` and are pulled in with
  `literalinclude`.
- The sentence before a code block ends with a colon.
- `docs/readme.rst` is rendered on GitHub, so per the guide it drops `$` prompts and
  semantic roles.

**Inline markup.**
- Roles:
  - `:samp:` for values, keys, SDK names and channels.
  - `:file:` for paths.
  - `:command:` for complete commands, including flags, for example
    (`:command:`workshop refresh --verbose``).
  - `:program:` for tools.
  - `:option:`, always with the `!` no-link prefix (`:option:`!--sdks``).
  - `:envvar:` for environment variables.
  - `:guilabel:` and `:kbd:`, only on the VS Code page.
- Italics introduce a new term.
- Internal links use `:ref:` with semantic labels. `:doc:` is reserved for
  `index.rst` and `release-notes/index.rst`.
- Placeholders are uppercase in angle brackets: `<WORKSHOP>`, `<SDK>:<PLUG>`,
  `<PROJECT-ID>`.
- Product names come from substitutions in the `rst_epilog` of `docs/conf.py`:
  `|ws_markup|` (:program:`Workshop`) and `|sdk_markup|` (:program:`SDKcraft`). The
  same epilog defines named link targets such as `` `LXD`_ ``.

**Admonitions.**
- `note` dominates, with 65 across the prose. There are 11 `warning`s and one
  `caution`, and no `tip` or `important`.
- Notes mostly carry a cross-link or a caveat.
- No tabs. `dropdown` wraps long includes such as schemas and prompts.

**Tables.**
- Tables use `list-table` with `:header-rows: 1` and `:widths:`.
- Definition-file references use the columns Key | Value | Description. The Key
  cell marks "(required)", and defaults are given in prose: "Default:
  :samp:`latest/stable`."
- Elsewhere, prose is preferred to tables.

**Closings.**
- 54 pages end with an H2 "See also". It holds bulleted `:ref:` lists grouped under
  the plain-text labels "Explanation:", "How-to guides:", "Reference:" and
  "Tutorial:", each list in alphabetical order.
- Tutorial parts end with "Next steps".

**Prerequisites.** An H2 placed right after the opening paragraph; in a tutorial it
is an H3 under "Install". It opens with the stock line "Before starting, ensure you
have these requirements satisfied:".

**Authoring comments.**
- `.. @artefact <term>` (424 markers) feeds coverage tracking through
  `docs/.coverage.yaml` and `docs/coverage.py`.
- One of three `@tests` forms ties a page to its spread test:
  - `.. @tests in tests/<path>/task.yaml`
  - `.. @tests not applicable: <reason>`
  - `.. @tests made redundant by <page>`

**Diagrams and images.**
- Five pages have Mermaid diagrams, always with `:alt:`.
- The only screenshots are for VS Code, in `docs/images/vscode/`. The extension
  repository's pipeline generates them; they are never captured by hand.

**Markdown.**
- Only the release notes, `security.md` and the two style guides are Markdown. Each
  opens with an `{eval-rst}` meta block.
- Release notes follow the guide's template, in this order:
  1. H1 title.
  2. H2 date.
  3. "Requirements and compatibility".
  4. "What's new".
  5. One H3 per repository, with a `**Repository:**` line.
  6. "Full Changelog".

## 4. Completeness patterns

- **Examples accompany steps** almost everywhere. Output is shown for inspection
  commands (`list`, `info`, `connections`) but usually not for state-changing ones
  (`launch`, `refresh`, `stop`).
- **Verification steps** are a mark of the newer how-tos:
  - "Verify the connection" (use-host-devices.rst)
  - "The :samp:`runtime` line is the confirmation:" (use-virtual-machines.rst)
  - configure-mount.rst and share-content-between-sdks.rst

  They are missing from declare-plugs-slots.rst, publish-an-sdk.rst,
  run-github-actions-locally.rst and run-jupyterlab-in-browser.rst.
- **Cleanup or undo** is inconsistent. It is present in use-host-devices.rst
  (revoke), add-mounts.rst ("Reset a remount") and use-git.rst, and absent from most
  other how-tos.
- **Prerequisites sections** appear in roughly half the how-tos. In the tutorial,
  only parts 1 and 4 have one.
- **Error states** are documented verbatim on the newest pages: the "Limitations"
  section of use-virtual-machines.rst, and `--wait-on-error` in debug-issues.rst.
  forward-ports.rst and connect-vscode.rst have "Troubleshooting" sections.
- **Reference completeness.**
  - Every definition-file row has a type.
  - Defaults are stated for channel, mount and tunnel attributes, but not for what
    happens when `sdks`, `connections` or `actions` is omitted.
  - Every workshop and sdk CLI page has Examples. Seven sdkcraft pages have none:
    build, prime, pull, register, stage, upload and version.
- **Edge cases** are covered best in explanation: health-check retries, remount
  atomicity, the `missing-project` note, and slot-order caveats in
  plugs-and-slots.rst.

## 5. Consistency & drift

**Terminology drift.** Normalize these pairs whenever you touch a page.

- **Workshop definition file:**
  - `workshop.yaml` (readme.rst, definition-files/index.rst)
  - `.workshop/<NAME>.yaml` (the tutorial and most examples)
  - `.workshop.yaml` (use-workshops-with-ai-agents.rst)
  - Also "definition file", "workshop definition file" and "workshop file"
    (reference/cli/workshop-init.rst).
- **SDK definition:**
  - tutorial/part-3 calls `sdk.yaml` the definition.
  - part-4 calls `sdkcraft.yaml` the "template definition file".
  - Both link to `exp_sdk_definition`.
  - reference/sdks.rst links "sdkcraft.yaml definition" to the `sdk.yaml` page.
- **ssh-agent interface:**
  - "ssh-agent interface" (tutorial/part-2)
  - "SSH agent interface" (index.rst, security.md)
  - "SSH interface" (the explanation page title)
  - `ssh` (explanation/sdks/best-practices.rst)
- **SDK Store** vs "the Store" vs lowercase "the store" (generated sdkcraft pages).
- **Plain "Workshop" instead of `|ws_markup|`:** index.rst line 38,
  explanation/architecture/runtime-behavior.rst, and the JetBrains page title.
- **"action" collides with "task":** "*tasks*, or individual actions"
  (debug-issues.rst).
- **Spelling pairs:**
  - hostname vs "host names" (release notes v0.9.2)
  - runtime vs "run-time"
  - filesystem vs "file system"
  - lifecycle vs "life-cycle"
  - artifact vs "artefacts" (explanation/cli.rst). The `@artefact` marker spelling
    belongs to tooling, not prose.
- **US-spelling slips:** "organised" (build-an-sdk.rst), "organisation" (an
  index.rst slice), "favourite" (develop-with-workshops/index.rst).
- **`:envvar:` with and without `$`:** `$SDK` vs `SDK`.
- **One tool, three names:** "Sphinx Stack", "starter pack" and "SP" (contributing
  pages).

**Style drift.**

- **How-to pages written as tutorials or essays:**
  - use-git.rst: "Let's look at how you can integrate"
  - use-workshops-with-ai-agents.rst: "We will be using a single"
  - move-projects.rst: "Let's spend some time talking about"
  - resolve-plug-conflicts.rst: "Here, we use fictional"
- **"We" in explanation:** sdk-vs-dockerfile.rst ("Our SDKs are structured using"),
  and a note in interfaces/concepts.rst.
- **Chatty, ungrammatical older reference pages:** reference/workshops.rst ("This
  topic speaks about what goes"), and reference/sdks.rst.
- **Enterprise abstraction** in architecture/components.rst: "serves as the central
  orchestration hub".
- **Label, title and toctree text disagree:**
  - fix-installation.rst: `how_troubleshoot` / "How to troubleshoot" / "Fix the
    installation"
  - resolve-plug-conflicts.rst: "How to fix plug conflicts with binding" / "Resolve
    plug conflicts"
  - run-jetbrains-gateway.rst

**Conflicting descriptions.**

- **setup-base** runs "on every `workshop refresh`" (build-an-sdk.rst), but "a
  refresh that leaves the SDK intact skips it" (write-runtime-hooks.rst).
- **`SDK_STATE_DIR`** is "gone as soon as the workshop stops" (build-an-sdk.rst),
  but "survives the refresh" (write-runtime-hooks.rst).
- **Mount auto-connection:**
  - by plug name (explanation/interfaces/mount-interface.rst)
  - "Matching names count for nothing here;" (plugs-and-slots.rst)
  - a plain "(auto-connected)" (interfaces/concepts.rst)
- **Hostnames:** workshops/concepts.rst presents the friendly
  `<WORKSHOP>.<PROJECT>.wp` name first. architecture/components.rst makes the
  ID-based name canonical and the friendly name an alias.
- **Resetting mounts:** changes-tasks.rst says restore resets them.
  mount-interface.rst says a reset needs `disconnect --forget` and then a refresh.
- **Interface reference:** the interface sections in reference/sdks.rst contradict
  the `_interfaces/*.rst` snippets on plug names, custom-device attributes, and the
  scope of desktop and ssh-agent. The snippets match the code.
- **Shell completion:** tutorial/part-1 says completion exists "for Bash, Zsh, Fish,
  and PowerShell" and that "it is already enabled". The snap installs it only for
  Bash, Fish and Zsh (snap/local/lib/host-config).
- **LXD install channel:** `6/stable` (readme.rst, fix-installation.rst), but VMs
  require `6/edge` (use-virtual-machines.rst).
- **Tutorial part count:** the tutorial/index.rst meta description says "a
  three-stage guide"; the body says four parts.
- **Tutorial continuity:**
  - The Ollama version jumps between parts: 0.20.2 in part 1, 0.9.6 in parts 2 to 4.
  - Part 3's starting definition drops the `uv` SDK and the `connections:` from the
    end of part 2.
- **VM field name:** the v0.9.7 release notes describe `confinement:
  virtual-machine`, which was correct for 0.9.7 as released. The current code and
  use-virtual-machines.rst use `runtime: lxd-vm`; the field was renamed after the
  0.9.7 tag.
- **Stale statements:**
  - Forward-looking release notes: "publishing is in progress and available soon"
    (v0.9.1), "The extension will be made available after" (v0.9.5).
  - Dated sample output: 2023 timestamps in debug-issues.rst, "installed: 0.1.13"
    in fix-installation.rst.

**The style guide itself has drifted** (`docs/doc-style-guide.md`).
- It points at paths that have moved:
  - `docs/reuse/substitutions.txt` and `links.txt`, now inlined into `conf.py`.
  - `docs/coverage.yaml`, now `docs/.coverage.yaml`.
  - Markdown sdkcraft CLI pages under `reference/cli/sdkcraft/*.md`, now flat `.rst`
    files.
- Its placeholder example, `{WORKSHOP}`, contradicts its own angle-bracket rule.
- Its release-notes example uses a `v` prefix that its own rule forbids.
- It duplicates the "How-to title pattern" heading, with a broken example.
- It misspells "contributring".

Follow the guide's rules, not its stale paths and examples.

**Strongest pages.** Use these as templates.
- `docs/explanation/interfaces/plugs-and-slots.rst`: a clear model, a policy table,
  a worked example and dense cross-links.
- `docs/how-to/customize-workshops/use-host-devices.rst` and
  `use-virtual-machines.rst`: prerequisites, expected output, explicit verification,
  and a revoke step or a limitations section.

**Weakest pages.**
- `docs/how-to/develop-with-workshops/run-jupyterlab-in-browser.rst`: a single YAML
  block, with no headings, prerequisites or verification.
- `docs/reference/sdks.rst`: an older duplicate of the interface reference. It now
  contradicts both the `_interfaces` snippets and the code.
