#include <projectexplorer/kitinformation.h>

#include "crossdevice.h"
#include "crossprojectmanagerconstants.h"
#include "crossqemuruntime.h"

using namespace CrossProjectManager;
using namespace Internal;
using namespace ProjectExplorer;


CrossDevice::CrossDevice()
    : RemoteLinux::LinuxDevice(QLatin1String("Run On Qemu"),
                               Core::Id(Constants::CROSS_DEVICE_ID),
                               ProjectExplorer::IDevice::Emulator,
                               IDevice::AutoDetected,
                               Core::Id(Constants::CROSS_DEVICE_ID))
{
    init();

}

CrossDevice::CrossDevice(const QString &name, Core::Id type,
                         IDevice::MachineType machineType,
                         IDevice::Origin origin, Core::Id id)
    : RemoteLinux::LinuxDevice(name, type, machineType, origin, id)
{
    init();
}

CrossDevice::CrossDevice(const CrossDevice &other)
    : RemoteLinux::LinuxDevice(other)
{
    init();
}



CrossDevice::Ptr CrossDevice::create()
{
    return Ptr(new CrossDevice);
}

CrossDevice::Ptr CrossDevice::create(const QString &name,Core::Id type,
                                     IDevice::MachineType machineType,
                                     IDevice::Origin origin, Core::Id id)
{
    return Ptr(new CrossDevice(name, type, machineType, origin, id));
}

void CrossDevice::fromMap(const QVariantMap &map)
{
    RemoteLinux::LinuxDevice::fromMap(map);
}

QString CrossDevice::displayType() const
{
    return QLatin1String("Cross Device");
}

ProjectExplorer::IDeviceWidget *CrossDevice::createWidget()
{
    //Becareful!
    return 0;
}

QList<Core::Id> CrossDevice::actionIds() const
{
    return QList<Core::Id>();
}

QString CrossDevice::displayNameForActionId(Core::Id actionId) const
{
    Q_UNUSED(actionId)
    return QString();
}

void CrossDevice::executeAction(Core::Id actionId, QWidget *parent) const
{
    Q_UNUSED(actionId)
    Q_UNUSED(parent)
}

ProjectExplorer::IDevice::Ptr CrossDevice::clone() const
{
    return Ptr(new CrossDevice(*this));
}

CrossDevice::ConstPtr CrossDevice::device(const ProjectExplorer::Kit *k)
{
    IDevice::ConstPtr dev = DeviceKitInformation::device(k);
    return dev.dynamicCast<const CrossDevice>();
}

QVariantMap CrossDevice::toMap() const
{
    QVariantMap map = RemoteLinux::LinuxDevice::toMap();
    return map;
}

void CrossDevice::init()
{
    //very important !!!
    //In Qt Creator device is important for deploy and run app by ssh
    //even in debug mode. You can specify gdb port, but can't find any info
    //about server's IP, because device's sshParameters gives it out.
    //also we should use RemoteLinux's classes in this project to deal
    //with ssh stuff, well, I already coeded it by hand, so fuck it.

    //Waring : this can be right? is devices will be change if I changed
    // CrossQemuRuntime's setting????
     const CrossQemuRuntime rt;
     setSshParameters(rt.sshParameter());
}
