#ifndef CROSSDEVICE32BITFACTORY_H
#define CROSSDEVICE32BITFACTORY_H

#include <projectexplorer/devicesupport/idevicefactory.h>
namespace CrossProjectManager {
namespace Internal {
class CrossDevice32BitFactory : public ProjectExplorer::IDeviceFactory
{
    Q_OBJECT
public:
    explicit CrossDevice32BitFactory(QObject  *parent = 0);

    QString displayNameForId(Core::Id type) const;
    QList<Core::Id> availableCreationIds() const;

    bool canCreate() const;
    ProjectExplorer::IDevice::Ptr create(Core::Id id) const;
    bool canRestore(const QVariantMap &map) const;
    ProjectExplorer::IDevice::Ptr restore(const QVariantMap &map) const;

    static Core::Id deviceType();
};

} // namespace Internal
} // namespace CrossProjectManager
#endif // CROSSDEVICEFACTORY_H
