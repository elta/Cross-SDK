#include "crosslinuxtoolchain32bit.h"
#include "crossprojectmanagerconstants.h"

#include <utils/environment.h>
#include <projectexplorer/toolchainmanager.h>
#include <QApplication>
#include <QDebug>
namespace CrossProjectManager {
namespace Internal {

QString CrossToolChain32Bit::type() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_32BIT_TYPE);
}

QString CrossToolChain32Bit::typeDisplayName() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_32BIT_DISPLAYNAME);
}

void CrossToolChain32Bit::addToEnvironment(Utils::Environment &env) const
{
    GccToolChain::addToEnvironment(env);
    Utils::FileName compiler = GccToolChain::compilerCommand();
    if (!compiler.isEmpty()) {
        Utils::FileName path = compiler.parentDir().parentDir();
        env.prependOrSetLibrarySearchPath(path.toString() + QLatin1String("/lib"));
    }
}

QString CrossToolChain32Bit::makeCommand() const
{
    return QLatin1String("make");
}

QString CrossToolChain32Bit::defaultMakeTarget() const
{
    return QString();
}

void CrossToolChain32Bit::setCompilerCommand(const Utils::FileName &path)
{
    GccToolChain::setCompilerCommand(path);
}

ProjectExplorer::ToolChain *CrossToolChain32Bit::clone() const
{
    return new CrossToolChain32Bit(*this);
}

QList<Utils::FileName> CrossToolChain32Bit::suggestedMkspecList() const
{
    return QList<Utils::FileName>() << Utils::FileName::fromString(QLatin1String(Constants::MKSPEC_MIPSEL_O32));
}

CrossToolChain32Bit::CrossToolChain32Bit(bool autodetected) :
    GccToolChain(QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_32BIT_ID), autodetected)
{
}


} // namespace Internal
} // namespace CrossProjectManager
