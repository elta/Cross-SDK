#include "crossdeployhelper.h"

#include <ssh/sshconnectionmanager.h>
#include <device/crossqemuruntime.h>

#include <iostream>
#include <QDebug>

namespace CrossProjectManager {
namespace Internal {

crossDeployHelper::crossDeployHelper(QObject *parent) :
    QObject(parent),m_hasError(false),m_state(Disconnected)
{
    init();
}

crossDeployHelper::~crossDeployHelper()
{
    delete m_connection;
}

void crossDeployHelper::upload(const QString &path)
{

    m_files.clear();
    QDir dir=path;
    foreach (QFileInfo f, dir.entryInfoList(QDir::Files)) {
        m_files<<f.absoluteFilePath();
    }

    if(m_state== ChannelEstablished){
        uploadFiles();
        return;
    }

    if(m_state!=Disconnected){
        earlyDisconnectFromHost();
        return;
    }

    normalMessage(tr("Connecting to device..."));
    m_state = Connecting;
    m_connection->connectToHost();
}

void crossDeployHelper::earlyDisconnectFromHost()
{
    if(!m_hasError){
    if (m_channel)
        disconnect(m_channel.data(), 0, this, 0);
    m_state = Disconnecting;
    m_connection->disconnectFromHost();
    }
    else{

        disconnect(m_connection,SIGNAL(connected()),this,SLOT(handleConnected()));
        disconnect(m_connection,SIGNAL(disconnected()),this,SLOT(handleDisconnected()));
        disconnect(m_connection,SIGNAL(error(QSsh::SshError)),this,SLOT(handleError(QSsh::SshError)));
        init();
        m_state=Disconnected;
        m_hasError=false;
        emit uploadSuccessful(false);
    }
}

void crossDeployHelper::init()
{
    const CrossQemuRuntime rt;
    m_connection =new QSsh::SshConnection(rt.sshParameter(),this);
    connect(m_connection,SIGNAL(connected()),this,SLOT(handleConnected()));
    connect(m_connection,SIGNAL(disconnected()),this,SLOT(handleDisconnected()));
    connect(m_connection,SIGNAL(error(QSsh::SshError)),this,SLOT(handleError(QSsh::SshError)));
}

void crossDeployHelper::handleConnected()
{
    if (m_state != Connecting) {
        std::cerr << "Unexpected state " << m_state << " in function "
            << Q_FUNC_INFO << "." << std::endl;
        earlyDisconnectFromHost();
    } else {
        normalMessage(tr("Connected. Initializing SFTP channel..."));
        m_channel = m_connection->createSftpChannel();
        connect(m_channel.data(), SIGNAL(initialized()), this,
           SLOT(handleChannelInitialized()));
        connect(m_channel.data(), SIGNAL(initializationFailed(QString)), this,
            SLOT(handleChannelInitializationFailure(QString)));
        connect(m_channel.data(), SIGNAL(finished(QSsh::SftpJobId,QString)),
            this, SLOT(handleJobFinished(QSsh::SftpJobId,QString)));
        connect(m_channel.data(), SIGNAL(closed()), this,
            SLOT(handleChannelClosed()));
        m_state = InitializingChannel;
        m_channel->initialize();
    }
}

void crossDeployHelper::handleDisconnected()
{
    if (m_state != Disconnecting) {
        std::cerr << "Unexpected state " << m_state << " in function "
            << Q_FUNC_INFO << std::endl;
    } else {
        normalMessage(tr("Connection closed."));
        m_state=Disconnected;
    }
    jobs.clear();
}

void crossDeployHelper::handleError(QSsh::SshError error)
{
    Q_UNUSED(error);
    errorMessage(tr("Could not connect to host : %1").arg(m_connection->errorString()));
    m_hasError=true;
    earlyDisconnectFromHost();
}

void crossDeployHelper::handleChannelInitialized()
{
    if (m_state != InitializingChannel) {
        std::cerr << "Unexpected state " << m_state << "in function "
            << Q_FUNC_INFO << "." << std::endl;
        earlyDisconnectFromHost();
        return;
    }
    m_state=ChannelEstablished;
    uploadFiles();
}

void crossDeployHelper::handleChannelInitializationFailure(const QString &reason)
{
    errorMessage(tr("Can not establish sftp channel : %`").arg(reason));
    earlyDisconnectFromHost();
}

void crossDeployHelper::handleJobFinished(QSsh::SftpJobId job, const QString &error)
{
    jobs.removeOne(job);
    if(error.isEmpty()){
        normalMessage(tr("Job %1 finished").arg(job));
    }
    else{
        errorMessage(tr("Job %1 can not finish for %2, continue...").arg(job).arg(error));
    }

    if(jobs.isEmpty()){
        emit uploadSuccessful(true);
    }
}

void crossDeployHelper::handleChannelClosed()
{
    if (m_state != ChannelClosing) {
        std::cerr << "Unexpected state " << m_state << " in function "
            << Q_FUNC_INFO << "." << std::endl;
    } else {
        normalMessage(tr("SFTP channel closed. Now disconnecting..."));
    }
    m_state = Disconnecting;
    m_connection->disconnectFromHost();
}

void crossDeployHelper::uploadFiles()
{
    if (m_state != ChannelEstablished) {
        std::cerr << "Unexpected state " << m_state << " in function "
            << Q_FUNC_INFO << "." << std::endl;
    }

    if(!jobs.isEmpty()){
        jobs.clear();
        return;
    }

    //upload files
    foreach (QString name, m_files) {
        QFileInfo info(name);
        QString fileName = info.fileName();
        const QSsh::SftpJobId uploadJob = m_channel->uploadFile(name,tr("/root/%1").arg(fileName),QSsh::SftpOverwriteExisting);
        if (uploadJob == QSsh::SftpInvalidJob) {
            QString error = tr("Error uploading local file : %1").arg(name);
            errorMessage(error);
            earlyDisconnectFromHost();
            emit uploadSuccessful(false);
            return;
        }
        QString message = tr("Uploading %1, job ID is : %2").arg(fileName).arg(uploadJob);
        normalMessage(message);
        jobs.append(uploadJob);
    }

}

void crossDeployHelper::errorMessage(const QString &s)
{
    emit message(s,ProjectExplorer::BuildStep::ErrorOutput);

}

void crossDeployHelper::normalMessage(const QString &s)
{
    emit message(s,ProjectExplorer::BuildStep::MessageOutput);
}




}
}
