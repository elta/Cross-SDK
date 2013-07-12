#include "crosselftoolchain.h"
#include "qt4projectmanagerconstants.h"

#include <utils/environment.h>
#include <utils/synchronousprocess.h>
#include <projectexplorer/abi.h>
#include <projectexplorer/headerpath.h>
#include <projectexplorer/toolchainmanager.h>
#include <qtsupport/qtversionmanager.h>

#include <QApplication>
#include <QDir>

namespace Qt4ProjectManager {
namespace Internal {

static QString gcceVersion(const Utils::FileName &command)
{
    if (command.isEmpty())
        return QString();

    QProcess gxx;
    QStringList arguments;
    arguments << QLatin1String("-dumpversion");
    Utils::Environment env = Utils::Environment::systemEnvironment();
    env.set(QLatin1String("LC_ALL"), QLatin1String("C"));   //override current locale settings
    gxx.setEnvironment(env.toStringList());
    gxx.setReadChannelMode(QProcess::MergedChannels);
    gxx.start(command.toString(), arguments);
    if (!gxx.waitForStarted()) {
        qWarning("Cannot start '%s': %s", qPrintable(command.toUserOutput()), qPrintable(gxx.errorString()));
        return QString();
    }
    gxx.closeWriteChannel();
    if (!gxx.waitForFinished())      {
        Utils::SynchronousProcess::stopProcess(gxx);
        qWarning("Timeout running '%s'.", qPrintable(command.toUserOutput()));
        return QString();
    }
    if (gxx.exitStatus() != QProcess::NormalExit) {
        qWarning("'%s' crashed.", qPrintable(command.toUserOutput()));
        return QString();
    }

    QString version = QString::fromLocal8Bit(gxx.readLine().trimmed());
    if (version.contains(QRegExp(QLatin1String("^\\d+\\.\\d+\\.\\d+.*$"))))
        return version;

    return QString();
}


// ==========================================================================
// CrossELFToolChain
// ==========================================================================

QString CrossELFToolChain::type() const
{
    return QLatin1String(Constants::CROSSELF_TOOLCHAIN_TYPE);
}

QString CrossELFToolChain::typeDisplayName() const
{
    return CrossELFToolChainFactory::tr(Constants::CROSSELF_TOOLCHAIN_DISPLAYNAME);
}

QByteArray CrossELFToolChain::predefinedMacros(const QStringList &list) const
{
    if (m_predefinedMacros.isEmpty()) {
        ProjectExplorer::GccToolChain::predefinedMacros(list);
        m_predefinedMacros += "\n"
                "#define __CROSS__\n";
    }
    return m_predefinedMacros;
}

void CrossELFToolChain::addToEnvironment(Utils::Environment &env) const
{
    GccToolChain::addToEnvironment(env);
    Utils::FileName compiler = GccToolChain::compilerCommand();
    if (!compiler.isEmpty()) {
        Utils::FileName path = compiler.parentDir().parentDir();
        env.prependOrSetLibrarySearchPath(path.toString() + "/lib");
    }
}

QString CrossELFToolChain::makeCommand() const
{
#if defined(Q_OS_WIN)
    return QLatin1String("make.exe");
#else
    return QLatin1String("make");
#endif
}

QString CrossELFToolChain::defaultMakeTarget() const
{
    return QLatin1String(Constants::CROSSELF_TOOLCHAIN_DEFAULT_MAKE_TARGET);
}

void CrossELFToolChain::setCompilerCommand(const Utils::FileName &path)
{
    m_gcceVersion.clear();
    GccToolChain::setCompilerCommand(path);
}

ProjectExplorer::ToolChain *CrossELFToolChain::clone() const
{
    return new CrossELFToolChain(*this);
}

CrossELFToolChain::CrossELFToolChain(bool autodetected) :
    GccToolChain(QLatin1String(Constants::CROSSELF_TOOLCHAIN_ID), autodetected)
{ }

// ==========================================================================
// CrossELFToolChainFactory
// ==========================================================================

QString CrossELFToolChainFactory::displayName() const
{
    return tr("Cross ELF ToolChain");
}

QString CrossELFToolChainFactory::id() const
{
    return QLatin1String(Constants::CROSSELF_TOOLCHAIN_ID);
}

/* FIXME, autoDetect crossELFtoolchains in the env. */
QList<ProjectExplorer::ToolChain *> CrossELFToolChainFactory::autoDetect()
{
    QStringList debuggers;
    ProjectExplorer::Abi::Architecture arch = ProjectExplorer::Abi::MipsArchitecture;
    ProjectExplorer::Abi::OS os = ProjectExplorer::Abi::LinuxOS;
    ProjectExplorer::Abi::OSFlavor flavor = ProjectExplorer::Abi::UnknownFlavor;
    ProjectExplorer::Abi::BinaryFormat format = ProjectExplorer::Abi::UnknownFormat;

    QList<ProjectExplorer::ToolChain *> result = autoDetectToolChains(
        QLatin1String("mipsel-elf"),
        QLatin1String("/elf32/bin/mipsel-unknown-elf-gcc"),
        debuggers,
        ProjectExplorer::Abi(arch, os, flavor, format,
                             Constants::CROSS_PROJECT_TARGET_ABI_O32));

    result.append(autoDetectToolChains(
        QLatin1String("mips64el-elf"),
        QLatin1String("/elf64/bin/mips64el-unknown-elf-gcc"),
        debuggers,
        ProjectExplorer::Abi(arch, os, flavor, format,
                             Constants::CROSS_PROJECT_TARGET_ABI_N64)));

    return result;
}

QList<ProjectExplorer::ToolChain *> CrossELFToolChainFactory::autoDetectToolChains(
    const QString &displayName, const QString &commandPath,
    const QStringList &debuggers, const ProjectExplorer::Abi &requiredAbi)
{
    QList<ProjectExplorer::ToolChain *> result;
    CrossELFToolChain *tc = static_cast<CrossELFToolChain *>(createToolChain(true));
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

/* Manual Add ToolChain Was Forbidened. */
bool CrossELFToolChainFactory::canCreate()
{
    return false;
}

ProjectExplorer::ToolChain *CrossELFToolChainFactory::create()
{
    CrossELFToolChain *tc = new CrossELFToolChain(false);
    tc->setDisplayName(tr("Cross ELF ToolChain"));
    return tc;
}

ProjectExplorer::ToolChain *CrossELFToolChainFactory::createToolChain(bool autoDetect)
{
    return new CrossELFToolChain(autoDetect);
}

bool CrossELFToolChainFactory::canRestore(const QVariantMap &data)
{
    return idFromMap(data).startsWith(QLatin1String(Constants::CROSSELF_TOOLCHAIN_ID));
}

ProjectExplorer::ToolChain *CrossELFToolChainFactory::restore(const QVariantMap &data)
{
    CrossELFToolChain *tc = new CrossELFToolChain(false);
    if (tc->fromMap(data))
        return tc;

    delete tc;
    return 0;
}

} // namespace Internal
} // namespace Qt4ProjectManager
