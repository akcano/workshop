:slug: home-page
:relatedlinks: [Workshop repo](https://github.com/canonical/workshop/), [SDKcraft repo](https://github.com/canonical/sdkcraft/), [Reference workshops](https://github.com/canonical/reference-workshops), [Reference SDKs](https://github.com/canonical/reference-sdks), [LXD docs](https://canonical.com/lxd/docs/default/), [Snap docs](https://snapcraft.io/docs/)

.. _home:

.. meta::
   :description: Home page for Workshop documentation, providing links to
                 tutorials, how-to guides, references, and explanations.

|ws_markup|
===========

.. toctree::
   :hidden:

   Home <self>
   tutorial/index
   how-to/index
   reference/index
   explanation/index

.. toctree::
   :hidden:

   Release notes <release-notes/index>
   Contribute <contributing>
   Security <security>



**Workshops are secure, fast, and composable development environments
that come agent-ready**.

**Wrap complex, error-prone workspaces
into reliable and reproducible definitions of languages, libraries, and tooling**.
The key pieces of a definition are SDKs:
independent, connectable units of functionality
that publishers package and share on the SDK Store,
and teams can define in their repositories.

**Workshops enable sandboxed experimentation,
turn environment updates into manageable transactions,
and ensure consistent, reproducible environments**.
With |ws_markup|, you can launch a setup
that previously took hours to configure in a few commands
and be sure it will work the same way every time,
or tear it down and start from the last step without worrying about leftover state.

**Agentic engineering, AI/ML, robotics, IoT, EdTech, and similar domains**
typically use less-than-trivial project layouts
that rely on many Ubuntu versions or container images,
a plethora of diverse tools and frameworks,
and a wide range of libraries and languages.
That's where |ws_markup| thrives.

**Built for AI workflows**.
|ws_markup| publishes :ref:`LLM-readable docs <ref_ai_discovery>`,
and ships agentic skills for :ref:`operating workshops <ref_ai_use_workshop_skill>`,
:ref:`onboarding repositories <ref_ai_onboard_workshop_skill>`,
and :ref:`designing SDKs <ref_ai_design_sdk_skill>`.

----



In this documentation
---------------------

.. rubric:: Start here

Install, then learn by doing.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Install, tutorial**
     - :ref:`Install Workshop <tut_install>` •
       :ref:`Get started <tut_get_started>` •
       :ref:`Work with interfaces <tut_interfaces>` •
       :ref:`Sketch SDKs <tut_sketch_sdks>` •
       :ref:`Craft SDKs <tut_craft_sdks>`

   * - **Concepts**
     - :ref:`Workshops <exp_workshop_concepts>` •
       :ref:`Projects <exp_projects>` •
       :ref:`SDKs <exp_sdk_concepts>` •
       :ref:`Interfaces <exp_interface_concepts>` •
       :ref:`Changes, tasks <exp_changes_tasks>` •
       :ref:`CLI tools <exp_cli>`

   * - **Scenarios**
     - :ref:`Parallel AI agents <how_ai_agents_parallel_runs>` •
       :ref:`Notebooks with uv <tut_jupyter_uv_venv>` •
       :ref:`ROS 2 <exp_ros2_case_study>` •
       :ref:`GitHub Actions <how_run_workshops_in_github_actions>` •
       :ref:`Multi-service projects <exp_multi_workshop_patterns>`


.. rubric:: Know your workshop

Workshops, SDKs, interfaces, and the machinery underneath.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Workshops, projects**
     - :ref:`Status <exp_workshop_status>` •
       :ref:`Launch, refresh, restore <exp_workshop_lifecycle>` •
       :ref:`Multi-workshop patterns <exp_multi_workshop_patterns>` •
       :ref:`workshop.yaml <ref_workshop_definition>` •
       :ref:`Status diagrams <ref_workshop_status>` •
       :ref:`Internals <ref_workshop_internals>`

   * - **SDKs**
     - :ref:`Parts <exp_sdk_parts>` •
       :ref:`Runtime hooks <exp_sdk_hooks>` •
       :ref:`Lifecycle <exp_sdk_lifecycle>` •
       :ref:`System SDK <exp_system_sdk>` •
       :ref:`SDK Store <exp_sdk_store>` •
       :ref:`In-project SDKs <exp_in_project_sdk>` •
       :ref:`Sketching <exp_sketch_sdk>` •
       :ref:`sdk.yaml <ref_sdk_definition>` •
       :ref:`Internals <ref_sdk_internals>`

   * - **Interfaces**
     - :ref:`Plugs and slots <exp_plugs_slots>` •
       :ref:`Auto-connection <exp_interface_auto_connection>` •
       :ref:`Plug bindings <exp_plug_bindings>`

   * - **CLI tools, architecture**
     - :ref:`workshop <ref_workshop__cli>` •
       :ref:`sdk <ref_sdk__cli>` •
       :ref:`sdkcraft <ref_sdkcraft__cli>` •
       :ref:`workshopctl <ref_workshopctl__cli>` •
       :ref:`System components <exp_arch_system_components>` •
       :ref:`Runtime behavior <exp_arch_runtime_behavior>`


.. rubric:: Work in a workshop

Run, tailor, and wire workshops.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Run workshops**
     - :ref:`Launch <ref_workshop_launch>` •
       :ref:`Start <ref_workshop_start>` •
       :ref:`Stop <ref_workshop_stop>` •
       :ref:`Refresh <ref_workshop_refresh>` •
       :ref:`Restore <ref_workshop_restore>` •
       :ref:`Remove <ref_workshop_remove>` •
       :ref:`Run commands <ref_workshop_exec>` •
       :ref:`Interactive shell <ref_workshop_shell>` •
       :ref:`Add actions <how_add_actions>` •
       :ref:`Use multiple workshops <how_use_multiple_workshops>` •
       :ref:`Move projects <how_move_projects>`

   * - **Tailor with SDKs**
     - :ref:`Add SDKs <exp_workshop_definition_sdks>` •
       :ref:`Find SDKs <ref_sdk_find>` •
       :ref:`Sketch an SDK <ref_workshop_sketch-sdk>`

   * - **Connect interfaces**
     - :ref:`Plugs, slots, connections <exp_workshop_definition_connections>` •
       :ref:`Connect <ref_workshop_connect>` •
       :ref:`Disconnect <ref_workshop_disconnect>` •
       :ref:`Remount <ref_workshop_remount>`


.. rubric:: Craft and publish SDKs

Design, build, and release SDKs to the Store.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Design**
     - :ref:`Best practices <exp_sdk_best_practices>` •
       :ref:`Parts or hooks? <exp_best_parts_or_hooks>` •
       :ref:`Health checks <exp_best_health_checks>` •
       :ref:`SDKs vs Dockerfiles <exp_dockerfile_vs_sdk>`

   * - **Build, test**
     - :ref:`Build an SDK <how_build_sdk>` •
       :ref:`Write runtime hooks <how_write_runtime_hooks>` •
       :ref:`Declare plugs and slots <how_declare_plugs_slots>` •
       :ref:`Configure a mount <how_configure_mount>` •
       :ref:`Share content between SDKs <how_share_content_between_sdks>` •
       :ref:`try <ref_sdkcraft_try>` •
       :ref:`test <ref_sdkcraft_test>`

   * - **Publish**
     - :ref:`Publish an SDK <how_publish_sdk>` •
       :ref:`Automate uploads from CI <how_publish_sdk_ci>` •
       :ref:`sdkcraft.yaml <ref_sdkcraft_definition>`


.. rubric:: Reach beyond the sandbox

Host files, hardware, networks, tools, and agents.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Files, hardware**
     - :ref:`Mount <exp_mount_interface>` •
       :ref:`Add mounts <how_add_mounts>` •
       :ref:`GPU <exp_gpu_interface>` •
       :ref:`Camera <exp_camera_interface>` •
       :ref:`Custom device <exp_custom_device_interface>` •
       :ref:`Desktop <exp_desktop_interface>` •
       :ref:`Use host devices <how_use_host_devices>`

   * - **Networking, SSH**
     - :ref:`Tunnel <exp_tunnel_interface>` •
       :ref:`Forward ports <how_forward_ports>` •
       :ref:`Workshop hostnames <exp_workshop_hostname>` •
       :ref:`Cross-workshop networking <how_use_multiple_workshops_networking>` •
       :ref:`SSH agent <exp_ssh_interface>`

   * - **Developer tools**
     - :ref:`Connect VS Code <how_vscode_connect_remote>` •
       :ref:`JetBrains Gateway <how_jetbrains_gateway>` •
       :ref:`JupyterLab in browser <how_jupyterlab_run_in_browser>` •
       :ref:`Manage Python environments <how_manage_python_environments>` •
       :ref:`Use with Git <how_git_workshops>` •
       :ref:`Run GitHub Actions locally <how_run_github_actions_locally>` •
       :ref:`Run workshops in GitHub Actions <how_run_workshops_in_github_actions>`

   * - **AI agents**
     - :ref:`Overview <ref_ai_agents>` •
       :ref:`Use with AI agents <how_use_workshops_with_ai_agents>` •
       :ref:`use-workshop skill <ref_ai_use_workshop_skill>` •
       :ref:`onboard-workshop skill <ref_ai_onboard_workshop_skill>` •
       :ref:`design-sdk skill <ref_ai_design_sdk_skill>`


.. rubric:: Maintain, secure, contribute

Upgrade, troubleshoot, and take part.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Upgrade, secure**
     - :ref:`Release notes <release_notes>` •
       :ref:`Upgrade instructions <release_upgrade>` •
       :ref:`Backward compatibility <exp_workshop_backward_compat>` •
       :doc:`Security policy </security>`

   * - **Diagnose, repair**
     - :ref:`Debug issues <how_debug_issues_workshops>` •
       :ref:`Wait on error <how_debug_wait_on_error>` •
       :ref:`Resolve plug conflicts <how_resolve_plug_conflicts>` •
       :ref:`Fix the installation <how_troubleshoot>` •
       :ref:`Purge workshops <how_purge>`

   * - **Contribute**
     - :ref:`Contribute <contributing>` •
       :ref:`Development <contributing_development>` •
       :ref:`Documentation <contributing_documentation>` •
       :ref:`Maintenance <contributing_maintenance>`


How this documentation is organized
-----------------------------------

This documentation follows the `Diátaxis documentation framework <https://diataxis.fr/>`_,
organizing content by the type of information users need.
The four sections serve different purposes:

:doc:`Tutorial <tutorial/index>`: Hands-on learning path for new |ws_markup| users,
progressing from basic operations through interface usage to SDK development.

:doc:`How-to guides <how-to/index>`: Step-by-step instructions for specific tasks
like connecting IDEs, managing projects, and troubleshooting issues.

:doc:`Reference <reference/index>`: Technical specifications for CLI commands,
definition file formats, and internal behavior.

:doc:`Explanation <explanation/index>`: In-depth discussion of |ws_markup| architecture,
concepts, and design principles.

----

.. _project_community:

Project and community
---------------------

|ws_markup| is an emergent project
within the DevEx department here at Canonical;
|sdk_markup| is its sibling project,
aimed at publishers who create and distribute SDKs for |ws_markup|.

At its core, |ws_markup| builds upon Canonical's mature tech.
It uses `LXD`_ as the underlying container technology;
it also follows the tooling paradigm exemplified by
`Snap <https://snapcraft.io/docs/>`_,
and implemented with
`Craft CLI <https://craft-cli.readthedocs.io/en/latest/>`_.

.. rubric:: Get involved

- :ref:`Contribute <contributing>`
- :ref:`Contribute to development <contributing_development>`
- :ref:`Contribute to this documentation <contributing_documentation>`

.. rubric:: Releases and roadmap

- :ref:`Release notes <release_notes>`

.. rubric:: Governance and policies

- `Code of conduct <https://ubuntu.com/community/docs/ethos/code-of-conduct>`__
- :doc:`Security policy </security>`
- `License <https://github.com/canonical/workshop/blob/main/LICENSE>`__

.. rubric:: Feedback and support

- `Product and documentation feedback <https://github.com/canonical/workshop/issues>`__
