#include "crossapprunner.h"
#include "device/crossqemuruntime.h"

using namespace CrossProjectManager;
using namespace Internal;

CrossAppRunner::CrossAppRunner(QObject *parent) :
    QObject(parent)
{
    m_runner=new QSsh::SshRemoteProcessRunner(this);
    m_commandKiller=new QSsh::SshRemoteProcessRunner(this);
    connect(m_runner,SIGNAL(processStarted()),this,SIGNAL(processStarted()));

    const CrossQemuRuntime rt;
    m_sshParameter=rt.sshParameter();

}

void CrossAppRunner::runTarget(const QString &command, const QString &argu)
{
    connect(m_runner,SIGNAL(connectionError()),this,SLOT(handleConnectionError()));
    connect(m_runner,SIGNAL(processStarted()),this,SLOT(handleProcessStarted()));
    connect(m_runner,SIGNAL(processClosed(int)),this,SLOT(handleProcessClosed(int)));
    connect(m_runner,SIGNAL(readyReadStandardError()),this,SLOT(handleStderr()));
    connect(m_runner,SIGNAL(readyReadStandardOutput()),this,SLOT(handleStdout()));
    connect(m_runner,SIGNAL(processClosed(int)),this,SIGNAL(processExited(int)));

    m_command=command;
    if(argu.isEmpty())
        m_runner->run(command.toAscii(),m_sshParameter);
    else
        m_runner->run(QString(command+QLatin1String(" ")+argu).toAscii(),m_sshParameter);
}

void CrossAppRunner::killTarget()
{
    qDebug()<<"going to be killed!! command"<<m_command;

    disconnect(m_runner,SIGNAL(connectionError()),this,SLOT(handleConnectionError()));
    disconnect(m_runner,SIGNAL(processStarted()),this,SLOT(handleProcessStarted()));
    disconnect(m_runner,SIGNAL(processClosed(int)),this,SLOT(handleProcessClosed(int)));
    disconnect(m_runner,SIGNAL(readyReadStandardError()),this,SLOT(handleStderr()));
    disconnect(m_runner,SIGNAL(readyReadStandardOutput()),this,SLOT(handleStdout()));

    m_commandKiller->run(tr("pkill %1").arg(QLatin1String("gdbserver")).toAscii(),m_sshParameter);
    m_runner->cancel();
    emit processExited(QSsh::SshRemoteProcess::NormalExit);
}

bool CrossAppRunner::isRunning()
{
    return m_runner->isProcessRunning();
}


void CrossAppRunner::handleConnectionError()
{
    QString error=m_runner->lastConnectionErrorString();
    emit errorMessage(error);
    emit processExited(QSsh::SshRemoteProcess::FailedToStart);
}

void CrossAppRunner::handleProcessStarted()
{
    emit normaleMessage(QLatin1String("Remote process started\n"));
}

void CrossAppRunner::handleProcessClosed(int exitStatus)
{
    if(exitStatus==QSsh::SshRemoteProcess::FailedToStart||
            exitStatus==QSsh::SshRemoteProcess::CrashExit)
        emit errorMessage(QLatin1String("Remote process unexceped exited\n"));
    else if(exitStatus==QSsh::SshRemoteProcess::NormalExit)
        emit normaleMessage(QLatin1String("Remote process exited\n"));
}

void CrossAppRunner::handleStdout()
{
    emit normaleMessage(QLatin1String(m_runner->readAllStandardOutput()));
}

void CrossAppRunner::handleStderr()
{
    emit normaleMessage(QString(QLatin1String("Error: %1")).arg(QString(QLatin1String(m_runner->readAllStandardError()))));
}
