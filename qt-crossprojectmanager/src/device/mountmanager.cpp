#include "mountmanager.h"
#include "crosssdkinfo.h"
#include <QSettings>
#include <QInputDialog>

#include <QDebug>

using namespace CrossProjectManager;
using namespace Internal;

MountManager *MountManager::m_instance=0;
MountManager &MountManager::instance(QObject *parent)
{
    if(m_instance==0)
        m_instance=new MountManager(parent);
    return *m_instance;
}

MountManager::MountManager(QObject *parent) :
    QObject(parent)
{
    //QSettings settings("crossprojectmanger","creator plugin");
    //m_userPassWord=settings.value("password").toString();
    m_userPassWord=QLatin1String("");
    m_imgdir=CrossSDKInfo::instance().gnuLinuxPath().path()+QLatin1String("/mips64el-rootfs.img");
    m_mountdir=QLatin1String("/mnt/");
}

void MountManager::setMountDir(QString mdir)
{
    m_mountdir=mdir;
}

QString MountManager::getMountDir() const
{
    return m_mountdir;
}

bool MountManager::mount()
{

    if(!isPasswordCorrect()){
        return false;
    }
    if(mountedDirExists()){
        emit errorString(QString(QLatin1String("Already have something mounted in %1 ...continue")).arg(m_mountdir));
        return true;
    }

    if(!QFileInfo(m_imgdir).exists()){
        emit errorString(m_imgdir+QLatin1String("file does not exists\n"));
        return false;
    }
    QProcess proc;
    proc.setEnvironment(QProcess::systemEnvironment());
    proc.start(QString(QLatin1String("sh -c \"echo %1 | sudo -S mount -o loop %2 %3\"")).arg(m_userPassWord).arg(m_imgdir).arg(m_mountdir));
    if(!proc.waitForFinished()){
        emit errorString(QString(QLatin1String("Can't mount image %1")).arg(QString(proc.errorString())));
        return false;
    }
    if(!mountedDirExists()){
        proc.waitForReadyRead();
        emit errorString(QLatin1String(proc.readAllStandardError()));
        return false;
    }
    proc.terminate();
    messageString(QString(QLatin1String("Image mounted in %1")).arg(m_mountdir));
    return true;

}

bool MountManager::unmount()
{
    if(!mountedDirExists()){
        emit errorString(QString(QLatin1String("Already have unmounted in %1 ...continue")).arg(m_mountdir));
        return true;
    }
    QProcess proc;
    proc.setEnvironment(QProcess::systemEnvironment());
    proc.start(QString(QLatin1String("sh -c \"echo %1 | sudo -S umount %2\"")).arg(m_userPassWord).arg(m_mountdir));
    if(!proc.waitForFinished()){
        emit errorString(QString(QLatin1String("Can't unmount image %1")).arg(QString(proc.errorString())));
        return false;
    }
    if(mountedDirExists()){
        proc.waitForReadyRead();
        emit errorString(QLatin1String(proc.readAllStandardError()));
        return false;
    }
    proc.terminate();
    messageString(QString(QLatin1String("Image unmounted.")));
    return true;
}

bool MountManager::mountedDirExists() const
{
    QDir dir(m_mountdir);
    return ((dir.entryList().contains(QLatin1String("bin")))&&
            (dir.entryList().contains(QLatin1String("root")))
            );
}


QString MountManager::getPassWord() const
{
    return m_userPassWord;
}

void MountManager::setPassWord(const QString &psw)
{
    m_userPassWord=psw;
    //QSettings settings("crossprojectmanger","creator plugin");
    //settings.setValue("password", m_userPassWord);
    //settings.sync();
}
bool MountManager::isPasswordCorrect()
{
    if(m_userPassWord.isEmpty()){
        emit errorString(QLatin1String("Need Super User Password"));
        emit needPassword();
        return false;
    }
    QProcess proc;
    proc.setProcessChannelMode(QProcess::MergedChannels);
    proc.start(QString(QLatin1String("sh -c \"echo %1 | sudo -S echo TestSuccess\"")).arg(m_userPassWord));
    proc.waitForFinished(500);
    QString str=QLatin1String(proc.readAllStandardOutput());
    if(!str.contains(QLatin1String("TestSuccess")))
    {
        emit errorString(QLatin1String("Super user password incorrect"));
        emit needPassword();
        return false;
    }
    return true;
}


bool MountManager::isMounted() const
{
    return mountedDirExists();
}

