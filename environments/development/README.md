# Development environment

This environment is used for development and testing purposes.
It uses a locally deployed `kind` cluster, with Python virtual environments managed with `pyenv`.

Thus, in the `group_vars/all.yml` file, the `ansible_python_interpreter` variable is set to the Python 3 shim located in `$HOME/.pyenv/shims/python3`.

For connection with the local cluster, the `ansible_connection` variable is explicitly set to `local`.

## Variables

The following, non-default settings are used for the `development` environment:

* `fastkind_manifests_and_configs_path`: "/tmp"
* `fastkind_kubeconfig_path`: "{{ lookup('ansible.builtin.env', 'HOME') }}/.kube/config"
* `fastkind_setup_cluster_name`: `"kind-local-dev"`
* `fastkind_configure_dns`: `true`
* `fastkind_configure_dns_network_manager_install`: `false`
* `fastkind_configure_dns_dnsmasq_install`: `false`

The following variables are defined in the `inventory.yml` file, specific to the case of Python virtual environments managed with `pyenv`.
If virtual environments are managed differently, these variables should be adjusted accordingly (or removed):

* `ansible_connection`: `local`
* `ansible_python_interpreter`: "{{ lookup('ansible.builtin.env', 'HOME') }}/.pyenv/shims/python"
