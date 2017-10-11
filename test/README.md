# Testing Puppet

This [Vagrantfile](./Vagrantfile) will create a test puppetserver and any test nodes you specify.

## How to use

To use it, simply do the following:

- verify the node(s) you want to test is present in the puppet repo and the Vagrantfile
- Bring up the master

```bash
vagrant up master
```

- Bring up any host nodes you specify

```bash
vagrant up $hostname
```

_The master should work fine, but pay attention to the output when bringing up nodes - puppet is automatically run once the node is brought up, but if the node or modules have errors they will be displayed here._

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
- Because we are using r10k on the test puppetserver, you will need to commit changes
and then run 'r10k deploy environment -p' as root on the master VM.   I recommend
making a branch called local and testing your changes there before merging or rebasing
into staging/production.
- You might see errors about "execution expired" when replicating the puppet master classes to the client, this is ok. The VMs are slow and simply re-running the puppet agent line from above should fix it.

If you need to destroy and recreate the client but not the master, you may run into certificate issues. You can either destroy the master and node(s), or run the following on the master/node(s) as root:
On the master:
```bash
puppet cert clean $fqdnOfNode
```
On the node:
```bash
find /var/lib/puppet/ssl -name $fqdnOfNode.pem -delete
```
