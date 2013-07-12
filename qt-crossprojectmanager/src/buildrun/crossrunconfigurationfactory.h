#ifndef CROSSRUNCONFIGURATIONFACTORY_H
#define CROSSRUNCONFIGURATIONFACTORY_H

#include <projectexplorer/runconfiguration.h>
namespace CrossProjectManager {
namespace Internal {
class CrossRunConfigurationFactory : public ProjectExplorer::IRunConfigurationFactory
{
public:
    CrossRunConfigurationFactory(QObject *parent = 0);

    QList<Core::Id> availableCreationIds(ProjectExplorer::Target *parent) const ;
    QString displayNameForId(const Core::Id id) const ;

    bool canCreate(ProjectExplorer::Target *parent, const Core::Id id) const;
    ProjectExplorer::RunConfiguration *create(ProjectExplorer::Target *parent, const Core::Id id) ;
    bool canRestore(ProjectExplorer::Target *parent, const QVariantMap &map)const ;
    ProjectExplorer::RunConfiguration *restore(ProjectExplorer::Target *parent, const QVariantMap &map) ;
    bool canClone(ProjectExplorer::Target *parent, ProjectExplorer::RunConfiguration *product)const ;
    ProjectExplorer::RunConfiguration *clone(ProjectExplorer::Target *parent, ProjectExplorer::RunConfiguration *product) ;
};

} // namespace CrossProjectManager
} // namespace Internal
#endif // CROSSRUNCONFIGURATIONFACTORY_H
