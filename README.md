# plusForta puppet control repo.

## What this is

This repository controls the configuration of all the servers in the plusForta fleet.

It is set up in a roles and profiles configuration:
* Nodes are assigned roles in their hiera configs (e.g. "frontend cms")
* roles contain profiles ("e.g. kirby")
* profiles include other modules as necessary ("e.g. apache")

We use [r10k](https://github.com/puppetlabs/r10k) to manage the actual configuration
on the puppetserver.   This tool uses this repository to configure the final codebase.

r10k does the following:
* Checks out this repository
* Copies each branch of the repo into a separate directory
(e.g /etc/puppetlabs/code/environments/{$branch})
* For each environment, it runs through the Puppetfile file in the root and
checks out the modules included in it.

In this method the full puppet repository is created.

## How to develop against it

* Check in your changes locally.
* Follow the instructions in /test to setup a puppet server and testing nodes
* run r10k deploy environment -p on the local puppet server
* run puppet agent -t --environment="$branch" on your testing nodes.

## How to deploy it

* push your changes to the cloud.
* run r10k deploy environment -p on the puppetserver.
* cross your fingers!
