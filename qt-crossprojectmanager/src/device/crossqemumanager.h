#ifndef CROSSQEMUMANAGER_H
#define CROSSQEMUMANAGER_H

#include <QObject>
#include <QMap>
#include <QProcess>
#include <QIcon>
#include "crossqemuruntime.h"
#include <ssh/sshconnection.h>

namespace ProjectExplorer {
class BuildConfiguration;
class Project;
class RunConfiguration;
class Target;
}
namespace CrossProjectManager {
namespace Internal {

/*!
  \class CrossProjectManager::CrossQemuManager
  \brief Provides an interface for manage qemu.
*/
class CrossQemuManager : public QObject
{
    Q_OBJECT
public:
    static CrossQemuManager& instance(QObject *parent = 0);
public slots:
    bool startRuntime();
    bool stopRuntime();
    bool isRuning();
    void userClose();
    bool isComplateStarted();
signals:
    void errorString(const QString &);
    void messageString(const QString &);
    void stateChanged(const QProcess::ProcessState&);
private:
    CrossQemuManager(QObject *parent);
    ~CrossQemuManager();

    QProcess *m_qemuProcess;
    static CrossQemuManager *m_instance;
    QString m_hostIP;

};

} // namespace Internal
} // namespace CrossProjectManager
#endif // CROSSQEMUMANAGER_H
