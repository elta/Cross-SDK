#include <projectexplorer/kitinformation.h>

#include "crossdevice32bit.h"
#include "crossprojectmanagerconstants.h"
#include "crossqemuruntime.h"

using namespace CrossProjectManager;
using namespace Internal;
using namespace ProjectExplorer;


CrossDevice32Bit::CrossDevice32Bit()
    :RemoteLinux::LinuxDevice(QLatin1String("Run On 32bit QEMU"),
                              Core::Id(Constants::CROSS_DEVICE_32_BIT_TYPE),
                              ProjectExplorer::IDevice::Emulator,
                              IDevice::AutoDetected,
                              Core::Id(Constants::CROSS_DEVICE_32_BIT_ID))
{
    init();
}

CrossDevice32Bit::CrossDevice32Bit(const QString &name, Core::Id type,
                         IDevice::MachineType machineType,
                         IDevice::Origin origin, Core::Id id)
    : RemoteLinux::LinuxDevice(name, type, machineType, origin, id)
{
    init();
}

CrossDevice32Bit::CrossDevice32Bit(const CrossDevice32Bit &other)
    : RemoteLinux::LinuxDevice(other)
{
    init();
}

void CrossDevice32Bit::init()
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
    sshPara.host=QLatin1String(Constants::QEMU_32BIT_HOST_IP);
    setSshParameters(sshPara);
}



CrossDevice32Bit::Ptr CrossDevice32Bit::create()
{
    return Ptr(new CrossDevice32Bit);
}


void CrossDevice32Bit::fromMap(const QVariantMap &map)
{
    RemoteLinux::LinuxDevice::fromMap(map);
}

QString CrossDevice32Bit::displayType() const
{
    return QLatin1String("32 Bit Cross Device");
}

ProjectExplorer::IDeviceWidget *CrossDevice32Bit::createWidget()
{
    //Becareful!
    return 0;
}

QList<Core::Id> CrossDevice32Bit::actionIds() const
{
    return QList<Core::Id>();
}

QString CrossDevice32Bit::displayNameForActionId(Core::Id actionId) const
{
    Q_UNUSED(actionId)
    return QString();
}

void CrossDevice32Bit::executeAction(Core::Id actionId, QWidget *parent) const
{
    Q_UNUSED(actionId)
    Q_UNUSED(parent)
}

ProjectExplorer::IDevice::Ptr CrossDevice32Bit::clone() const
{
    return Ptr(new CrossDevice32Bit(*this));
}

CrossDevice32Bit::ConstPtr CrossDevice32Bit::device(const ProjectExplorer::Kit *k)
{
    IDevice::ConstPtr dev = DeviceKitInformation::device(k);
    return dev.dynamicCast<const CrossDevice32Bit>();
}



QVariantMap CrossDevice32Bit::toMap() const
{
    QVariantMap map = RemoteLinux::LinuxDevice::toMap();
    return map;
}
