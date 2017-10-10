#!/usr/bin/env bash
#
# This bootstraps a PuppetServer on Ubuntu 16.04 LTS.
#
set -e

REPO_DEB_URL="https://apt.puppetlabs.com/puppet5-release-xenial.deb"

#--------------------------------------------------------------------
# NO TUNABLES BELOW THIS POINT
#--------------------------------------------------------------------
if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# Install the PuppetLabs repo
echo "Configuring PuppetLabs repo..."
repo_deb_path=$(mktemp)
wget --output-document=${repo_deb_path} ${REPO_DEB_URL} 2>/dev/null
dpkg -i ${repo_deb_path} >/dev/null
apt-get update >/dev/null

echo "Upgrading all packages..."
apt-get upgrade -y >/dev/null

# Install Puppet
echo "Installing Puppet Server..."
apt-get install -y puppetserver >/dev/null

echo "Puppet Server installed!"

PUPPET_DIR="/etc/puppetlabs"

# check to see if this is the first time we're provisioning.
if grep -q "autosign" ${PUPPET_DIR}/puppet/puppet.conf
then
  echo "Autosigning already configured..."
else
  echo "Enable autosigning of certs and dns_alt_names"
  cat </usr/src/puppet/test/masterConf/puppet.conf.snippet >>${PUPPET_DIR}/puppet/puppet.conf
fi

# install r10k
echo "Installing r10k..."
gem install r10k >/dev/null
mkdir -p ${PUPPET_DIR}/r10k/
cp /usr/src/puppet/test/masterConf/r10k.yaml ${PUPPET_DIR}/r10k/

# remove older keys & certificates
rm -fr /var/lib/puppet/ssl/*

echo "Restarting puppet"
service puppetserver restart
