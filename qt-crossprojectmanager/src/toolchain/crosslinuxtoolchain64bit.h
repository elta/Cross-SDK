#ifndef CROSSLINUXTOOLCHAIN64BIT_H
#define CROSSLINUXTOOLCHAIN64BIT_H

#include <projectexplorer/gcctoolchain.h>

namespace CrossProjectManager {
namespace Internal {

// ==========================================================================
// CrossLinuxToolChain
// ==========================================================================

class CrossToolChain64Bit : public ProjectExplorer::GccToolChain
{
public:
    QString type() const;
    QString typeDisplayName() const;

    void addToEnvironment(Utils::Environment &env) const;
    QString makeCommand() const;
    QString defaultMakeTarget() const;

    void setCompilerCommand(const Utils::FileName &);

    ProjectExplorer::ToolChain *clone() const;
    QList<Utils::FileName> suggestedMkspecList() const;

private:
    explicit CrossToolChain64Bit(bool autodetected);
    friend class CrossLinuxToolChain64BitFactory;
};

// ==========================================================================
// CrossLinuxToolChainFactory
// ==========================================================================



} // namespace Internal
} // namespace CrossProjectManager

#endif // CROSSLINUXTOOLCHAIN_H
