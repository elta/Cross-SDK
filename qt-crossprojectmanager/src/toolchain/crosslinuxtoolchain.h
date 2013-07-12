#ifndef CROSSLINUXTOOLCHAIN_H
#define CROSSLINUXTOOLCHAIN_H

#include <projectexplorer/gcctoolchain.h>

namespace CrossProjectManager {
namespace Internal {

// ==========================================================================
// CrossLinuxToolChain
// ==========================================================================

class CrossLinuxToolChain : public ProjectExplorer::GccToolChain
{
public:
    QString type() const;
    QString typeDisplayName() const;

//    QByteArray predefinedMacros(const QStringList &list) const;
    void addToEnvironment(Utils::Environment &env) const;
    QString makeCommand() const;
    QString defaultMakeTarget() const;

    void setCompilerCommand(const Utils::FileName &);

    ProjectExplorer::ToolChain *clone() const;
    QList<Utils::FileName> suggestedMkspecList() const;

private:
    explicit CrossLinuxToolChain(bool autodetected);
    friend class CrossLinuxToolChainFactory;
};

// ==========================================================================
// CrossLinuxToolChainFactory
// ==========================================================================

class CrossLinuxToolChainFactory : public ProjectExplorer::ToolChainFactory
{
    Q_OBJECT

public:
    QString displayName() const;
    QString id() const;

    QList<ProjectExplorer::ToolChain *> autoDetect();
    QList<ProjectExplorer::ToolChain *> autoDetectToolChains(
        const QString &displayName, const QString &commandPath,
        const QStringList &debuggers, const ProjectExplorer::Abi &requiredAbi);

    bool canCreate();
    ProjectExplorer::ToolChain *create();
    ProjectExplorer::ToolChain *createToolChain(bool autoDetect);

    bool canRestore(const QVariantMap &data);
    ProjectExplorer::ToolChain *restore(const QVariantMap &data);
};

} // namespace Internal
} // namespace CrossProjectManager

#endif // CROSSLINUXTOOLCHAIN_H
