#ifndef CROSSPROJECTMANAGER_H
#define CROSSPROJECTMANAGER_H

#include "crossprojectmanager_global.h"

#include <extensionsystem/iplugin.h>
#include <QAction>

namespace CrossProjectManager {
namespace Internal {

class CrossProjectManagerPlugin : public ExtensionSystem::IPlugin
{
    Q_OBJECT
    
public:
    CrossProjectManagerPlugin();
    ~CrossProjectManagerPlugin();
    
    bool initialize(const QStringList &arguments, QString *errorString);
    void extensionsInitialized();
    ShutdownFlag aboutToShutdown();
    
public  slots:
    void qemuAction();
    void mountAction();
    void unMountAction();
    void updateQemuAction();

    void mountMessage(const QString &s);
    void updatePassword();

private:
    QAction *m_qemuAction;
    QAction *m_mountAction;
    QAction *m_unMountAction;
};

} // namespace Internal
} // namespace CrossProjectManager

#endif // CROSSPROJECTMANAGER_H

