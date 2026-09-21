---
title: "How to use virtual machines"
intent: "how-to"
audience: "Existing Workshop users who already run container workshops daily and have hit an isolation or nesting wall (harder boundary around an AI agent, or running LXD containers and VMs inside a workshop). Readers still evaluating which confinement to pick are pointed back to containers."
targets:
  - "how-to/customize-workshops/use-virtual-machines.rst"
  - "how-to/customize-workshops/index.rst"
sources:
  - "internal/workshop/workshop_file.go"
  - "internal/overlord/workshopstate/manifest.go"
  - "internal/overlord/workshopstate/request.go"
  - "internal/workshop/lxd/lxd_backend.go"
  - "cmd/workshop/init.go"
  - "cmd/workshop/info.go"
  - "tests/lib/utils.sh"
  - "tests/main/launch/task.yaml"
  - "tests/main/start/task.yaml"
  - "docs/release-notes/v0.9.7.md"
  - "docs/how-to/customize-workshops/use-host-devices.rst"
notes: "Anchor how_use_virtual_machines. Index entry reads 'Use virtual machines <use-virtual-machines>'. No '.. @tests' marker: the brief excludes a dedicated tests/docs-how-to/ test. Out of scope: docs/index.rst, docs/reference/definition-files/workshop-definition.rst, docs/release-notes/v0.9.7.md, explanation, architecture, workshop reference, status, restore and security pages, generated schema and CLI reference, application code."
---
## Intent & scope

Readers already run container workshops every day and have hit a wall the
container cannot clear: they want a harder isolation boundary around an AI
agent, or they need to run LXD containers and VMs inside the workshop itself.
This page is the deliberate opt-in path for those readers, and nothing else.

VM confinement is experimental. Containers stay the default, and a reader
still choosing between the two should stay on containers: VMs are slower,
consume more resources, and do not yet support every feature a container
does. The page says so before it says anything else.

Scope is one procedure: turn on the experimental setting, create a
VM-confined workshop either way the CLI allows, launch it, confirm the
confinement, and know in advance what will not work.

## Outline / acceptance

Start state: a working Workshop 0.9.7 or later installation, an LXD that
supports VMs, and at least one container workshop already running.

End state: a launched workshop whose confinement reads as virtual-machine,
plus an accurate picture of what that workshop cannot do.

Checkpoints the page must land:

- Experimental status and the container default are stated before the first
  command, together with the cost the reader accepts by opting in.
- Prerequisites separate two cases: a plain VM workshop, and a VM workshop
  carrying SDKs, which additionally needs an LXD whose disk device supports
  shifted mounts. A reader without that LXD learns it here, not at launch.
- Opting in is one snap setting plus a daemon restart, and the page is
  explicit that the restart is required, not advisory.
- Both creation paths appear: generating a definition with the VM option,
  and writing the confinement key by hand into an existing definition.
- Launch succeeds, and the reader verifies confinement from workshop info
  rather than assuming it.
- Lifecycle coverage is summarized only for operations the VM test suite
  actually exercises (start, stop, remove, autostart, SSH access), pointing
  at the CLI reference instead of restating it.
- Limitations read as consequences the reader will meet, not as a changelog:
  confinement is fixed at launch and refreshing cannot change it; SDK support
  depends on the LXD capability above; SDK interfaces are not connected
  automatically and are not restored across a refresh; SDK health checks do
  not run.
- The page is listed in the customize-workshops index and nowhere else.

Acceptance: a reader following the page end to end reaches a verified
VM-confined workshop and can state, before launching, which of their current
container workflows will not carry over. The page builds clean with warnings
treated as errors and passes the spelling, inclusive-language, and style
checks.
