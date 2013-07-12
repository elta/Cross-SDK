#include "crossdevice32bitfactory.h"
#include "crossprojectmanagerconstants.h"
#include "crossdevice32bit.h"

#include <utils/qtcassert.h>

using namespace CrossProjectManager;
using namespace Internal;

/*
 *Note:All constants in this class should be
 *type constants, not ID constants, ID constants
 *should be used in specify device.
 *
 *A factory are stand for one kind of device
 *and this kind of device can more than one.
 */


CrossDevice32BitFactory::CrossDevice32BitFactory(QObject *parent):
    ProjectExplorer::IDeviceFactory(parent)
{
}

QString CrossDevice32BitFactory::displayNameForId(Core::Id type) const
{
    if (type == Core::Id(Constants::CROSS_DEVICE_32_BIT_TYPE))
        return tr("Cross Device 32 Bit");
    return QString();
}

QList<Core::Id> CrossDevice32BitFactory::availableCreationIds() const
{
    return QList<Core::Id>()<<Core::Id(Constants::CROSS_DEVICE_32_BIT_TYPE);
}

bool CrossDevice32BitFactory::canCreate() const
{
    return false;
}

ProjectExplorer::IDevice::Ptr CrossDevice32BitFactory::create(Core::Id id) const
{
    Q_UNUSED(id)
    return ProjectExplorer::IDevice::Ptr();
}

bool CrossDevice32BitFactory::canRestore(const QVariantMap &map) const
{
    return ProjectExplorer::IDevice::typeFromMap(map) == Core::Id(Constants::CROSS_DEVICE_32_BIT_TYPE);
}

ProjectExplorer::IDevice::Ptr CrossDevice32BitFactory::restore(const QVariantMap &map) const
{
    QTC_ASSERT(canRestore(map), return ProjectExplorer::IDevice::Ptr());
    const CrossDevice32Bit::Ptr device = CrossDevice32Bit::create();
    device->fromMap(map);
    return device;
}

Core::Id CrossDevice32BitFactory::deviceType()
{
    return Core::Id(Constants::CROSS_DEVICE_32_BIT_TYPE);
}
