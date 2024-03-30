# Terraform Module for RKE2 Cluster in Hetzner Cloud

This is a [Terraform](https://www.terraform.io/) module to create and
manage an [RKE2](https://docs.rke2.io/) cluster on
[Hetzner Cloud](https://www.hetzner.com/cloud/) platform. At very
minimum you will get out of the box:

* a highly available RKE2 cluster with three master nodes;
* a load balancer for the cluster's API and HTTP/HTTPS ingress traffic;
* [Hetzner Cloud Controller Manager](https://github.com/hetznercloud/hcloud-cloud-controller-manager);
* [Ingress NGINX Controller](https://kubernetes.github.io/ingress-nginx/)
  configured to work with the load balancer;
* [cert-manager](https://cert-manager.io/).

## What You Need

* Hetzner Cloud account and read/write API token;
* (optionally) Hetzner DNS API token with access to the cluster's
  DNS zone;
* Terraform or [OpenTofu](https://opentofu.org/) CLI client.

## Basic Configuration

Create `terraform.tfvars` containing at least the following
variable values.

```hcl
domain       = "mydomain.tld"
cluster_name = "mycluster"
hcloud_token = "hetzner-cloud-token"
```

Obviously, use your own values. You don't need to own the listed domain
if you don't plan to provision DNS records (see below).

Initialize Terraform.

```shell
terraform init
```

Apply the configuration.

```shell
terraform apply
```

This will create an RKE2 cluster and output the information about
the load balancer and node information.

## Customizations

### Config Files

For convenience, you can ask the configuration to store the SSH
private key, `id_rsa_mycluster`, as well as Kubernetes configuration
file, `config-mycluster.yaml`, in the current folder.
Note: _mycluster_ in the name comes from `cluster_name` variable in
the configuration.

```hcl
write_config_files = true
```

Then you can access cluster's nodes using the following command.

```shell
ssh -l root -i id_rsa_mycluster <node IP>
```

Make sure the load balancer is healthy. You can access the cluster using
Kubernetes CLI.

```shell
kubectl get nodes --kubeconfig=config-mycluster.yaml
```

Alternatively, you can extract the content of the files using
`output` command.

```shell
terraform output -raw kubeconfig >~/.kube/config
terraform output -raw ssh_private_key >~/.ssh/id_rsa
```

### Agent Nodes

You can create additional agent nodes in the cluster by specifying
`agent_count` value. This value can be adjusted after the initial
cluster creation.

```hcl
agent_count = 5
```

### Node Specifications and Location

You can specify the server type and the image to use for the nodes as
well as the location where create the nodes. By default,
the configuration uses `cax11` machines running `ubuntu-22.04` image
at `nbg1` Hetzner location.

```hcl
location    = "fsn1"
master_type = "cax21"
agent_type  = "cax31"
image       = "ubuntu-20.04"
```

### DNS

If you own the DNS zone for the cluster and host it in Hetzner DNS,
you can provision `A` and `AAAA` wildcard records for the cluster's
load balancer.

```hcl
hdns_token = "hetzner-dns-token"
```

This will create the following records:

```
*.mycluster.mydomain.tld.   300 A       <load balancer's IPv4>
*.mycluster.mydomain.tld.   300 AAAA    <load balancer's IPv6>
```

Having these records in place, you can access the cluster's Kubernetes
API using <https://api.mycluster.mydomain.tld:6443> URL. The Kubernetes
configuration file produced by the configuration will use that instead
of the IP address of the load balancer.

The applications hosted in the cluster and using ingress objects
to provide access to them, can use URLs similar to this one:
<https://myapp.mycluster.mydomain.tld/>. The certificate for the name can
be obtained using `lets-encrypt` cluster issuer.

### Additional Services

You can configure a [Let's Encrypt](https://duckduckgo.com/) cluster
issuer by specifying this variable. You probably want this as it will
be used to protect web UI URLs of the services listed below.

```hcl
acme_email = "my.mail@mydomain.tld"
```

The configuration can deploy the following additional cluster services
by setting their corresponding variable values to `true`.

```hcl
use_hcloud_storage = true // use Hetzner Cloud CSI driver
use_longhorn       = true // use Longhorn distributed block storage
use_headlamp       = true // use Headlamp Kubernetes UI
```

If only Hetzner Cloud CSI driver is deployed, `hcloud` storage class
becomes the default one for the cluster. If
[Longhorn](https://longhorn.io/) is deployed, by itself or in addition
to Hetzner Cloud CSI driver, then `longhorn` storage class becomes
the default.

Longhorn UI will be available at
<https://longhorn.mycluster.mydomain.tld/>. It is protected by Basic
authentication. The username is `longhorn`. To retrieve the password
use:

```shell
terraform output longhorn_password
```

[Headlamp](https://headlamp.dev/) UI will be available at
<https://headlamp.mycluster.mydomain.tld/>. You can get the
authentication token for it by running:

```shell
kubectl create token headlamp -n headlamp \
    --kubeconfig=config-mycluster.yaml
```

### Software Versions

You can control what versions of software to deploy by setting these
variables.

```hcl
rke2_version         = "v1.27.11+rke2r1"
hcloud_ccm_version   = "1.19.0"
hcloud_csi_version   = "2.6.0"
cert_manager_version = "v1.14.4"
longhorn_version     = "1.5.4"
```

The version of Ingress NGINX Controller is controlled by the
RKE2 version (see RKE2 Release Notes).

## Maintenance

### Rebooting a Node

You can reboot or power down any individual node in the cluster.
Here is the procedure.

1. Obtain the information about nodes in the cluster and find the
   node you want to reboot. For example: `mycluster-agent-9wsi3q`.
   ```shell
   kubectl get nodes --kubeconfig=config-mycluster.yaml
   ```
2. [Drain the node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/).
   ```shell
   kubectl drain --ignore-daemonsets mycluster-agent-9wsi3q \
       --kubeconfig=config-mycluster.yaml
   ```
   Wait for the command to finish.
3. Power down or reboot the node.
4. Once the server is back up, mark the node as usable.
   ```shell
   kubectl uncordon mycluster-agent-9wsi3q \
       --kubeconfig=config-mycluster.yaml
   ```

### Rebuilding a Node

You can rebuild any individual node in the cluster be that an agent or
a master node. A new node is created first and then the existing node
is destroyed. The procedure follows.

1. Obtain the information about nodes in the cluster and find the
   node you want to rebuild. Note the type of the node (master vs agent).
   For example: `mycluster-agent-9wsi3q`.
   ```shell
   kubectl get nodes --kubeconfig=config-mycluster.yaml
   terraform output agent
   ```
   For a master node use `output master`. Calculate the zero-based index
   of the node in the list. For example: `3`.
2. Drain the node.
   ```shell
   kubectl drain --ignore-daemonsets mycluster-agent-9wsi3q \
       --kubeconfig=config-mycluster.yaml
   ```
   Wait for the command to finish.
3. Replace the name suffix.
   ```shell
   terraform apply -replace 'module.cluster.random_string.agent[3]'
   ```
   This will replace the node as described above. For master nodes use
   `module.cluster.random_string.master` instances.

### Destroying the Cluster

If you are just playing with the setup, or setting up some experiments,
and need to remove the cluster cleanly, you can run the following
command. **ALL YOUR DATA IN THE CLUSTER WILL BE LOST!**

```shell
terraform destroy
```

## Credits

The original code in this repository comes from Sven Mattsen,
<https://github.com/scm2342/rke2-build-hetzner>. Further development
was influenced by ideas picked up from Felix Wenzel,
<https://github.com/wenzel-felix/terraform-hcloud-rke2>.
