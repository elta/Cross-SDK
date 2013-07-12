#include "crossdeploystepfactory.h"
#include "crossdeploystep.h"
#include "crossprojectmanagerconstants.h"
#include <projectexplorer/buildsteplist.h>
#include <projectexplorer/projectexplorerconstants.h>
using namespace CrossProjectManager;
using namespace Internal;

CrossDeployStepFactory::CrossDeployStepFactory(QObject *parent)
    :ProjectExplorer::IBuildStepFactory(parent)
{
}

QList<Core::Id> CrossDeployStepFactory::availableCreationIds(ProjectExplorer::BuildStepList *parent) const
{
    if (parent->id() != ProjectExplorer::Constants::BUILDSTEPS_DEPLOY)
        return QList<Core::Id>();

    QList<Core::Id> ids;
    if (parent->contains(Core::Id(Constants::CROSS_DEPLOY_STEP_ID)))
        return ids;
    ids <<(Core::Id(Constants::CROSS_DEPLOY_STEP_ID));
    return ids;
}

QString CrossDeployStepFactory::displayNameForId(const Core::Id id) const
{
    if(id==Core::Id(Constants::CROSS_DEPLOY_STEP_ID))
        return QString(QLatin1String("Deploy to QEMU"));
    return QString();
}

bool CrossDeployStepFactory::canCreate(ProjectExplorer::BuildStepList *parent, const Core::Id id) const
{
    return availableCreationIds(parent).contains(id);
}

ProjectExplorer::BuildStep *CrossDeployStepFactory::create(ProjectExplorer::BuildStepList *parent, const Core::Id id)
{
    if (!canCreate(parent, id))
        return 0;
    return new CrossDeployStep(parent);
}

bool CrossDeployStepFactory::canRestore(ProjectExplorer::BuildStepList *parent, const QVariantMap &map) const
{
    return canCreate(parent, ProjectExplorer::idFromMap(map));
}

ProjectExplorer::BuildStep *CrossDeployStepFactory::restore(ProjectExplorer::BuildStepList *parent, const QVariantMap &map)
{
    if(!canRestore(parent, map))
        return 0;
    CrossDeployStep *step = new CrossDeployStep(parent);
    if (!step->fromMap(map)) {
        delete step;
        return 0;
    }
    return step;
}

bool CrossDeployStepFactory::canClone(ProjectExplorer::BuildStepList *parent, ProjectExplorer::BuildStep *product) const
{
    return canCreate(parent, product->id());
}

ProjectExplorer::BuildStep *CrossDeployStepFactory::clone(ProjectExplorer::BuildStepList *parent, ProjectExplorer::BuildStep *product)
{
    if (!canClone(parent, product))
        return 0;
    return new CrossDeployStep(parent,product);

}
