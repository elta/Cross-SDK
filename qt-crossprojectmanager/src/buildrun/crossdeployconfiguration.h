#ifndef CROSSDEPLOYCONFIGURATION_H
#define CROSSDEPLOYCONFIGURATION_H

#include <projectexplorer/deployconfiguration.h>

namespace CrossProjectManager {
namespace Internal {
class CrossDeployConfiguration : public ProjectExplorer::DeployConfiguration
{
    Q_OBJECT
    friend class CrossDeployConfigurationFactory;
public:
    CrossDeployConfiguration(ProjectExplorer::Target *parent, Core::Id id);

//    ProjectExplorer::DeployConfigurationWidget *configurationWidget() const;
protected:
    CrossDeployConfiguration(ProjectExplorer::Target *parent, CrossDeployConfiguration *source);

private:

    void init();
    QString defaultDisplayName();
};

} // namespace CrossProjectManager
} // namespace Internal
#endif // CROSSDEPLOYCONFIGURATION_H
