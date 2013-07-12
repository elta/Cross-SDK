#include "crosslinuxtoolchain64bitfactory.h"
#include "crosslinuxtoolchain64bit.h"
#include "crossprojectmanagerconstants.h"
#include "crosssdkinfo.h"
#include <QStringList>
#include <QDir>
namespace CrossProjectManager {
namespace Internal {

QString CrossLinuxToolChain64BitFactory::displayName() const
{
    return tr("Cross Linux ToolChain");
}

QString CrossLinuxToolChain64BitFactory::id() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_64BIT_TYPE);
}

QList<ProjectExplorer::ToolChain *> CrossLinuxToolChain64BitFactory::autoDetect()
{
    QStringList debuggers;
    ProjectExplorer::Abi::Architecture arch = ProjectExplorer::Abi::MipsArchitecture;
    ProjectExplorer::Abi::OS os = ProjectExplorer::Abi::LinuxOS;
    ProjectExplorer::Abi::OSFlavor flavor = ProjectExplorer::Abi::UnknownFlavor;
    ProjectExplorer::Abi::BinaryFormat format = ProjectExplorer::Abi::UnknownFormat;

    QList<ProjectExplorer::ToolChain *> result = autoDetectToolChains(
                      QLatin1String("mips64el-linux-gnu"),
                      QLatin1String("/mips64el-linux-gnu/bin/mips64el-unknown-linux-gnu-gcc"),
                      debuggers,
                      ProjectExplorer::Abi(arch, os, flavor, format,
                                           Constants::CROSS_PROJECT_TARGET_ABI_WORDWIDTH_64));

    return result;
}

QList<ProjectExplorer::ToolChain *> CrossLinuxToolChain64BitFactory::autoDetectToolChains(
        const QString &displayName, const QString &commandPath,
        const QStringList &debuggers, const ProjectExplorer::Abi &requiredAbi)
{
    //TODO add debuger options

    Q_UNUSED(debuggers);
    QList<ProjectExplorer::ToolChain *> result;
    CrossToolChain64Bit *tc = static_cast<CrossToolChain64Bit *>(createToolChain(true));
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

bool CrossLinuxToolChain64BitFactory::canCreate()
{
    return true;
}

ProjectExplorer::ToolChain *CrossLinuxToolChain64BitFactory::create()
{
    CrossToolChain64Bit *tc = new CrossToolChain64Bit(true);
    return tc;
}

ProjectExplorer::ToolChain *CrossLinuxToolChain64BitFactory::createToolChain(bool autoDetect)
{
    return new CrossToolChain64Bit(autoDetect);
}

bool CrossLinuxToolChain64BitFactory::canRestore(const QVariantMap &data)
{
    return idFromMap(data).startsWith(QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_64BIT_ID));
}

ProjectExplorer::ToolChain *CrossLinuxToolChain64BitFactory::restore(const QVariantMap &data)
{
    CrossToolChain64Bit *tc = new CrossToolChain64Bit(true);
    if (tc->fromMap(data))
        return tc;

    delete tc;
    return 0;
}

}
}
