#include "crosslinuxtoolchain.h"
#include "crossprojectmanagerconstants.h"

#include <utils/environment.h>
#include <utils/synchronousprocess.h>
#include <projectexplorer/abi.h>
#include <projectexplorer/headerpath.h>
#include <projectexplorer/toolchainmanager.h>
#include <qtsupport/qtversionmanager.h>

#include <QApplication>
#include <QDir>

#include <QDebug>
#include <crosssdkinfo.h>
namespace CrossProjectManager {
namespace Internal {


// ==========================================================================
// CrossLinuxToolChain
// ==========================================================================

QString CrossLinuxToolChain::type() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_ID);
}

QString CrossLinuxToolChain::typeDisplayName() const
{
    return CrossLinuxToolChainFactory::tr(Constants::CROSSLINUX_TOOLCHAIN_DISPLAYNAME);
}

//QByteArray CrossLinuxToolChain::predefinedMacros(const QStringList &list) const
//{
//    if (m_predefinedMacros.isEmpty()) {
//        ProjectExplorer::GccToolChain::predefinedMacros(list);
//        m_predefinedMacros += "\n"
//                "#define __CROSS__\n";
//    }
//    return m_predefinedMacros;
//}

void CrossLinuxToolChain::addToEnvironment(Utils::Environment &env) const
{
    GccToolChain::addToEnvironment(env);
    Utils::FileName compiler = GccToolChain::compilerCommand();
    if (!compiler.isEmpty()) {
        Utils::FileName path = compiler.parentDir().parentDir();
        env.prependOrSetLibrarySearchPath(path.toString() + QLatin1String("/lib"));
    }
}

QString CrossLinuxToolChain::makeCommand() const
{
    return QLatin1String("make");
}

QString CrossLinuxToolChain::defaultMakeTarget() const
{
    return QString();
}

void CrossLinuxToolChain::setCompilerCommand(const Utils::FileName &path)
{
    GccToolChain::setCompilerCommand(path);
}

ProjectExplorer::ToolChain *CrossLinuxToolChain::clone() const
{
    return new CrossLinuxToolChain(*this);
}

QList<Utils::FileName> CrossLinuxToolChain::suggestedMkspecList() const
{

    if(targetAbi().wordWidth()==Constants::CROSS_PROJECT_TARGET_ABI_N64)
        return QList<Utils::FileName>() << Utils::FileName::fromString(QLatin1String("mips64el-gnu"));
    else
        return QList<Utils::FileName>() << Utils::FileName::fromString(QLatin1String("mipsel-gnu"));


}

CrossLinuxToolChain::CrossLinuxToolChain(bool autodetected) :
    GccToolChain(QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_ID), autodetected)
{

}

// ==========================================================================
// CrossLinuxToolChainFactory
// ==========================================================================

QString CrossLinuxToolChainFactory::displayName() const
{
    return tr("Cross Linux ToolChain");
}

QString CrossLinuxToolChainFactory::id() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_ID);
}

QList<ProjectExplorer::ToolChain *> CrossLinuxToolChainFactory::autoDetect()
{
    QStringList debuggers;
//    debuggers<<"mipsel-unknown-linux-gnu-gdb"
//            <<"mipsel-unknown-linux-gnu-gdb";
    ProjectExplorer::Abi::Architecture arch = ProjectExplorer::Abi::MipsArchitecture;
    ProjectExplorer::Abi::OS os = ProjectExplorer::Abi::LinuxOS;
    ProjectExplorer::Abi::OSFlavor flavor = ProjectExplorer::Abi::UnknownFlavor;
    ProjectExplorer::Abi::BinaryFormat format = ProjectExplorer::Abi::UnknownFormat;

    // 16 stand for N32
    QList<ProjectExplorer::ToolChain *> result = autoDetectToolChains(
                QLatin1String("mips64el-linux"),
                QLatin1String("/mips64el-linux-gnu/bin/mips64el-unknown-linux-gnu-gcc"),
                debuggers,
                ProjectExplorer::Abi(arch, os, flavor, format,
                                     Constants::CROSS_PROJECT_TARGET_ABI_N64));

    result.append(autoDetectToolChains(
                      QLatin1String("mipsel-linux"),
                      QLatin1String("/mipsel-linux-gnu/bin/mipsel-unknown-linux-gnu-gcc"),
                      debuggers,
                      ProjectExplorer::Abi(arch, os, flavor, format,
                                           Constants::CROSS_PROJECT_TARGET_ABI_O32)));

    return result;
}

QList<ProjectExplorer::ToolChain *> CrossLinuxToolChainFactory::autoDetectToolChains(
        const QString &displayName, const QString &commandPath,
        const QStringList &debuggers, const ProjectExplorer::Abi &requiredAbi)
{
    //TODO add debuger options

    Q_UNUSED(debuggers);
    QList<ProjectExplorer::ToolChain *> result;
    CrossLinuxToolChain *tc = static_cast<CrossLinuxToolChain *>(createToolChain(true));
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

bool CrossLinuxToolChainFactory::canCreate()
{
    return true;
}

ProjectExplorer::ToolChain *CrossLinuxToolChainFactory::create()
{
    CrossLinuxToolChain *tc = new CrossLinuxToolChain(true);
    tc->setDisplayName(tr("Cross Linux ToolChain"));
    return tc;
}

ProjectExplorer::ToolChain *CrossLinuxToolChainFactory::createToolChain(bool autoDetect)
{
    return new CrossLinuxToolChain(autoDetect);
}

bool CrossLinuxToolChainFactory::canRestore(const QVariantMap &data)
{
    return idFromMap(data).startsWith(QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_ID));
}

ProjectExplorer::ToolChain *CrossLinuxToolChainFactory::restore(const QVariantMap &data)
{
    CrossLinuxToolChain *tc = new CrossLinuxToolChain(true);
    if (tc->fromMap(data))
        return tc;

    delete tc;
    return 0;
}

} // namespace Internal
} // namespace CrossProjectManager
