#include "crosslinuxtoolchain32bitfactory.h"
#include "crosslinuxtoolchain32bit.h"
#include "crossprojectmanagerconstants.h"
#include "crosssdkinfo.h"
#include <QStringList>
#include <QDir>
namespace CrossProjectManager {
namespace Internal {

QString CrossLinuxToolChain32BitFactory::displayName() const
{
    return tr("Cross Linux ToolChain");
}

QString CrossLinuxToolChain32BitFactory::id() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_32BIT_TYPE);
}

QList<ProjectExplorer::ToolChain *> CrossLinuxToolChain32BitFactory::autoDetect()
{
    QStringList debuggers;
    ProjectExplorer::Abi::Architecture arch = ProjectExplorer::Abi::MipsArchitecture;
    ProjectExplorer::Abi::OS os = ProjectExplorer::Abi::LinuxOS;
    ProjectExplorer::Abi::OSFlavor flavor = ProjectExplorer::Abi::UnknownFlavor;
    ProjectExplorer::Abi::BinaryFormat format = ProjectExplorer::Abi::UnknownFormat;

    QList<ProjectExplorer::ToolChain *> result = autoDetectToolChains(
                      QLatin1String("mipsel-linux-gnu"),
                      QLatin1String("/mipsel-linux-gnu/bin/mipsel-unknown-linux-gnu-gcc"),
                      debuggers,
                      ProjectExplorer::Abi(arch, os, flavor, format,
                                           Constants::CROSS_PROJECT_TARGET_ABI_WORDWIDTH_32));

    return result;
}

QList<ProjectExplorer::ToolChain *> CrossLinuxToolChain32BitFactory::autoDetectToolChains(
        const QString &displayName, const QString &commandPath,
        const QStringList &debuggers, const ProjectExplorer::Abi &requiredAbi)
{
    //TODO add debuger options

    Q_UNUSED(debuggers);
    QList<ProjectExplorer::ToolChain *> result;
    CrossToolChain32Bit *tc = static_cast<CrossToolChain32Bit *>(createToolChain(true));
    QDir sdkDir =CrossSDKInfo::instance().sdkRoot();
    Utils::FileName tcCommand;
    QString sdkPath;

    sdkPath = sdkDir.canonicalPath();
    tcCommand.append(sdkPath + commandPath);

    if (!tcCommand.toFileInfo().exists()) {
        return result;
    }

    tc->setDisplayName(displayName);
    tc->setCompilerCommand(tcCommand);
    tc->setTargetAbi(requiredAbi);
    result.append(tc);
    return result;
}

bool CrossLinuxToolChain32BitFactory::canCreate()
{
    return true;
}

ProjectExplorer::ToolChain *CrossLinuxToolChain32BitFactory::create()
{
    CrossToolChain32Bit *tc = new CrossToolChain32Bit(true);
    return tc;
}

ProjectExplorer::ToolChain *CrossLinuxToolChain32BitFactory::createToolChain(bool autoDetect)
{
    return new CrossToolChain32Bit(autoDetect);
}

bool CrossLinuxToolChain32BitFactory::canRestore(const QVariantMap &data)
{
    return idFromMap(data).startsWith(QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_32BIT_ID));
}

ProjectExplorer::ToolChain *CrossLinuxToolChain32BitFactory::restore(const QVariantMap &data)
{
    CrossToolChain32Bit *tc = new CrossToolChain32Bit(true);
    if (tc->fromMap(data))
        return tc;

    delete tc;
    return 0;
}

}
}
