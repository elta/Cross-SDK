#ifndef CROSSDEPLOYHELPER_H
#define CROSSDEPLOYHELPER_H

#include <QObject>
#include <ssh/sshconnection.h>
#include <ssh/sftpchannel.h>
#include <projectexplorer/buildstep.h>
#include <QDir>
namespace CrossProjectManager {
namespace Internal {

class crossDeployHelper : public QObject
{
    Q_OBJECT
public:
    explicit crossDeployHelper(QObject *parent = 0);
    ~crossDeployHelper();

signals:
    void message(const QString &,ProjectExplorer::BuildStep::OutputFormat);
    void uploadSuccessful(const bool & );

public slots:
    void upload(const QString &path);

private slots:
    void errorMessage(const QString &s);
    void normalMessage(const QString &s);

    void handleConnected();
    void handleDisconnected();
    void handleError(QSsh::SshError error);
    void handleChannelInitialized();
    void handleChannelInitializationFailure(const QString &reason);
    void handleJobFinished(QSsh::SftpJobId job, const QString &error);
    void handleChannelClosed();

    void uploadFiles();

private:
    void earlyDisconnectFromHost();
    void init();
    enum State {
        Connecting, Disconnecting ,Disconnected
        ,InitializingChannel, ChannelEstablished , ChannelClosing
    };
    bool m_hasError;
    State m_state;
    QStringList m_files;
    QSsh::SshConnection *m_connection;
    QSsh::SftpChannel::Ptr m_channel;
    QList<QSsh::SftpJobId> jobs;
    
};

}
}
#endif // CROSSDEPLOYHELPER_H
