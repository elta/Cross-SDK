#include "crossllvmtoolchain.h"
#include "crossprojectmanagerconstants.h"

#include <utils/environment.h>
#include <utils/synchronousprocess.h>
#include <projectexplorer/abi.h>
#include <projectexplorer/headerpath.h>
#include <projectexplorer/toolchainmanager.h>
#include <qtsupport/qtversionmanager.h>

#include <QApplication>
#include <QDir>

namespace CrossProjectManager {
namespace Internal {

// ==========================================================================
// CrossLlvmToolChain
// ==========================================================================

QString CrossLlvmToolChain::type() const
{
    return QLatin1String(Constants::CROSSLLVM_TOOLCHAIN_TYPE);
}

QString CrossLlvmToolChain::typeDisplayName() const
{
    return CrossLlvmToolChainFactory::tr(Constants::CROSSLLVM_TOOLCHAIN_DISPLAYNAME);
}

//QByteArray CrossLlvmToolChain::predefinedMacros(const QStringList &list) const
//{
//    if (m_predefinedMacros.isEmpty()) {
//        ProjectExplorer::GccToolChain::predefinedMacros(list);
//        m_predefinedMacros += "\n"
//                "#define __CROSSLLVM__\n";
//    }
//    return m_predefinedMacros;
//}

void CrossLlvmToolChain::addToEnvironment(Utils::Environment &env) const
{
    GccToolChain::addToEnvironment(env);
    Utils::FileName compiler = GccToolChain::compilerCommand();
    if (!compiler.isEmpty()) {
        Utils::FileName path = compiler.parentDir().parentDir();
        env.prependOrSetLibrarySearchPath(path.toString() + QLatin1String("/lib"));
    }
}

QString CrossLlvmToolChain::makeCommand() const
{

    return QLatin1String("make");
}

QString CrossLlvmToolChain::defaultMakeTarget() const
{
    return QString();
}

void CrossLlvmToolChain::setCompilerCommand(const Utils::FileName &path)
{
    m_gcceVersion.clear();
    GccToolChain::setCompilerCommand(path);
}

ProjectExplorer::ToolChain *CrossLlvmToolChain::clone() const
{
    return new CrossLlvmToolChain(*this);
}

QList<Utils::FileName> CrossLlvmToolChain::suggestedMkspecList() const
{
    return QList<Utils::FileName>()<< Utils::FileName::fromString(QLatin1String("Mipsel-llvm"));
}

CrossLlvmToolChain::CrossLlvmToolChain(bool autodetected) :
    GccToolChain(QLatin1String(Constants::CROSSLLVM_TOOLCHAIN_ID), autodetected)
{
}

// ==========================================================================
// CrossLlvmToolChainFactory
// ==========================================================================

QString CrossLlvmToolChainFactory::displayName() const
{
    return tr("Cross Llvm ToolChain");
}

QString CrossLlvmToolChainFactory::id() const
{
    return QLatin1String(Constants::CROSSLLVM_TOOLCHAIN_ID);
}

/* FIXME, autoDetect crossllvtoolchains in the env. */
QList<ProjectExplorer::ToolChain *> CrossLlvmToolChainFactory::autoDetect()
{
    QStringList debuggers;
    ProjectExplorer::Abi::Architecture arch = ProjectExplorer::Abi::MipsArchitecture;
    ProjectExplorer::Abi::OS os = ProjectExplorer::Abi::LinuxOS;
    ProjectExplorer::Abi::OSFlavor flavor = ProjectExplorer::Abi::UnknownFlavor;
    ProjectExplorer::Abi::BinaryFormat format = ProjectExplorer::Abi::UnknownFormat;

    QList<ProjectExplorer::ToolChain *> result = autoDetectToolChains(
        QLatin1String("mips-clang"),
        QLatin1String("/llvm/bin/clang"),
        debuggers,
        ProjectExplorer::Abi(arch, os, flavor, format,
                             Constants::CROSS_PROJECT_TARGET_ABI_O32));

    return result;
}

QList<ProjectExplorer::ToolChain *> CrossLlvmToolChainFactory::autoDetectToolChains(
    const QString &displayName, const QString &commandPath,
    const QStringList &debuggers, const ProjectExplorer::Abi &requiredAbi)
{

    //TODO add debuger
    Q_UNUSED(debuggers)
    QList<ProjectExplorer::ToolChain *> result;
    CrossLlvmToolChain *tc = static_cast<CrossLlvmToolChain *>(createToolChain(true));
    QDir sdkDir = QApplication::applicationDirPath();
    Utils::FileName tcCommand;
    QString sdkPath;

    sdkDir.cdUp();
    sdkDir.cdUp();

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

bool CrossLlvmToolChainFactory::canCreate()
{
    return true;
}

ProjectExplorer::ToolChain *CrossLlvmToolChainFactory::create()
{
    CrossLlvmToolChain *tc = new CrossLlvmToolChain(false);
    tc->setDisplayName(tr("CrossLlvm ToolChain"));
    return tc;
}

ProjectExplorer::ToolChain *CrossLlvmToolChainFactory::createToolChain(bool autoDetect)
{
    return new CrossLlvmToolChain(autoDetect);
}

bool CrossLlvmToolChainFactory::canRestore(const QVariantMap &data)
{
    return idFromMap(data).startsWith(QLatin1String(Constants::CROSSLLVM_TOOLCHAIN_ID));
}

ProjectExplorer::ToolChain *CrossLlvmToolChainFactory::restore(const QVariantMap &data)
{
    CrossLlvmToolChain *tc = new CrossLlvmToolChain(false);
    if (tc->fromMap(data))
        return tc;

    delete tc;
    return 0;
}

} // namespace Internal
} // namespace CrossProjectManager
