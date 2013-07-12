#include "crossqemumanager.h"

//
#include <QDebug>

using namespace CrossProjectManager;
using namespace Internal;

using namespace ProjectExplorer;
CrossQemuManager *CrossQemuManager::m_instance = 0;
CrossQemuManager &CrossQemuManager::instance(QObject *parent)
{
    if (m_instance == 0)
        m_instance = new CrossQemuManager(parent);
    return *m_instance;
}

bool CrossQemuManager::startRuntime()
{
    if(m_qemuProcess->state() == QProcess::Starting ||
            m_qemuProcess->state() == QProcess::Running )
    {
        emit messageString(QLatin1String("Starting Qemu\n"));
        return true;
    }

    //run time env
    const CrossQemuRuntime rt;
    m_hostIP=rt.HostIP();
    m_qemuProcess->setEnvironment(QProcess::systemEnvironment());
    m_qemuProcess->setWorkingDirectory(rt.QemuBinPath());
    //qDebug()<<QString(QLatin1String("xterm -e \"%1 %2 \"")).arg(rt.QemuBinPathAndCMD()).arg(rt.QemuArgs());
    m_qemuProcess->start(QString(QLatin1String("xterm -e \"%1 %2 \"")).arg(rt.QemuBinPathAndCMD()).arg(rt.QemuArgs()));
    if(!m_qemuProcess->waitForStarted(-1)){
        emit errorString(QString(QLatin1String("Can not start qemu %1")).arg(QLatin1String(m_qemuProcess->readAllStandardError())));
        return false;
    }
    emit messageString(QLatin1String("Starting Qemu\n"));
    emit messageString(QLatin1String("Note: If there is no qemu running, please check your path setting and make sure you installed xterm\n"));
    return true;
}

bool CrossQemuManager::stopRuntime()
{

    //a qprocess can not kill twice
    if(m_qemuProcess->state()==QProcess::NotRunning){
        emit errorString(QLatin1String("Qemu not runing"));
        return true;
    }
    m_qemuProcess->terminate();
    m_qemuProcess->kill();
    emit messageString(QLatin1String("Stoping Qemu\n"));
    return true;
}

bool CrossQemuManager::isRuning()
{
    return m_qemuProcess->state()!=QProcess::NotRunning;
}

void CrossQemuManager::userClose()
{
    emit messageString(QLatin1String("Stoping Qemu\n"));
}

bool CrossQemuManager::isComplateStarted()
{
    QProcess proc;
    proc.setEnvironment(QProcess::systemEnvironment());
    proc.start(QString(QLatin1String("ping -c 1 %1")).arg(m_hostIP));
    proc.waitForFinished(1000);
    if(proc.exitCode()==0&&proc.state()==QProcess::NotRunning)
        return true;
    proc.terminate();
    proc.waitForFinished();
    return false;
}

CrossQemuManager::CrossQemuManager(QObject *parent)
    :QObject(parent)
    ,m_qemuProcess(new QProcess(this))
{
    connect(m_qemuProcess,SIGNAL(stateChanged(QProcess::ProcessState)),this,SIGNAL(stateChanged(QProcess::ProcessState)));
    connect(m_qemuProcess,SIGNAL(finished(int)),this,SLOT(userClose()));

}


CrossQemuManager::~CrossQemuManager()
{
    stopRuntime();
    m_instance = 0;
}
