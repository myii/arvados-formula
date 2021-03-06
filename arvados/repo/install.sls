# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import arvados with context %}

{% if arvados.use_upstream_repo -%}
  {% if grains.get('os_family') == 'Debian' -%}
arvados-repo-install-pkgrepo-managed:
  pkgrepo.managed:
    - humanname: {{ arvados.repo.humanname }}
    - name: deb {{ arvados.repo.url_base }}/ {{ grains.get('lsb_distrib_codename') }} main
    - file: {{ arvados.repo.file }}
    - key_url: {{ arvados.repo.key_url }}

  {%- elif grains.get('os_family') == 'RedHat' %}
arvados-repo-install-pkgrepo-managed:
  pkgrepo.managed:
    - name: arvados
    - file: {{ arvados.repo.file }}
    - humanname: {{ arvados.repo.humanname }}
    - baseurl: {{ arvados.repo.url_base }}
    - gpgcheck: 1
    - gpgkey: {{ arvados.repo.gpgkey }}

  {%- else %}
arvados-repo-install-pkgrepo-managed: {}
  {%- endif %}
{%- endif %}
