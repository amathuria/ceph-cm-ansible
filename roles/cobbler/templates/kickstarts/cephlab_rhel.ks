## {{ ansible_managed }}
# kickstart template for Fedora 8 and later.
# (includes %end blocks)
# do not use with earlier distros

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
$SNIPPET('cephlab_rhel_disks')
# Use text mode install
text
# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
network --bootproto=dhcp --device=eth0 --onboot=on
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --permissive
# Do not configure the X Window System
skipx
# System timezone
timezone  America/New_York
# Install OS instead of upgrade
install

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
$SNIPPET('cephlab_packages_rhel')
$SNIPPET('func_install_if_enabled')
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('cephlab_hostname')
$SNIPPET('cephlab_user')
$SNIPPET('cephlab_apt-mirror_hack')
$SNIPPET('cephlab_rc_local')
$SNIPPET('kickstart_done')
# End final steps
%end
