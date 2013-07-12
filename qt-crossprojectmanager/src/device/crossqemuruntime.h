#ifndef CROSSQEMURUNTIME_H
#define CROSSQEMURUNTIME_H
#include <QString>
#include <QDir>
#include <QObject>
#include <QDebug>
#include <crosssdkinfo.h>
#include <ssh/sshconnection.h>
namespace CrossProjectManager {
namespace Internal {

class CrossQemuRuntime
{
public:


    CrossQemuRuntime(){
        //TODO change it!
        m_sshParameter.authenticationType=QSsh::SshConnectionParameters::AuthenticationByPassword;
        m_sshParameter.port=22;
        m_sshParameter.password=QLatin1String("1");
        m_sshParameter.timeout=5;
        m_sshParameter.userName=QLatin1String("root");



        QemuType q=CrossSDKInfo::instance().getQemuType();

        m_QEMUPath=CrossSDKInfo::instance().qemuPath();
        m_kernalPath=CrossSDKInfo::instance().gnuLinuxPath();
        m_hdaPath=CrossSDKInfo::instance().gnuLinuxPath();

        if(q==_N64RunOn64||q==_O32RunOn64){
            m_binName=QLatin1String("./qemu-system-mips64el");
            m_QEMUExec=m_QEMUPath.path()+QLatin1String("/bin/")+m_binName;
            m_args=QString(QLatin1String(" -kernel %1 -append \"root=/dev/hda\" -hda %2 -net nic -net tap,ifname=qemutap,script=no,downscript=no -M malta -nographic"))
                    .arg(m_kernalPath.path()+QLatin1String("/vmlinux-64")).arg(m_hdaPath.path()+QLatin1String("/mips64el-sysroot.img"));
            m_sshParameter.host=QLatin1String(Constants::QEMU_64BIT_HOST_IP);
        }
        else if(q==_N32RunOn64){
            m_binName=QLatin1String("./qemu-system-mips64el");
            m_QEMUExec=m_QEMUPath.path()+QLatin1String("/bin/")+m_binName;
            m_args=QString(QLatin1String(" -kernel %1 -append \"root=/dev/hda\" -hda %2 -net nic -net tap,ifname=qemutap,script=no,downscript=no -M malta -nographic"))
                    .arg(m_kernalPath.path()+QLatin1String("/vmlinux-n32")).arg(m_hdaPath.path()+QLatin1String("/mips64el-sysroot.img"));
            m_sshParameter.host=QLatin1String(Constants::QEMU_64BIT_HOST_IP);
        }
        else if(q==_O32RunOn32){
            m_binName=QLatin1String("./qemu-system-mipsel");
            m_QEMUExec=m_QEMUPath.path()+QLatin1String("/bin/")+m_binName;
            m_args=QString(QLatin1String(" -kernel %1 -append \"root=/dev/hda\" -hda %2 -net nic -net tap,ifname=qemutap,script=no,downscript=no -M malta -nographic"))
                    .arg(m_kernalPath.path()+QLatin1String("/vmlinux-32")).arg(m_hdaPath.path()+QLatin1String("/mipsel-sysroot.img"));
            m_sshParameter.host=QLatin1String(Constants::QEMU_32BIT_HOST_IP);
        }
    }

    bool isValid() const {
        return !m_binName.isEmpty();
    }
    QString QemuBinName()const{
        return m_binName;
    }
    QString QemuBinPath()const{
        return m_QEMUPath.path();
    }
    QString QemuBinPathAndCMD()const{
        return m_QEMUExec;
    }
    QString QemuArgs()const{
        return m_args;
    }
    QString HostIP() const{
        return m_sshParameter.host;
    }

    QSsh::SshConnectionParameters sshParameter()const{
        return m_sshParameter;
    }
private:
    QDir m_QEMUPath;
    QDir m_kernalPath;
    QDir m_hdaPath;

    QString m_hostIP;
    QString m_QEMUExec;
    QString m_args;
    QString m_binName;
    QString errorString;

    QSsh::SshConnectionParameters m_sshParameter;
};

}   // namespace Internal
}   // namespace CrossProjectManager
#endif // CROSSQEMURUNTIME_H
