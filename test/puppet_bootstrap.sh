#!/usr/bin/env bash
#
# This bootstraps Puppet on Ubuntu 16.04 LTS.
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

# wipe out flaky default sources.list on jessie
SOURCES_LIST="/etc/apt/sources.list"
if grep -q jessie ${SOURCES_LIST} ; then
echo "deb http://ftp.us.debian.org/debian jessie main" >| ${SOURCES_LIST}
echo "deb http://security.debian.org jessie/updates main" >> ${SOURCES_LIST}
fi

# Install the PuppetLabs repo
echo "Configuring PuppetLabs repo..."
repo_deb_path=$(mktemp)
wget --output-document=${repo_deb_path} ${REPO_DEB_URL} 2>/dev/null
dpkg -i ${repo_deb_path} >/dev/null
apt-get update >/dev/null

echo "Installing Puppet..."
apt-get install -y puppet-agent > /dev/null
/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true >/dev/null
echo "Puppet installed!"
