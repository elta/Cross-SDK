#! /bin/bash

function die() {
  echo "$1"
  exit 1
}

[ -e build.sh ]
export SCRIPT="$(pwd)"
export TARBALL=${SCRIPT}/../tarballs
export PATCH=${SCRIPT}/../patches
export SRCS=${SCRIPT}/../srcs
export SRC=${SCRIPT}/../src/mips64el-pure64-linux/stage2
export BUILD=${SCRIPT}/../build/mips64el-pure64-linux/stage2

[[ $# -eq 1 ]] || die "usage: build.sh PREFIX"
export CROSS="$1"
export PATH=$PATH:/cross-tools/bin/

unset CFLAGS
unset CXXFLAGS
export CFLAGS="-w"
export CROSS_HOST=${MACHTYPE}
export CROSS_TARGET="mips64el-unknown-linux-gnu"
export BUILD64="-mabi=64"

export CC="${CROSS_TARGET}-gcc"
export CXX="${CROSS_TARGET}-g++"
export AR="${CROSS_TARGET}-ar"
export AS="${CROSS_TARGET}-as"
export RANLIB="${CROSS_TARGET}-ranlib"
export LD="${CROSS_TARGET}-ld"
export STRIP="${CROSS_TARGET}-strip"

# BEGIN EGLIBC ++
sudo touch ${CROSS}/etc/ld.so.conf

# Configure EGLIBC +++
sudo cat > ${CROSS}/etc/nsswitch.conf << "EOF"
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
sudo cat > ${CROSS}/etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf

/usr/local/lib
/opt/lib

# End /etc/ld.so.conf
EOF
# END EGLIBC

# BEGIN RSYSLOG +++
sudo cat > ${CROSS}/etc/rsyslog.conf << "EOF"
# Begin /etc/rsyslog.conf

# CROSS configuration of rsyslog. For more info use man rsyslog.conf

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
sudo cat > ${CROSS}/etc/inittab << "EOF"
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

sudo cat >> ${CROSS}/etc/inittab << "EOF"
1:2345:respawn:/sbin/agetty -I '\033(K' tty1 9600
2:2345:respawn:/sbin/agetty -I '\033(K' tty2 9600
3:2345:respawn:/sbin/agetty -I '\033(K' tty3 9600
4:2345:respawn:/sbin/agetty -I '\033(K' tty4 9600
5:2345:respawn:/sbin/agetty -I '\033(K' tty5 9600
6:2345:respawn:/sbin/agetty -I '\033(K' tty6 9600

EOF

sudo cat >> ${CROSS}/etc/inittab << "EOF"
c0:12345:respawn:/sbin/agetty 115200 ttyS0 vt100

EOF

sudo cat >> ${CROSS}/etc/inittab << "EOF"
# End /etc/inittab
EOF



# END SYSVINIT
