#ifndef CROSSLINUXTOOLCHAIN32BIT_H
#define CROSSLINUXTOOLCHAIN32BIT_H

#include <projectexplorer/gcctoolchain.h>

namespace CrossProjectManager {
namespace Internal {

// ==========================================================================
// CrossLinuxToolChain
// ==========================================================================

class CrossToolChain32Bit : public ProjectExplorer::GccToolChain
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
    explicit CrossToolChain32Bit(bool autodetected);
    friend class CrossLinuxToolChain32BitFactory;
};



} // namespace Internal
} // namespace CrossProjectManager

#endif // CROSSLINUXTOOLCHAIN_H
