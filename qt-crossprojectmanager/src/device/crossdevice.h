#ifndef CROSSDEVICE_H
#define CROSSDEVICE_H


#include <remotelinux/linuxdevice.h>

#include "crossprojectmanagerplugin.h"

namespace ProjectExplorer {
class Kit;
}

namespace CrossProjectManager {
namespace Internal {
class CrossDevice : public RemoteLinux::LinuxDevice
{
public:

    typedef QSharedPointer<CrossDevice> Ptr;
    typedef QSharedPointer<const CrossDevice> ConstPtr;

    static Ptr create();
    static Ptr create(const QString &name, Core::Id type, MachineType machineType,
                      Origin origin = ManuallyAdded, Core::Id id = Core::Id());

    void fromMap(const QVariantMap &map);

    QString displayType() const;
    ProjectExplorer::IDeviceWidget *createWidget();
    QList<Core::Id> actionIds() const;
    QString displayNameForActionId(Core::Id actionId) const;
    void executeAction(Core::Id actionId, QWidget *parent = 0) const;
    ProjectExplorer::IDevice::Ptr clone() const;

    static ConstPtr device(const ProjectExplorer::Kit *k);
protected:
    CrossDevice();
    CrossDevice(const QString &name, Core::Id type, MachineType machineType,
                             Origin origin, Core::Id id);
    CrossDevice(const CrossDevice &other);

    QVariantMap toMap() const;

    void init();
};
} // namespace Internal
} // namespace CrossProjectManager
#endif // CROSSDEVICE_H
