---
description: >
  Pilot: an agent executes one Workshop documentation page on the runner and
  reports whether the page works as written. Adapted from
  canonical/user-docs-testing .github/workflows/validate-tutorial.md (main).
on:
  workflow_dispatch:
  push:
    branches: [pilot/docs-testing]
    paths: [".pilot/run-configure-mount"]

permissions:
  contents: read

engine:
  id: copilot
max-ai-credits: 80

runs-on: [ubuntu-latest]
timeout-minutes: 60

env:
  DOC_PAGE: "docs/how-to/develop-sdks/configure-mount.rst"

features:
  dangerously-disable-sandbox-agent: true

sandbox:
  agent: false

strict: false

network:
  allowed:
    - defaults
    - snapcraft.io
    - api.snapcraft.io
    - ollama.com
    - registry.ollama.ai

steps:
  - name: Install LXD
    uses: canonical/setup-lxd@8c6a87bfb56aa48f3fb9b830baa18562d8bfd4ee
    with:
      channel: 6/stable
  - name: Install Workshop and SDKcraft
    run: |
      sudo snap install workshop --classic --edge
      sudo snap install sdkcraft --classic --edge
      snap list workshop sdkcraft lxd
      df -h / /mnt || true
  - name: Allow LXD container egress past Docker's FORWARD policy
    run: |
      sudo iptables -P FORWARD ACCEPT
      sudo ip6tables -P FORWARD ACCEPT || true
      sudo lxc launch ubuntu:24.04 egress-check
      for i in $(seq 1 30); do sudo lxc exec egress-check -- curl -sS -o /dev/null -w '%{http_code}\n' http://archive.ubuntu.com/ubuntu/ && break; sleep 2; done
      sudo lxc delete --force egress-check

tools:
  bash: [":*"]
  edit:

safe-outputs:
  threat-detection: false
  create-check-run:
    name: "Doc page: configure-mount"
    max: 1
---

# Execute doc page configure-mount

You are a documentation-testing agent. Execute the page at `$DOC_PAGE` on
this runner, step by step, and report whether it works as written.

## Runner environment

- You are on an ephemeral `ubuntu-latest` runner with the AWF sandbox
  disabled. You have a normal user shell with full `sudo`.
- LXD (6/stable), Workshop (`workshop`, `sdk` commands, edge channel) and
  SDKcraft (`sdkcraft`, edge channel) are already installed and initialised
  by the workflow. Treat the page's installation steps for LXD and Workshop
  as satisfied; do not reinstall or reconfigure them. If LXD access is
  denied for your user, use `sudo` or `sg lxd -c '...'` and record a pivot.
- Work in a fresh scratch directory outside the repository checkout. Do not
  modify any repository file.

## Mode

Run `cat .pilot/mode` in the repository checkout. It prints `lenient` or
`strict`. Apply the rules for that mode below.

## Phase 1 — Read the page

Read `$DOC_PAGE` in full. It is reStructuredText. Executable commands are in
`.. code-block:: console` blocks, prefixed with `$ `; lines without the
prompt in those blocks are expected output. `.. code-block:: yaml` blocks
with a `:caption:` naming a file are file contents to create or edit.

If the page is a how-to that shows configuration fragments rather than a
complete walkthrough, build the minimal project the page's prerequisites
describe, apply every fragment the page shows, and then run the page's
verification commands.

Skip clean-up or teardown sections.

## Phase 2 — Execute

Run every executable command in document order.

- For each command, record: the command as written, the command actually
  run, exit status, and the last ~20 lines of output.
- Do not abort on failure; record it and continue.
- A command that opens an interactive session (a shell, a chat prompt, an
  editor) must be run non-interactively instead, for example
  `workshop exec dev -- bash -c '<command>'`. Record that as a pivot.
- **Pivots**: whenever you run anything other than the command exactly as
  written (fixing a flag, adding `sudo`, substituting a value, working
  around an error), log a pivot: original command, command run, reason.

### Lenient mode only

Do not compare output; a step passes when its exit status is what the page
implies.

### Strict mode only

After each command that the page follows with expected output, compare the
actual output with the expected output. Ignore volatile values: dates,
times, sizes, counts of bytes, revision numbers, IDs, hashes, durations and
column padding. Any other difference (a different permission string, owner,
message text, field name, value or missing line) is an **output mismatch**
and the step fails.

## Phase 3 — Report

Emit exactly one `create_check_run`. Put the whole report in `summary`.

Conclusion:

- Lenient mode: `failure` if any step failed; otherwise `success`. List
  pivots in the report but do not let them change the conclusion.
- Strict mode: `failure` if any step failed, any output mismatch was found,
  or any pivot other than an interactive-to-non-interactive pivot was
  needed; otherwise `success`.

`summary` contains, in order:

1. One verdict line with the mode, the conclusion and the counts: steps run,
   steps failed, output mismatches (strict only), pivots.
2. A table of failed steps and mismatches: page line, command, what
   happened. Keep URLs and pipes out of cells.
3. Every pivot: original command, command run, reason, and whether it
   points to a bug in the page.
4. Anything you could not execute or verify, and why.
5. Total wall-clock time you spent, roughly.
