#!/bin/sh -eux

if [ -s /etc/oracle-release ]; then
  distro='oracle'
elif [ -s /etc/enterprise-release ]; then
  distro='oracle'
elif [ -s /etc/redhat-release ]; then
  # should ouput 'centos' OR 'red hat'
  distro=$(sed 's/^\(CentOS\|Red Hat\).*/\1/i' /etc/redhat-release | tr '[:upper:]' '[:lower:]')
fi


# Remove development and kernel source packages
yum -y remove gcc cpp kernel-devel kernel-headers perl;

if [ "$distro" != 'red hat' ]; then
  yum -y clean all;
fi

# Clean up network interface persistence
rm -f /etc/udev/rules.d/70-persistent-net.rules;
mkdir -p /etc/udev/rules.d/70-persistent-net.rules;
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules;
rm -rf /dev/.udev/;

for ndev in /etc/sysconfig/network-scripts/ifcfg-*; do
    if [ "$(basename "$ndev")" != "ifcfg-lo" ]; then
        sed -i '/^HWADDR/d' "$ndev";
        sed -i '/^UUID/d' "$ndev";
    fi
done

rm -f VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?;
