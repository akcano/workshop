:slug: home-page
:relatedlinks: [Workshop](https://github.com/canonical/workshop/), [SDKcraft](https://github.com/canonical/sdkcraft/), [LXD](https://canonical.com/lxd/docs/default/), [Snap](https://snapcraft.io/docs/)

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
and ships agentic skills for :ref:`operating workshops <ref_ai_use_workshop_skill>`
and :ref:`designing SDKs <ref_ai_design_sdk_skill>`.

----



In this documentation
---------------------

.. rubric:: Start here

Install |ws_markup|, follow the four-part tutorial, and study working examples.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Install**
     - :ref:`Install Workshop <tut_install>` •
       :ref:`Initialize a project <ref_workshop_init>`

   * - **Tutorial**
     - :ref:`Get started <tut_get_started>` •
       :ref:`Work with interfaces <tut_interfaces>` •
       :ref:`Sketch SDKs <tut_sketch_sdks>` •
       :ref:`Craft SDKs <tut_craft_sdks>`

   * - **Examples**
     - `Reference workshops <https://github.com/canonical/reference-workshops>`__ •
       `Reference SDKs <https://github.com/canonical/reference-sdks>`__


.. rubric:: Anatomy of a workshop

Workshops and the projects that hold them, the SDKs that fill them,
the interfaces that connect them, and the machinery underneath.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Workshops**
     - :ref:`Concepts <exp_workshop_concepts>` •
       :ref:`Status <exp_workshop_status>` •
       :ref:`Launch, refresh, restore <exp_workshop_lifecycle>` •
       :ref:`Base image <exp_base>` •
       :ref:`Definition file <ref_workshop_definition>` •
       :ref:`Status diagrams <ref_workshop_status>` •
       :ref:`Internals <ref_workshop_internals>`

   * - **Projects**
     - :ref:`Concepts <exp_projects>` •
       :ref:`Project updates <tut_project_updates>` •
       :ref:`Multi-workshop patterns <exp_multi_workshop_patterns>`

   * - **SDKs**
     - :ref:`Concepts <exp_sdk_concepts>` •
       :ref:`Definition <exp_sdk_definition>` •
       :ref:`Parts <exp_sdk_parts>` •
       :ref:`Runtime hooks <exp_sdk_hooks>` •
       :ref:`Lifecycle <exp_sdk_lifecycle>` •
       :ref:`Definition file <ref_sdk_definition>` •
       :ref:`Internals <ref_sdk_internals>`

   * - **SDK origins**
     - :ref:`System SDK <exp_system_sdk>` •
       :ref:`SDK Store <exp_sdk_store>` •
       :ref:`In-project SDKs <exp_in_project_sdk>` •
       :ref:`Sketch SDKs <exp_sketch_sdk>` •
       :ref:`Test and try SDKs <exp_test_try_sdk>` •
       :ref:`Channels <ref_sdk_channels>`

   * - **Interfaces**
     - :ref:`Concepts <exp_interface_concepts>` •
       :ref:`Plugs and slots <exp_plugs_slots>` •
       :ref:`Auto-connection <exp_interface_auto_connection>` •
       :ref:`Connections <exp_interface_connections>` •
       :ref:`Plug bindings <exp_plug_bindings>` •
       :ref:`Validation <exp_interfaces_validation>` •
       :ref:`Connections across refresh and restore <exp_workshop_connection_lifecycle>`

   * - **Changes and tasks**
     - :ref:`Concepts <exp_changes_tasks>` •
       :ref:`Track changes and tasks <tut_changes_tasks>`

   * - **Command-line tools**
     - :ref:`Overview <exp_cli>` •
       :ref:`workshop <ref_workshop__cli>` •
       :ref:`sdk <ref_sdk__cli>` •
       :ref:`sdkcraft <ref_sdkcraft__cli>` •
       :ref:`workshopctl <ref_workshopctl__cli>` •
       :ref:`Shell completion <ref_workshop__cli_completion>`

   * - **Architecture**
     - :ref:`System components <exp_arch_system_components>` •
       :ref:`Daemon <exp_arch_daemon>` •
       :ref:`REST API <exp_arch_api>` •
       :ref:`LXD backend <exp_arch_lxd_backend>` •
       :ref:`Storage backends <exp_arch_zfs_storage>` •
       :ref:`State database <exp_arch_state_database>` •
       :ref:`Images <exp_arch_images>` •
       :ref:`Network <exp_arch_network>` •
       :ref:`Runtime behavior <exp_arch_runtime_behavior>` •
       :ref:`Launch process <exp_arch_workshop_launch>` •
       :ref:`Container layout <exp_arch_container_layout>`


.. rubric:: Everyday work in a workshop

Run, tailor, and wire workshops as you develop.

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
       :ref:`List <ref_workshop_list>` •
       :ref:`Info <ref_workshop_info>`

   * - **Commands and actions**
     - :ref:`Execute commands <ref_workshop_exec>` •
       :ref:`Interactive shell <ref_workshop_shell>` •
       :ref:`Add actions <how_add_actions>` •
       :ref:`Run actions <ref_workshop_run>` •
       :ref:`List actions <ref_workshop_actions>` •
       :ref:`Actions explained <exp_workshop_definition_actions>` •
       :ref:`Action entry <ref_workshop_definition_action_entry>`

   * - **Tailor with SDKs**
     - :ref:`Add SDKs <exp_workshop_definition_sdks>` •
       :ref:`SDK entry <ref_workshop_definition_sdk_entry>` •
       :ref:`Find SDKs <ref_sdk_find>` •
       :ref:`Inspect an SDK <ref_sdk_info>` •
       :ref:`List installed SDKs <ref_sdk_list>` •
       :ref:`Sketch an SDK <ref_workshop_sketch-sdk>` •
       :ref:`Manage sketches <ref_workshop_sketches>`

   * - **Connect interfaces**
     - :ref:`Plugs, slots, connections <exp_workshop_definition_connections>` •
       :ref:`Connect <ref_workshop_connect>` •
       :ref:`Disconnect <ref_workshop_disconnect>` •
       :ref:`List connections <ref_workshop_connections>` •
       :ref:`Remount <ref_workshop_remount>` •
       :ref:`CLI operations <exp_interfaces_cli_operations>` •
       :ref:`Plug or slot entry <ref_workshop_definition_plug_slot>` •
       :ref:`Connection entry <ref_workshop_definition_connection_entry>` •
       :ref:`Interface syntax <ref_workshop_definition_interfaces>`

   * - **Projects and multiple workshops**
     - :ref:`Move projects <how_move_projects>` •
       :ref:`Use multiple workshops <how_use_multiple_workshops>`


.. rubric:: Craft and publish SDKs

Package languages, tools, and libraries into SDKs, try them locally,
and release them to the SDK Store.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Design**
     - :ref:`Best practices <exp_sdk_best_practices>` •
       :ref:`System services <exp_best_services>` •
       :ref:`Parts decomposition <exp_best_parts_decomposition>` •
       :ref:`Interface layout <exp_best_interfaces>` •
       :ref:`Parts or hooks? <exp_best_parts_or_hooks>` •
       :ref:`Health checks <exp_best_health_checks>` •
       :ref:`Dependencies <exp_best_dependencies>` •
       :ref:`SDKs vs Dockerfiles <exp_dockerfile_vs_sdk>` •
       :ref:`Content sharing <exp_content_sharing>`

   * - **Build**
     - :ref:`Build an SDK <how_build_sdk>` •
       :ref:`Write runtime hooks <how_write_runtime_hooks>` •
       :ref:`Declare plugs and slots <how_declare_plugs_slots>` •
       :ref:`Configure a mount <how_configure_mount>` •
       :ref:`Share content between SDKs <how_share_content_between_sdks>` •
       :ref:`init <ref_sdkcraft_init>` •
       :ref:`pull <ref_sdkcraft_pull>` •
       :ref:`build <ref_sdkcraft_build>` •
       :ref:`stage <ref_sdkcraft_stage>` •
       :ref:`prime <ref_sdkcraft_prime>` •
       :ref:`pack <ref_sdkcraft_pack>` •
       :ref:`clean <ref_sdkcraft_clean>`

   * - **Try and test**
     - :ref:`Try the SDK <how_build_sdk_try>` •
       :ref:`sdkcraft try <ref_sdkcraft_try>` •
       :ref:`sdkcraft test <ref_sdkcraft_test>` •
       :ref:`Report health with workshopctl <exp_workshopctl_health>`

   * - **Publish**
     - :ref:`Publish an SDK <how_publish_sdk>` •
       :ref:`Automate uploads from CI <how_publish_sdk_ci>` •
       :ref:`login <ref_sdkcraft_login>` •
       :ref:`register <ref_sdkcraft_register>` •
       :ref:`upload <ref_sdkcraft_upload>` •
       :ref:`release <ref_sdkcraft_release>` •
       :ref:`revisions <ref_sdkcraft_revisions>` •
       :ref:`create-track <ref_sdkcraft_create_track>`

   * - **Definition files**
     - :ref:`sdkcraft.yaml <ref_sdkcraft_definition>` •
       :ref:`Platforms <ref_sdkcraft_definition_platforms>` •
       :ref:`Parts <ref_sdkcraft_definition_parts>` •
       :ref:`Interfaces <ref_sdkcraft_definition_interfaces>` •
       :ref:`sdk.yaml unknown keys <ref_sdk_definition_unknown_keys>` •
       :ref:`sdk.yaml interfaces <ref_sdk_definition_interfaces>`

   * - **Under the hood**
     - :ref:`Source directory <ref_sdk_directory>` •
       :ref:`Platform <ref_sdk_platform>` •
       :ref:`Parts <ref_sdk_parts>` •
       :ref:`Plugs and slots <ref_sdk_plugs_slots>` •
       :ref:`Hooks <ref_sdk_hooks>` •
       :ref:`State <ref_sdk_state>`


.. rubric:: Host resources and developer tooling

What a workshop reaches outside its sandbox: files, hardware, networks,
credentials, editors, toolchains, CI, and AI agents.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Files and storage**
     - :ref:`Mount interface <exp_mount_interface>` •
       :ref:`Add mounts <how_add_mounts>` •
       :ref:`Reset a remount <how_reset_remount>` •
       :ref:`Mount reference <ref_mount_interface>` •
       :ref:`Storage pools <ref_workshop_storage_pools>`

   * - **Hardware**
     - :ref:`GPU <exp_gpu_interface>` •
       :ref:`Camera <exp_camera_interface>` •
       :ref:`Custom device <exp_custom_device_interface>` •
       :ref:`Device subsystems <exp_custom_device_subsystem>` •
       :ref:`Vendor and product filters <exp_custom_device_filters>` •
       :ref:`Use host devices <how_use_host_devices>` •
       :ref:`GPU reference <ref_gpu_interface>` •
       :ref:`Camera reference <ref_camera_interface>` •
       :ref:`Custom device reference <ref_custom_device_interface>`

   * - **Display**
     - :ref:`Desktop interface <exp_desktop_interface>` •
       :ref:`Desktop reference <ref_desktop_interface>`

   * - **Networking**
     - :ref:`Tunnel interface <exp_tunnel_interface>` •
       :ref:`Tunnel connection <exp_tunnel_connection>` •
       :ref:`Forward ports <how_forward_ports>` •
       :ref:`Workshop hostnames <exp_workshop_hostname>` •
       :ref:`Cross-workshop networking <how_use_multiple_workshops_networking>` •
       :ref:`Tunnel reference <ref_tunnel_interface>`

   * - **SSH agent**
     - :ref:`SSH interface <exp_ssh_interface>` •
       :ref:`SSH reference <ref_ssh_interface>`

   * - **Editors and IDEs**
     - :ref:`Connect VS Code <how_vscode_connect_remote>` •
       :ref:`JetBrains Gateway <how_jetbrains_gateway>` •
       :ref:`JupyterLab in browser <how_jupyterlab_run_in_browser>`

   * - **Python**
     - :ref:`Manage Python environments <how_manage_python_environments>` •
       :ref:`Share the environment <how_manage_python_environments_share>` •
       :ref:`Pin the project venv <how_manage_python_environments_pin>`

   * - **Git and CI**
     - :ref:`Use with Git <how_git_workshops>` •
       :ref:`Worktrees <how_git_worktrees>` •
       :ref:`Run GitHub Actions locally <how_run_github_actions_locally>` •
       :ref:`Run workshops in GitHub Actions <how_run_workshops_in_github_actions>` •
       :ref:`Cache SDK data across runs <how_run_workshops_in_github_actions_cache>`

   * - **AI agents**
     - :ref:`Use with AI agents <how_use_workshops_with_ai_agents>` •
       :ref:`Integration points <ref_ai_agents>` •
       :ref:`LLM-readable docs <ref_ai_discovery>` •
       :ref:`Context7 <ref_ai_context7>` •
       :ref:`use-workshop skill <ref_ai_use_workshop_skill>` •
       :ref:`design-sdk skill <ref_ai_design_sdk_skill>`


.. rubric:: Maintain, secure, contribute

Keep installations current and secure, diagnose and repair workshops,
and take part in the project.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Releases and upgrades**
     - :ref:`Release notes <release_notes>` •
       :ref:`Release policy and LTS <release_policy>` •
       :ref:`Upgrade <release_upgrade>` •
       :ref:`Backward compatibility <exp_workshop_backward_compat>` •
       :ref:`Forward compatibility <ref_workshop_forward_compat>`

   * - **Security**
     - :doc:`Security policy </security>` •
       :ref:`Privileges <security_privileges>` •
       :ref:`Isolation <security_isolation>` •
       :ref:`Risks <security_risks>` •
       :ref:`Report a vulnerability <security_reporting>` •
       :ref:`Local runner security <how_run_github_actions_locally_security>` •
       :ref:`GitHub Action security <how_run_workshops_in_github_actions_security>`

   * - **Diagnose**
     - :ref:`Debug issues <how_debug_issues_workshops>` •
       :ref:`Wait on error <how_debug_wait_on_error>` •
       :ref:`List changes <ref_workshop_changes>` •
       :ref:`List tasks <ref_workshop_tasks>` •
       :ref:`Warnings <ref_workshop_warnings>` •
       :ref:`Acknowledge warnings <ref_workshop_okay>`

   * - **Repair**
     - :ref:`Resolve plug conflicts <how_resolve_plug_conflicts>` •
       :ref:`Fix the installation <how_troubleshoot>` •
       :ref:`Explore LXD containers <how_troubleshoot_lxc>` •
       :ref:`Purge workshops <how_purge>` •
       :ref:`Orphaned workshops <how_purge_orphaned>` •
       :ref:`Manual cleanup <how_purge_manual>`

   * - **Contribute**
     - :ref:`Contribute <contributing>` •
       :ref:`Development <contributing_development>` •
       :ref:`Dev workshop <contributing_dev_workshop>` •
       :ref:`Documentation <contributing_documentation>` •
       :ref:`Maintenance <contributing_maintenance>` •
       :ref:`Release process <contributing_doc_release>` •
       :ref:`CI/CD <contributing_cicd>` •
       :ref:`Coding style <coding_style_guide>` •
       :ref:`Documentation style <doc_style_guide>`


.. rubric:: Workshop in your field

Worked scenarios that combine the pieces above.

.. list-table::
   :widths: 20 80
   :class: borderless

   * - **Agentic engineering**
     - :ref:`Parallel agent runs <how_ai_agents_parallel_runs>` •
       :ref:`Role-based coding <how_ai_agents_role_based>` •
       :ref:`Use with AI agents <how_use_workshops_with_ai_agents>` •
       :ref:`use-workshop skill <ref_ai_use_workshop_skill>` •
       :ref:`design-sdk skill <ref_ai_design_sdk_skill>`

   * - **AI/ML and data science**
     - :ref:`JupyterLab in browser <how_jupyterlab_run_in_browser>` •
       :ref:`Jupyter with a uv environment <tut_jupyter_uv_venv>` •
       :ref:`Python environments <how_manage_python_environments>` •
       :ref:`GPU <exp_gpu_interface>`

   * - **Robotics and embedded**
     - :ref:`ROS 2 case study <exp_ros2_case_study>` •
       :ref:`Use host devices <how_use_host_devices>` •
       :ref:`Camera <exp_camera_interface>` •
       :ref:`Custom device <exp_custom_device_interface>`

   * - **CI/CD**
     - :ref:`Run GitHub Actions locally <how_run_github_actions_locally>` •
       :ref:`Run workshops in GitHub Actions <how_run_workshops_in_github_actions>` •
       :ref:`Automate SDK uploads from CI <how_publish_sdk_ci>`

   * - **Multi-service projects**
     - :ref:`Multi-workshop patterns <exp_multi_workshop_patterns>` •
       :ref:`Use multiple workshops <how_use_multiple_workshops>` •
       :ref:`Cross-workshop networking <how_use_multiple_workshops_networking>`


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
