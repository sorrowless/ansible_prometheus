sbog/prometheus
===============

Role to install and configure full-fledged monitoring solution based on
Prometheus.

#### Requirements

Ansible>=2.8
We're using remote recurse copy which was added only in Ansible 2.8. Basically
one can rewrite grok exporter and run this role on lower version of Ansible if
he wants to.

Also it is worth to mention that by default Prometheus doesn't work over wild
internet and doesn't support any decent authentication/authorization for
exporters so all the security over not secured network should be done by user
itself. In current role it is done two ways. First, deprecated, is to setup
nginx reverse proxy and setup basic auth in it. This way also supposed to issue
needed certificates. Unfortunately, this way is not so easy to implement as
there can be nodes which don't have a DNS name set up and as a result it is
hard to issue a certificate for them and force prometheus master server to
trust such a certificate. If one wants to go this way though, he should know
that setting up full-fledged PKI is not a part of this role and has to be done
by user itself. Second way to create trusted reliable channel to send data from
nodes exporters to Prometheus master is to create ssh connection to master from
slaves for each of the exporters. Overall idea is that every exporter exposes
TCP port to get metrics from. Then node with such an exporter can create a SSH
reverse proxy connection to the master node. It will allow the master to go to
the locally opened ports on master node and SSH will pass the connection to
according slave node exporter. In such a solution all we need is to setup
trusts between slave nodes and master nodes properly to ensure that such a
connection can be created. This can be done with the role
sorrowless/ansible_ssh_trust.  Connections in our case are wrapped around
AutoSSH services so they are never stalled and in case of failing are reopened.

#### Role Variables

For full list of variables look to `defaults/main.yml` file.

#### Dependencies

None

#### Example Playbook

```yaml
- name: Install monitoring solution
  hosts: monitoring
  remote_user: root
  roles:
    - prometheus
```

#### License

Apache 2.0

#### Author Information

Stan Bogatkin (https://sbog.ru)
