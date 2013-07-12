#ifndef CROSSDEPLOYCONFIGURATIONFACTORY_H
#define CROSSDEPLOYCONFIGURATIONFACTORY_H

#include <projectexplorer/deployconfiguration.h>
namespace CrossProjectManager {
namespace Internal {
class CrossDeployConfigurationFactory : public ProjectExplorer::DeployConfigurationFactory
{
public:
    CrossDeployConfigurationFactory(QObject *parent = 0);

    QList<Core::Id> availableCreationIds(ProjectExplorer::Target *parent) const;
    QString displayNameForId(const Core::Id id) const;

    bool canCreate(ProjectExplorer::Target *parent, const Core::Id id) const;
    ProjectExplorer::DeployConfiguration *create(ProjectExplorer::Target *parent,
                                                 const Core::Id id);
    bool canRestore(ProjectExplorer::Target *parent, const QVariantMap &map) const;
    ProjectExplorer::DeployConfiguration *restore(ProjectExplorer::Target *parent,
                                                  const QVariantMap &map);
    bool canClone(ProjectExplorer::Target *parent,
                  ProjectExplorer::DeployConfiguration *source) const;
    ProjectExplorer::DeployConfiguration *clone(ProjectExplorer::Target *parent,
                                                ProjectExplorer::DeployConfiguration *source);
};
} // namespace CrossProjectManager
} // namespace Internal

#endif // CROSSDEPLOYCONFIGURATIONFACTORY_H
