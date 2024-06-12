# ServeMyKind - Batteries-included KinD cluster 🔋🐋

<img
    src='.github/assets/SmK.svg'
    alt='Serve My Kind logo'
    width='200'
    style='display: block; margin: 0 auto;'
/>

This Ansible playbook is designed to deploy a local Kind cluster with NGINX ingress controller and DNS configuration which allows to resolve the services by their FQDNs from the perspective of the host machine.

The resulting cluster is intended to be used for development and testing purposes, where the user can deploy applications and services and access them via the host machine's browser, similar to a production environment where services are accessed via a domain name.

Everything happens *automagically*, 🧙‍♂️ - the **cluster-specific** root CA is generated, attached to KinD nodes operating on the dedicated subnet, ingress
configuration is applied, and DNS is configured on the host machine.

You can literally name Your cluster `my.k00bernetes` and access it via `https://<service>.my.k00bernetes`! 🚀

## Requirements

Tasks defined in this playbook **require sudo privileges** within the shell environment in which they are executed.

For Ansible:

* `kubernetes.core` collection

## Usage

To install Kind cluster (if not present), apply NGINX ingress manifests and DNS configuration, and run the following command:

```bash
ansible-playbook -i ./environments/<ENVIRONMENT> install.yml
```

After running the playbook, all current Internet connections will be disconnected for a short period due to the DNS configuration being applied by restarting the NetworkManager service.

To change the group of target hosts, edit the `apply.yml` file accordingly.

**The default group of target hosts is set to**: `hosts: "all"`.

To remove the cluster and other assets on host machine (like certificates with their auto-untrusting), use the `uninstall.yml` playbook.

## Assumptions

**READ CAREFULLY BEFORE RUNNING THE PLAYBOOK!**

* The playbook is executed on a Linux machine with at least Python 3 installed:

    The playbook is designed to work on Linux machines, as it uses NetworkManager and dnsmasq to configure DNS. Also, all of the paths use the Linux filesystem structure, cba to make it work on Windows/Mac as those are not my OSes of choice. 😅

* The machine has Docker, Ansible and Helm installed:

    I mean, just look at the tasks in the playbook: like 80% of them are about botching together a KinD cluster with somewhat sketchy manifests.

* Networking is managed by a combo of NetworkManager and dnsmasq:

    The playbook **will** install dnsmasq and NetworkManager if they are not present on the host machine! This is required for the DNS configuration to work properly. *(In the future, other DNS configuration methods may be supported.)*

## Roles

* `cluster` - installs Kind cluster and attached freshly generated CA certificate
* `cni` - installs Cilium CNI, enables load balancing using MetalLB and installs NGINX ingress controller
* `dns` - configures DNS for the cluster on host machine, modifying its NetworkManager and dnsmasq configuration files
* `ca` - enables certificate generation for the cluster via cert-manager and installs the CA certificate on the host machine (trusts it across the system)
* `post` - applies additional manifests to the cluster (e.g. Helm charts, custom resources, etc.)

## Variables

**WIP**

### Internal variables

There is also a plethora of internal variables (prefixed with `_`) that are omitted from this list. They are used for internal purposes and gnerally should not be modified.

Each role has its own set of variables, which are defined in the `vars/main.yml` file of the role.

## Resources

* [Using dnsmasq for local Kind clusters](https://medium.com/@charled.breteche/using-dnsmasq-with-a-local-kind-clusters-9a27c8987073)
* [Kind cluster with Cilium and no kube-proxy](https://medium.com/@charled.breteche/kind-cluster-with-cilium-and-no-kube-proxy-c6f4d84b5a9d)
* [Play with Cilium native routing in Kind cluster](https://medium.com/@nahelou.j/play-with-cilium-native-routing-in-kind-cluster-5a9e586a81ca)
