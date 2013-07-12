#ifndef CROSSRUNCONFIGURATION_H
#define CROSSRUNCONFIGURATION_H
#include <projectexplorer/runconfiguration.h>
namespace CrossProjectManager {
namespace Internal {

class CrossRunConfigurationFactory;

class CrossRunConfiguration : public ProjectExplorer::RunConfiguration
{
    Q_OBJECT
    friend class CrossRunConfigurationFactory;
public:
    CrossRunConfiguration(ProjectExplorer::Target *parent, Core::Id id);
    CrossRunConfiguration(ProjectExplorer::Target *parent, CrossRunConfiguration *source);
    QWidget *createConfigurationWidget();
    Utils::OutputFormatter *createOutputFormatter() const;

protected:
    QString defaultDisplayName();
private:
    void init();
};

} // namespace Internal
} // namespace CrossProjectManager

#endif // CROSSRUNCONFIGURATION_H
