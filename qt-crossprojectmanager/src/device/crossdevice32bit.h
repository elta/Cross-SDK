#ifndef CROSSDEVICE32BIT_H
#define CROSSDEVICE32BIT_H


#include <remotelinux/linuxdevice.h>

#include "crossprojectmanagerplugin.h"

namespace ProjectExplorer {
class Kit;
}

namespace CrossProjectManager {
namespace Internal {
class CrossDevice32Bit : public RemoteLinux::LinuxDevice
{
public:

    typedef QSharedPointer<CrossDevice32Bit> Ptr;
    typedef QSharedPointer<const CrossDevice32Bit> ConstPtr;

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
    CrossDevice32Bit();
    CrossDevice32Bit(const QString &name, Core::Id type, MachineType machineType,
                             Origin origin, Core::Id id);
    CrossDevice32Bit(const CrossDevice32Bit &other);

    void init();
    QVariantMap toMap() const;
};
} // namespace Internal
} // namespace CrossProjectManager
#endif // CROSSDEVICE_H
