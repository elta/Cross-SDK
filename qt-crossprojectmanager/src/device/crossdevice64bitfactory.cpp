#include "crossdevice64bitfactory.h"
#include "crossprojectmanagerconstants.h"
#include "crossdevice64bit.h"

#include <utils/qtcassert.h>

using namespace CrossProjectManager;
using namespace Internal;

CrossDevice64BitFactory::CrossDevice64BitFactory(QObject *parent):
    ProjectExplorer::IDeviceFactory(parent)
{
}

QString CrossDevice64BitFactory::displayNameForId(Core::Id type) const
{
    if (type == Core::Id(Constants::CROSS_DEVICE_64_BIT_TYPE))
        return tr("Cross Device 64 Bit");
    return QString();
}

QList<Core::Id> CrossDevice64BitFactory::availableCreationIds() const
{
    return QList<Core::Id>()<<Core::Id(Constants::CROSS_DEVICE_64_BIT_TYPE);
}

bool CrossDevice64BitFactory::canCreate() const
{
    return false;
}

ProjectExplorer::IDevice::Ptr CrossDevice64BitFactory::create(Core::Id id) const
{
    Q_UNUSED(id)
    return ProjectExplorer::IDevice::Ptr();
}

bool CrossDevice64BitFactory::canRestore(const QVariantMap &map) const
{
    return ProjectExplorer::IDevice::typeFromMap(map) == Core::Id(Constants::CROSS_DEVICE_64_BIT_TYPE);
}

ProjectExplorer::IDevice::Ptr CrossDevice64BitFactory::restore(const QVariantMap &map) const
{
    QTC_ASSERT(canRestore(map), return ProjectExplorer::IDevice::Ptr());
    const CrossDevice64Bit::Ptr device = CrossDevice64Bit::create();
    device->fromMap(map);
    return device;
}

Core::Id CrossDevice64BitFactory::deviceType()
{
    return Core::Id(Constants::CROSS_DEVICE_64_BIT_TYPE);
}
