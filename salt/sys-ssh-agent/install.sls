{#
SPDX-FileCopyrightText: 2023 - 2024 Benjamin Grande M. S. <ben.grande.b@gmail.com>

SPDX-License-Identifier: AGPL-3.0-or-later
#}

{% if grains['nodename'] != 'dom0' -%}

include:
  - dev.home-cleanup
  - dotfiles.copy-sh
  - dotfiles.copy-ssh
  - dotfiles.copy-x11

"{{ slsdotpath }}-updated":
  pkg.uptodate:
    - refresh: True

"{{ slsdotpath }}-installed":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - qubes-core-agent-networking
      - ca-certificates
      - socat

{% set pkg = {
    'Debian': {
      'pkg': ['openssh-client'],
    },
    'RedHat': {
      'pkg': ['openssh-clients'],
    },
}.get(grains.os_family) -%}

"{{ slsdotpath }}-installed-os-specific":
  pkg.installed:
    - refresh: True
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ pkg.pkg|sequence|yaml }}

"{{ slsdotpath }}-agent-bin-dir":
  file.recurse:
    - source: salt://{{ slsdotpath }}/files/server/bin
    - name: /usr/bin
    - file_mode: '0755'
    - user: root
    - group: root

"{{ slsdotpath }}-install-rpc-service":
  file.managed:
    - name: /etc/qubes-rpc/qusal.SshAgent
    - source: salt://{{ slsdotpath }}/files/server/rpc/qusal.SshAgent
    - mode: '0755'
    - user: root
    - group: root
    - makedirs: True

"{{ slsdotpath }}-skel-create-ssh-directory":
  file.directory:
    - name: /etc/skel/.ssh
    - mode: '0700'
    - user: user
    - group: user
    - makedirs: True

"{{ slsdotpath }}-skel-create-keys-directory":
  file.directory:
    - name: /etc/skel/.ssh/identities.d
    - mode: '0700'
    - user: root
    - group: root
    - makedirs: True

{% endif -%}
