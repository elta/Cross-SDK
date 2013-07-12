#include <projectexplorer/kitinformation.h>

#include "crossdevice64bit.h"
#include "crossprojectmanagerconstants.h"
#include "crossqemuruntime.h"

using namespace CrossProjectManager;
using namespace Internal;
using namespace ProjectExplorer;


CrossDevice64Bit::CrossDevice64Bit()
    :RemoteLinux::LinuxDevice(QLatin1String("Run On 64bit QEMU"),
                              Core::Id(Constants::CROSS_DEVICE_64_BIT_TYPE),
                              ProjectExplorer::IDevice::Emulator,
                              IDevice::AutoDetected,
                              Core::Id(Constants::CROSS_DEVICE_64_BIT_ID))
{
    init();
}

CrossDevice64Bit::CrossDevice64Bit(const QString &name, Core::Id type,
                         IDevice::MachineType machineType,
                         IDevice::Origin origin, Core::Id id)
    : RemoteLinux::LinuxDevice(name, type, machineType, origin, id)
{
    init();
}

CrossDevice64Bit::CrossDevice64Bit(const CrossDevice64Bit &other)
    : RemoteLinux::LinuxDevice(other)
{
    init();
}

void CrossDevice64Bit::init()
{
    //very important !!!
    //In Qt Creator device is important for deploy and run app by ssh
    //even in debug mode. You can specify gdb port, but can't find any info
    //about server's IP, because device's sshParameters gives it out.
    //also we should use RemoteLinux's classes in this project to deal
    //with ssh stuff, well, I already coeded it by hand, so fuck it.
    //update:
    // I must use ProjectExpolorer::DeviceSupport to deal with remote app
    // I coded apprunner myself, but can't work, I don't know why.
    //Waring : this can be right? is devices will be changed if I changed
    // CrossQemuRuntime's setting????
    // --I got the answer : no!
    // so I decide to make two kinds of device CrossDevice 32bit and 64bit
    const CrossQemuRuntime rt;
    QSsh::SshConnectionParameters sshPara=rt.sshParameter();
    sshPara.host=QLatin1String(Constants::QEMU_64BIT_HOST_IP);
    setSshParameters(sshPara);
}



CrossDevice64Bit::Ptr CrossDevice64Bit::create()
{
    return Ptr(new CrossDevice64Bit);
}


void CrossDevice64Bit::fromMap(const QVariantMap &map)
{
    RemoteLinux::LinuxDevice::fromMap(map);
}

QString CrossDevice64Bit::displayType() const
{
    return QLatin1String("64 Bit Cross Device");
}

ProjectExplorer::IDeviceWidget *CrossDevice64Bit::createWidget()
{
    //Becareful!
    return 0;
}

QList<Core::Id> CrossDevice64Bit::actionIds() const
{
    return QList<Core::Id>();
}

QString CrossDevice64Bit::displayNameForActionId(Core::Id actionId) const
{
    Q_UNUSED(actionId)
    return QString();
}

void CrossDevice64Bit::executeAction(Core::Id actionId, QWidget *parent) const
{
    Q_UNUSED(actionId)
    Q_UNUSED(parent)
}

ProjectExplorer::IDevice::Ptr CrossDevice64Bit::clone() const
{
    return Ptr(new CrossDevice64Bit(*this));
}

CrossDevice64Bit::ConstPtr CrossDevice64Bit::device(const ProjectExplorer::Kit *k)
{
    IDevice::ConstPtr dev = DeviceKitInformation::device(k);
    return dev.dynamicCast<const CrossDevice64Bit>();
}



QVariantMap CrossDevice64Bit::toMap() const
{
    QVariantMap map = RemoteLinux::LinuxDevice::toMap();
    return map;
}
