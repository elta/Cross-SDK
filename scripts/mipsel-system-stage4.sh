#! /bin/bash

source source.sh

[ -d "${PREFIX}" ] || mkdir -p ${PREFIX}
[ -d "${PREFIXMIPSEL}" ] || mkdir -p ${PREFIXMIPSEL}
[ -d "${PREFIXMIPSEL}/tools" ] || mkdir -p ${PREFIXMIPSEL}/tools
[ -d "/tools" ] || sudo ln -s ${PREFIXMIPSEL}/tools /
[ -d "${PREFIXMIPSEL}/cross-tools" ] || mkdir -p ${PREFIXMIPSEL}/cross-tools
[ -d "/cross-tools" ] || sudo ln -s ${PREFIXMIPSEL}/cross-tools /

[ -f "/cross-tools/bin/${CROSS_TARGET32}-gcc" ] || die "No tool chain found"

export PATH=${PATH}:/cross-tools/bin/

export CROSS_TARGET32="mipsel-unknown-linux-gnu"

export CC="${CROSS_TARGET32}-gcc"
export CXX="${CROSS_TARGET32}-g++"
export AR="${CROSS_TARGET32}-ar"
export AS="${CROSS_TARGET32}-as"
export RANLIB="${CROSS_TARGET32}-ranlib"
export LD="${CROSS_TARGET32}-ld"
export STRIP="${CROSS_TARGET32}-strip"

# BEGIN EGLIBC ++
sudo touch ${PREFIXMIPSEL}/etc/ld.so.conf

# Configure EGLIBC +++
sudo cat > ${PREFIXMIPSEL}/etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

# Configure The Dynamic Loader +++
sudo cat > ${PREFIXMIPSEL}/etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf

/usr/local/lib
/opt/lib

# End /etc/ld.so.conf
EOF
# END EGLIBC

# BEGIN RSYSLOG +++
sudo cat > ${PREFIXMIPSEL}/etc/rsyslog.conf << "EOF"
# Begin /etc/rsyslog.conf

# CLFS configuration of rsyslog. For more info use man rsyslog.conf

#######################################################################
# Rsyslog Modules

# Support for Local System Logging
$ModLoad imuxsock.so

# Support for Kernel Logging
$ModLoad imklog.so

#######################################################################
# Global Options

# Use traditional timestamp format.
$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat

# Set the default permissions for all log files.
$FileOwner root
$FileGroup root
$FileCreateMode 0640
$DirCreateMode 0755

# Provides UDP reception
$ModLoad imudp
$UDPServerRun 514

# Disable Repeating of Entries
$RepeatedMsgReduction on

#######################################################################
# Include Rsyslog Config Snippets

$IncludeConfig /etc/rsyslog.d/*.conf

#######################################################################
# Standard Log Files

auth,authpriv.*                 /var/log/auth.log
*.*;auth,authpriv.none          -/var/log/syslog
daemon.*                        -/var/log/daemon.log
kern.*                          -/var/log/kern.log
lpr.*                           -/var/log/lpr.log
mail.*                          -/var/log/mail.log
user.*                          -/var/log/user.log

# Catch All Logs
*.=debug;\
  auth,authpriv.none;\
  news.none;mail.none     -/var/log/debug
  *.=info;*.=notice;*.=warn;\
  auth,authpriv.none;\
  cron,daemon.none;\
  mail,news.none          -/var/log/messages

# Emergencies are shown to everyone
*.emerg                         *

# End /etc/rsyslog.conf
EOF

#END RSYSLOG

# BEGIN SYSVINIT
sudo cat > ${PREFIXMIPSEL}/etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc sysinit

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

EOF

sudo cat >> ${PREFIXMIPSEL}/etc/inittab << "EOF"
1:2345:respawn:/sbin/agetty -I '\033(K' tty1 9600
2:2345:respawn:/sbin/agetty -I '\033(K' tty2 9600
3:2345:respawn:/sbin/agetty -I '\033(K' tty3 9600
4:2345:respawn:/sbin/agetty -I '\033(K' tty4 9600
5:2345:respawn:/sbin/agetty -I '\033(K' tty5 9600
6:2345:respawn:/sbin/agetty -I '\033(K' tty6 9600

EOF

sudo cat >> ${PREFIXMIPSEL}/etc/inittab << "EOF"
c0:12345:respawn:/sbin/agetty 115200 ttyS0 vt100

EOF

sudo cat >> ${PREFIXMIPSEL}/etc/inittab << "EOF"
# End /etc/inittab
EOF

sudo rm -rf /cross-tools /tools

# END SYSVINIT
