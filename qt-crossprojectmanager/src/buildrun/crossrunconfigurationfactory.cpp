#include "crossrunconfigurationfactory.h"
#include "crossrunconfiguration.h"
#include "crossprojectmanagerconstants.h"

using namespace CrossProjectManager;
using namespace Internal;
CrossRunConfigurationFactory::CrossRunConfigurationFactory(QObject *parent)
    :ProjectExplorer::IRunConfigurationFactory(parent)
{
}
QList<Core::Id> CrossRunConfigurationFactory::availableCreationIds(ProjectExplorer::Target *parent) const
{
    Q_UNUSED(parent);
    QList<Core::Id> ids;
    ids <<(Core::Id(Constants::CROSS_RUN_CONFIGURATION));
    return ids;
}
QString CrossRunConfigurationFactory::displayNameForId(const Core::Id id) const
{
    if(id==Core::Id(Constants::CROSS_RUN_CONFIGURATION))
        return QString(QLatin1String(Constants::CROSS_RUN_CONFIGURATION));
    return QString();
}


bool CrossRunConfigurationFactory::canCreate(ProjectExplorer::Target *parent, const Core::Id id) const
{
    return availableCreationIds(parent).contains(id);
}
ProjectExplorer::RunConfiguration *CrossRunConfigurationFactory::create(ProjectExplorer::Target *parent, const Core::Id id)
{
    if (!canCreate(parent, id))
        return 0;
    return new CrossRunConfiguration(parent,id);
}


bool CrossRunConfigurationFactory::canRestore(ProjectExplorer::Target *parent, const QVariantMap &map) const
{
    return canCreate(parent, ProjectExplorer::idFromMap(map));
}
ProjectExplorer::RunConfiguration *CrossRunConfigurationFactory::restore(ProjectExplorer::Target *parent, const QVariantMap &map)
{
    if (!canRestore(parent, map))
        return 0;
    Core::Id id = ProjectExplorer::idFromMap(map);
    CrossRunConfiguration *rc = new CrossRunConfiguration(parent,id);
    if (rc->fromMap(map))
        return rc;

    delete rc;
    return 0;
}


bool CrossRunConfigurationFactory::canClone(ProjectExplorer::Target *parent, ProjectExplorer::RunConfiguration *product) const
{
    return canCreate(parent, product->id());
}
ProjectExplorer::RunConfiguration *CrossRunConfigurationFactory::clone(ProjectExplorer::Target *parent, ProjectExplorer::RunConfiguration *product)
{
    if (!canClone(parent, product))
        return 0;
    CrossRunConfiguration *old = static_cast<CrossRunConfiguration *>(product);
    return new CrossRunConfiguration(parent,old);
}


