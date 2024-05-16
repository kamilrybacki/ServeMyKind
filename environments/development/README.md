# Development environment

This environment is used for development and testing purposes.
It uses a locally deployed `kind` cluster, with Python virtual environments managed with `pyenv`.

Thus, in the `group_vars/all.yml` file, the `ansible_python_interpreter` variable is set to the Python 3 shim located in `$HOME/.pyenv/shims/python3`.

For connection with the local cluster, the `ansible_connection` variable is explicitly set to `local`.

## Variables

These following variables are used by playbooks connected to operations on Kubernetes clusters.

### Global variables

These variables are shared by **all playbooks** and **all environments**
since they are used to configure the connection to the Kubernetes cluster
i.e. **host machine** configuration that communicates with K8s API.

They are to be defined in the `inventory.yml` file.

* `k8s_manifests_and_configs_path` - the path where auxiliary files e.g. Jinja2 templates will be rendered to **on host machine** that will be applying manifests to a K8s cluster (default: `"/tmp"`)
* `k8s_kubeconfig_path` - path to Kubeconfig **on the host machine** to be used i.e. where the cluster entry/context will be added (default: `"{{ lookup('ansible.builtin.env', 'HOME') }}/.kube/config"`)
