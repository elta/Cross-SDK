#include "crossdeployconfigurationfactory.h"
#include "crossprojectmanagerconstants.h"
#include "crossdeployconfiguration.h"
#include "crossdeploystep.h"

#include <projectexplorer/buildsteplist.h>
#include <projectexplorer/target.h>

using namespace CrossProjectManager;
using namespace Internal;
CrossDeployConfigurationFactory::CrossDeployConfigurationFactory(QObject *parent)
    :ProjectExplorer::DeployConfigurationFactory(parent)
{
}

QList<Core::Id> CrossDeployConfigurationFactory::availableCreationIds(ProjectExplorer::Target *parent) const
{
    Q_UNUSED(parent)
    QList<Core::Id> ids;
    ids <<(Core::Id(Constants::CROSS_DEPLOY_CONFIGURATION));
    return ids;
}

QString CrossDeployConfigurationFactory::displayNameForId(const Core::Id id) const
{

    if(id==Core::Id(Constants::CROSS_DEPLOY_CONFIGURATION))
        return QString(QLatin1String("Deploy on qemu"));
    return QString();
}

bool CrossDeployConfigurationFactory::canCreate(ProjectExplorer::Target *parent, const Core::Id id) const
{
    return availableCreationIds(parent).contains(id);;
}

ProjectExplorer::DeployConfiguration *CrossDeployConfigurationFactory::create(ProjectExplorer::Target *parent, const Core::Id id)
{
    if (!canCreate(parent, id))
        return 0;
    CrossDeployConfiguration *dc= new CrossDeployConfiguration(parent,id);
    if(!dc)
        return 0;
    dc->stepList()->insertStep(0,new CrossDeployStep(dc->stepList()));
    return dc;
}

bool CrossDeployConfigurationFactory::canRestore(ProjectExplorer::Target *parent, const QVariantMap &map) const
{
    return canCreate(parent, ProjectExplorer::idFromMap(map));
}

ProjectExplorer::DeployConfiguration *CrossDeployConfigurationFactory::restore(ProjectExplorer::Target *parent, const QVariantMap &map)
{
    if (!canRestore(parent, map))
        return 0;
    CrossDeployConfiguration *dc = new CrossDeployConfiguration(parent, ProjectExplorer::idFromMap(map));
    if (dc->fromMap(map))
        return dc;
    delete dc;
    return 0;
}

bool CrossDeployConfigurationFactory::canClone(ProjectExplorer::Target *parent, ProjectExplorer::DeployConfiguration *source) const
{
    return canCreate(parent, source->id());
}

ProjectExplorer::DeployConfiguration *CrossDeployConfigurationFactory::clone(ProjectExplorer::Target *parent, ProjectExplorer::DeployConfiguration *source)
{
    if (!canClone(parent, source))
        return 0;
    CrossDeployConfiguration *old = static_cast<CrossDeployConfiguration *>(source);
    return new CrossDeployConfiguration(parent,old);
}


