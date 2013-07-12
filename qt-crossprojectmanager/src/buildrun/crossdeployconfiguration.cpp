#include "crossdeployconfiguration.h"
#include "crossprojectmanagerconstants.h"
#include <QDebug>
using namespace CrossProjectManager;
using namespace Internal;

CrossDeployConfiguration::CrossDeployConfiguration(ProjectExplorer::Target *parent, Core::Id id)
    :ProjectExplorer::DeployConfiguration(parent,id)
{
    init();
}

CrossDeployConfiguration::CrossDeployConfiguration(ProjectExplorer::Target *parent, CrossDeployConfiguration *source)
    :ProjectExplorer::DeployConfiguration(parent,source)
{
    init();
}

//ProjectExplorer::DeployConfigurationWidget *CrossDeployConfiguration::configurationWidget() const
//{
//    return 0;
//}

void CrossDeployConfiguration::init()
{
    setDefaultDisplayName(defaultDisplayName());
}

QString CrossDeployConfiguration::defaultDisplayName()
{
    return tr("Deploy it to qemu image ...");
}
