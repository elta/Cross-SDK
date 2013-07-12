#ifndef CROSSLINUXTOOLCHAIN64BITFACTORY_H
#define CROSSLINUXTOOLCHAIN64BITFACTORY_H

#include <projectexplorer/gcctoolchain.h>
namespace CrossProjectManager {
namespace Internal {
class CrossLinuxToolChain64BitFactory : public ProjectExplorer::ToolChainFactory
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

}
}
#endif // CROSSLINUXTOOLCHAIN64BITFACTORY_H
