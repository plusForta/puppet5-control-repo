# Testing Puppet

This [Vagrantfile](./Vagrantfile) will create a test puppetserver and any test nodes you specify.

## How to use

To use it, simply do the following:

- verify the node(s) you want to test is present in the puppet repo and the Vagrantfile
- Bring up the master
```bash
vagrant up master```
- Bring up any host nodes you specify
```bash
vagrant up $hostname```

This will bring up the master and any nodes in turn.

_The master should be fine, but pay attention to the output when bringing up nodes - puppet is automatically run once the node is brought up, but if the node or modules have errors they will be displayed here._

Either way, once the node is up, you can ssh to the system by running:
```bash
vagrant ssh $hostname
```

Once you're logged in you can run (as root) the following command to have puppet do its thing:

```bash
puppet agent -t --server=puppet-test.pfdev.de
```

You can add the '--debug' flag to see more information about the puppet run.

A few things to note:
- You can safely ignore "==> master: dpkg-preconfigure: unable to re-open stdin: No such file or directory"
- The puppet master is NOT running puppet against itself.
- Because we aren't using r10k on the test puppetserver, the _production_ environment on test server will
be **whatever branch you have checked out locally**. Make sure you understand what this means!   All the test nodes are configured as "production."   This means you can't really test the staging environment here.
- You might see errors about "execution expired" when replicating the puppet master classes to the client, this is ok our VMs are slow and simply re-running the puppet agent line from above should fix it.

If you need to destroy and recreate the client but not the master, you may run into certificate issues. You can either destroy the master and node(s), or run the following on the master/node(s) as root:
On the master:
```bash
puppet cert clean $fqdnOfNode
```
On the node:
```bash
find /var/lib/puppet/ssl -name $fqdnOfNode.pem -delete
```
