# ServeMyKind - Kind local cluster with NGINX ingress controller and DNS configuration

This Ansible playbook is designed to deploy a local Kind cluster with NGINX ingress controller and DNS configuration which allows to resolve the services by their FQDNs from the perspective of the host machine.

## Requirements

Tasks defined in this playbook **require sudo privileges** to be executed.

For Ansible:

* `kubernetes.core` collection

## Usage

To install Kind cluster (if not present), apply NGINX ingress manifests and DNS configuration, and run the following command:

```bash
ansible-playbook -i ./environments/<ENVIRONMENT> install.yml --ask-become-pass
```

**NOTE**: The `--ask-become-pass` flag is required to provide the sudo password for the host machine.

After running the playbook, all current Internet connections will be disconnected for a short period due to the DNS configuration being applied by restarting the NetworkManager service.

To change the group of target hosts, edit the `apply.yml` file accordingly.

**The default group of target hosts is set to**: `hosts: "all"`.

To remove the cluster, use the `uninstall.yml` playbook.

## Roles

* `ensure-tools` - Installs Kind and K8s administration tools if not present
* `setup-cluster` - Deploys Kind cluster with NGINX ingress controller
* `configure-dns` - Configures DNS for the cluster to be able to resolve the services by their FQDNs

## Variables

As default, the cluster will be created with one node of the `control-plane` role.
These variables are to be defined in the `environments/<ENVIRONMENT>/group_vars/<group_name>.yml` file:

* `serve_my_kind_cluster_name` - cluster name suffix (default: `"kind-local"`), used to generate the cluster domain by substituting dashes with dots eg. `kind-local` -> `kind.local`
* (*optional*) `serve_my_kind_manifests_and_configs_path` - the path where auxiliary files e.g. Jinja2 templates will be rendered to **on host machine** that will be applying manifests to a K8s cluster (default: `"/tmp"`)
* (*optional*) `serve_my_kind_kubeconfig_path` - path to Kubeconfig **on the host machine** to be used i.e. where the cluster entry/context will be added (default: `"{{ lookup('ansible.builtin.env', 'HOME') }}/.kube/config"`)
* (*optional*) `serve_my_kind_setup_cluster_extra_nodes` - definition of extra nodes (default: `[]`)
  Each node is defined as a dictionary with the following keys:
  * `role` - node role (available: `"worker"`, `"control-plane"`)
  * `memory` - human-readable memory size (e.g. `"1Gi"`)
  * `cpu` - number of CPUs (e.g. `2`)
  * `amount` - number of nodes with the same configuration (default: `1`)
  * (*optional*) `extraMounts` - list of extra mounts to apply to the node (default: `[]`):
    * `containerPath` - container path to mount to
    * `hostPath` - host path to mount
    * (*optional*) `readOnly` - whether the mount should be read-only (default: `false`)
    * (*optional*) `selinuxRelabel` - whether the mount should be relabeled by SELinux (default: `false`)
    * (*optional*) `mountPropagation` - mount propagation mode (default: `"None"`)
  * (*optional*) `extraLabels` - list of extra labels to apply to the node (default: `[]`):
    * `name` - label key
    * `value` - label value
  * (*optional*) `extraPortMappings` - list of extra port mappings to apply to the node (default: `[]`):
    * `containerPort` - container port to map
    * `hostPort` - host port to map
    * (*optional*) `listenAddress` - address to listen on (default: `"127.0.0.1"`)
    * (*optional*) `protocol` - protocol to use (default: `"TCP"`)
  * (*optional*) `extraKubeadmPatches` - list of extra kubeadm patches to apply to the node (default: `[]`)
* (*optional*) `kind_with_ingress_setup_cluster_ingress_type` - type of the ingress controller to deploy (default: `"ingress-nginx"`)
* (*optional*) `serve_my_kind_configure_dns` - whether to configure DNS for the cluster on host machine (default: `true`)
* (*optional*) `serve_my_kind_configure_dns_network_manager_install` - whether to install NetworkManager (default: `true`)
* (*optional*) `serve_my_kind_configure_dns_dnsmasq_install` - whether to install dnsmasq (default: `true`)

**Important**: if for any node type fields `extraMounts` and/or `extraPortMappings` are defined, the `amount` field is automatically set to `1`, even if its value is specified by the user!

## Resources

* [Using dnsmasq for local Kind clusters
](https://medium.com/@charled.breteche/using-dnsmasq-with-a-local-kind-clusters-9a27c8987073)
