#ifndef CROSSDEVICE64BITFACTORY_H
#define CROSSDEVICE64BITFACTORY_Hs

#include <projectexplorer/devicesupport/idevicefactory.h>
namespace CrossProjectManager {
namespace Internal {
class CrossDevice64BitFactory : public ProjectExplorer::IDeviceFactory
{
    Q_OBJECT
public:
    explicit CrossDevice64BitFactory(QObject  *parent = 0);

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
