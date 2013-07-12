#include "crosslinuxtoolchain64bit.h"
#include "crossprojectmanagerconstants.h"

#include <utils/environment.h>
#include <projectexplorer/toolchainmanager.h>
#include <QApplication>
#include <QDebug>

namespace CrossProjectManager {
namespace Internal {

QString CrossToolChain64Bit::type() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_64BIT_TYPE);
}

QString CrossToolChain64Bit::typeDisplayName() const
{
    return QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_64BIT_DISPLAYNAME);
}

void CrossToolChain64Bit::addToEnvironment(Utils::Environment &env) const
{
    GccToolChain::addToEnvironment(env);
    Utils::FileName compiler = GccToolChain::compilerCommand();
    if (!compiler.isEmpty()) {
        Utils::FileName path = compiler.parentDir().parentDir();
        env.prependOrSetLibrarySearchPath(path.toString() + QLatin1String("/lib"));
    }
}

QString CrossToolChain64Bit::makeCommand() const
{
    return QLatin1String("make");
}

QString CrossToolChain64Bit::defaultMakeTarget() const
{
    return QString();
}

void CrossToolChain64Bit::setCompilerCommand(const Utils::FileName &path)
{
    GccToolChain::setCompilerCommand(path);
}

ProjectExplorer::ToolChain *CrossToolChain64Bit::clone() const
{
    return new CrossToolChain64Bit(*this);
}

QList<Utils::FileName> CrossToolChain64Bit::suggestedMkspecList() const
{
    return QList<Utils::FileName>() << Utils::FileName::fromString(QLatin1String(Constants::MKSPEC_MIPS64EL_N32))
                                    << Utils::FileName::fromString(QLatin1String(Constants::MKSPEC_MIPS64EL_O32))
                                    << Utils::FileName::fromString(QLatin1String(Constants::MKSPEC_MIPS64EL_N64));
}

CrossToolChain64Bit::CrossToolChain64Bit(bool autodetected) :
    GccToolChain(QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_64BIT_ID), autodetected)
{
}



} // namespace Internal
} // namespace CrossProjectManager
