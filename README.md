# RHEL9 Image for Molecule testing

Container Image, based on UBI8, for testing Ansible content with Molecule.

A user `ansible` is created with password-less sudo configured. A couple of default packages are installed, but not all packages as in a *normal* RHEL9 installation. Add additional packages in a `prepare.yml` during Molecule *create* stage.

[![Container Build and Publish](https://github.com/TimGrt/rhel9-molecule-test-image/actions/workflows/cd.yml/badge.svg)](https://github.com/TimGrt/rhel9-molecule-test-image/actions/workflows/cd.yml)

## How to Build

If you need to build the image on your own locally, do the following:

  1. [Install Podman](https://podman.io/docs/installation).
  2. Clone the repository and `cd` into this directory.
  3. Run `podman build -t rhel9-molecule-test .`

## How to Use with Molecule

  1. [Install Podman](https://podman.io/docs/installation).
  2. [Install Molecule](https://ansible.readthedocs.io/projects/molecule/installation/).
  3. Install Ansible Collection dependencies: `ansible-galaxy collection install containers.podman`.
  4. Add Image in `molecule.yml`.

For example:

```yaml
---
driver:
  name: podman
platforms:
  - name: rhel9-molecule-test
    image: ghcr.io/timgrt/rhel9-molecule-test-image:main
    groups:
      - molecule
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    command: "/usr/sbin/init"
    pre_build_image: true
    exposed_ports:
      - 80/tcp
    published_ports:
      - 8080:80/tcp
provisioner:
  name: ansible
  config_options:
    defaults:
      interpreter_python: auto_silent
      callbacks_enabled: profile_tasks, timer
      callback_result_format: yaml
      remote_user: ansible
      roles_path: "$MOLECULE_PROJECT_DIRECTORY/.."
    ssh_connection:
      pipelining: false
scenario:
  create_sequence:
    - create
  converge_sequence:
    - create
    - converge
  destroy_sequence:
    - destroy
  test_sequence:
    - destroy
    - create
    - syntax
    - converge
    - idempotence
    - destroy

```

The example above uses Callback plugins from `ansible.posix`.
