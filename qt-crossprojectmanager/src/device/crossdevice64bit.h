#ifndef CROSSDEVICE64BIT_H
#define CROSSDEVICE64BIT_H


#include <remotelinux/linuxdevice.h>

#include "crossprojectmanagerplugin.h"

namespace ProjectExplorer {
class Kit;
}

namespace CrossProjectManager {
namespace Internal {
class CrossDevice64Bit : public RemoteLinux::LinuxDevice
{
public:

    typedef QSharedPointer<CrossDevice64Bit> Ptr;
    typedef QSharedPointer<const CrossDevice64Bit> ConstPtr;

    static Ptr create();

    void fromMap(const QVariantMap &map);

    QString displayType() const;
    ProjectExplorer::IDeviceWidget *createWidget();
    QList<Core::Id> actionIds() const;
    QString displayNameForActionId(Core::Id actionId) const;
    void executeAction(Core::Id actionId, QWidget *parent = 0) const;
    ProjectExplorer::IDevice::Ptr clone() const;

    static ConstPtr device(const ProjectExplorer::Kit *k);
protected:
    CrossDevice64Bit();
    CrossDevice64Bit(const QString &name, Core::Id type, MachineType machineType,
                             Origin origin, Core::Id id);
    CrossDevice64Bit(const CrossDevice64Bit &other);

    void init();
    QVariantMap toMap() const;
};
} // namespace Internal
} // namespace CrossProjectManager
#endif // CROSSDEVICE_H
