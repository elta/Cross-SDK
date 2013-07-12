#include "crossdevicefactory.h"
#include "crossprojectmanagerconstants.h"
#include "crossdevice.h"

#include <utils/qtcassert.h>

using namespace CrossProjectManager;
using namespace Internal;

CrossDeviceFactory::CrossDeviceFactory(QObject *parent):
    ProjectExplorer::IDeviceFactory(parent)
{
}

QString CrossDeviceFactory::displayNameForId(Core::Id type) const
{
    if (type == Core::Id(Constants::CROSS_DEVICE_ID))
        return tr("Cross Device");
    return QString();
}

QList<Core::Id> CrossDeviceFactory::availableCreationIds() const
{
    return QList<Core::Id>() << Core::Id(Constants::CROSS_DEVICE_ID);
}

bool CrossDeviceFactory::canCreate() const
{
    return true;
}

ProjectExplorer::IDevice::Ptr CrossDeviceFactory::create(Core::Id id) const
{
    Q_UNUSED(id)
    return CrossDevice::create();
}

bool CrossDeviceFactory::canRestore(const QVariantMap &map) const
{
    return ProjectExplorer::IDevice::typeFromMap(map) == Core::Id(Constants::CROSS_DEVICE_ID);
}

ProjectExplorer::IDevice::Ptr CrossDeviceFactory::restore(const QVariantMap &map) const
{
    QTC_ASSERT(canRestore(map), return CrossDevice::Ptr());
    const CrossDevice::Ptr device = CrossDevice::create();
    device->fromMap(map);
    return device;
}

Core::Id CrossDeviceFactory::deviceType()
{
    return Core::Id(Constants::CROSS_DEVICE_ID);
}
