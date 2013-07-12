#ifndef APPRUNNER_H
#define APPRUNNER_H

#include <ssh/sshconnection.h>
#include <ssh/sshremoteprocess.h>
#include <ssh/sshremoteprocessrunner.h>
#include <projectexplorer/project.h>

#include "buildrun/crossrunconfiguration.h"
namespace CrossProjectManager {
namespace Internal {

class CrossAppRunner : public QObject
{
    Q_OBJECT
public:
    explicit CrossAppRunner(QObject *parent=0);

public slots:
    void runTarget(const QString &command, const QString & argu=QString());
    void killTarget();
    bool isRunning();
signals:
    void processStarted();
    void processExited(int exitStatus);
    void errorMessage(const QString &);
    void normaleMessage(const QString &);
private slots:
    void handleConnectionError();
    void handleProcessStarted();
    void handleProcessClosed(int exitStatus);
    void handleStdout();
    void handleStderr();

private:
    QSsh::SshConnectionParameters m_sshParameter;
    QSsh::SshRemoteProcessRunner *m_runner;
    QSsh::SshRemoteProcessRunner *m_commandKiller;
    QString m_command;
};

}}
#endif // APPRUNNER_H
