#include "crossrtemstoolchain.h"
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
// CrossRTEMSToolChain
// ==========================================================================

QString CrossRTEMSToolChain::type() const
{
    return QLatin1String(Constants::CROSSRTEMS_TOOLCHAIN_TYPE);
}

QString CrossRTEMSToolChain::typeDisplayName() const
{
    return CrossRTEMSToolChainFactory::tr(Constants::CROSSRTEMS_TOOLCHAIN_DISPLAYNAME);
}

QByteArray CrossRTEMSToolChain::predefinedMacros(const QStringList &list) const
{
    if (m_predefinedMacros.isEmpty()) {
        ProjectExplorer::GccToolChain::predefinedMacros(list);
        m_predefinedMacros += "\n"
                "#define __CROSS__\n";
    }
    return m_predefinedMacros;
}

void CrossRTEMSToolChain::addToEnvironment(Utils::Environment &env) const
{
    GccToolChain::addToEnvironment(env);
    Utils::FileName compiler = GccToolChain::compilerCommand();
    if (!compiler.isEmpty()) {
        Utils::FileName path = compiler.parentDir().parentDir();
        env.prependOrSetLibrarySearchPath(path.toString() + "/lib");
    }
}

QString CrossRTEMSToolChain::makeCommand() const
{
#if defined(Q_OS_WIN)
    return QLatin1String("make.exe");
#else
    return QLatin1String("make");
#endif
}

QString CrossRTEMSToolChain::defaultMakeTarget() const
{
    return QLatin1String(Constants::CROSSRTEMS_TOOLCHAIN_DEFAULT_MAKE_TARGET);
}

void CrossRTEMSToolChain::setCompilerCommand(const Utils::FileName &path)
{
    m_gcceVersion.clear();
    GccToolChain::setCompilerCommand(path);
}

ProjectExplorer::ToolChain *CrossRTEMSToolChain::clone() const
{
    return new CrossRTEMSToolChain(*this);
}

CrossRTEMSToolChain::CrossRTEMSToolChain(bool autodetected) :
    GccToolChain(QLatin1String(Constants::CROSSRTEMS_TOOLCHAIN_ID), autodetected)
{ }

// ==========================================================================
// CrossRTEMSToolChainFactory
// ==========================================================================

QString CrossRTEMSToolChainFactory::displayName() const
{
    return tr("Cross RTEMS ToolChain");
}

QString CrossRTEMSToolChainFactory::id() const
{
    return QLatin1String(Constants::CROSSRTEMS_TOOLCHAIN_ID);
}

/* FIXME, autoDetect crosstoolchains in the env. */
QList<ProjectExplorer::ToolChain *> CrossRTEMSToolChainFactory::autoDetect()
{
    QStringList debuggers;
    ProjectExplorer::Abi::Architecture arch = ProjectExplorer::Abi::MipsArchitecture;
    ProjectExplorer::Abi::OS os = ProjectExplorer::Abi::LinuxOS;
    ProjectExplorer::Abi::OSFlavor flavor = ProjectExplorer::Abi::UnknownFlavor;
    ProjectExplorer::Abi::BinaryFormat format = ProjectExplorer::Abi::UnknownFormat;

    QList<ProjectExplorer::ToolChain *> result = autoDetectToolChains(
        QLatin1String("mips64el-rtems"),
        QLatin1String("/rtems64/bin/mips64el-rtems4.11-gcc"),
        debuggers,
        ProjectExplorer::Abi(arch, os, flavor, format,
                             Constants::CROSS_PROJECT_TARGET_ABI_N64));

    result.append(autoDetectToolChains(
        QLatin1String("mipsel-rtems"),
        QLatin1String("/rtems32/bin/mipsel-rtems4.11-gcc"),
        debuggers,
        ProjectExplorer::Abi(arch, os, flavor, format, Constants::CROSS_PROJECT_TARGET_ABI_O32)));

    return result;
}

QList<ProjectExplorer::ToolChain *> CrossRTEMSToolChainFactory::autoDetectToolChains(
    const QString &displayName, const QString &commandPath,
    const QStringList &debuggers, const ProjectExplorer::Abi &requiredAbi)
{
    QList<ProjectExplorer::ToolChain *> result;
    CrossRTEMSToolChain *tc = static_cast<CrossRTEMSToolChain *>(createToolChain(true));
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
bool CrossRTEMSToolChainFactory::canCreate()
{
    return false;
}

ProjectExplorer::ToolChain *CrossRTEMSToolChainFactory::create()
{
    CrossRTEMSToolChain *tc = new CrossRTEMSToolChain(false);
    tc->setDisplayName(tr("Cross RTEMS ToolChain"));
    return tc;
}

ProjectExplorer::ToolChain *CrossRTEMSToolChainFactory::createToolChain(bool autoDetect)
{
    return new CrossRTEMSToolChain(autoDetect);
}

bool CrossRTEMSToolChainFactory::canRestore(const QVariantMap &data)
{
    return idFromMap(data).startsWith(QLatin1String(Constants::CROSSRTEMS_TOOLCHAIN_ID));
}

ProjectExplorer::ToolChain *CrossRTEMSToolChainFactory::restore(const QVariantMap &data)
{
    CrossRTEMSToolChain *tc = new CrossRTEMSToolChain(false);
    if (tc->fromMap(data))
        return tc;

    delete tc;
    return 0;
}

} // namespace Internal
} // namespace Qt4ProjectManager
