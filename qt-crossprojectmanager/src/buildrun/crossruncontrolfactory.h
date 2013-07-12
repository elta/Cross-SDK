#ifndef CROSSRUNCONTROLFACTORY_H
#define CROSSRUNCONTROLFACTORY_H

#include <projectexplorer/runconfiguration.h>
#include "crossrunconfiguration.h"

#include <debugger/debuggerrunner.h>
#include <debugger/debuggerplugin.h>
#include <debugger/debuggerstartparameters.h>
#include <debugger/debuggerkitinformation.h>
namespace CrossProjectManager {
namespace Internal {
class CrossRunControlFactory : public ProjectExplorer::IRunControlFactory
{
public:
    CrossRunControlFactory(QObject *parent = 0);
    bool canRun(ProjectExplorer::RunConfiguration *runConfiguration, ProjectExplorer::RunMode mode) const;
    ProjectExplorer::RunControl *create(ProjectExplorer::RunConfiguration *runConfiguration,
                                        ProjectExplorer::RunMode mode, QString *errorMessage);
    QString displayName() const;


    Debugger::DebuggerStartParameters  startParameters(
            const CrossRunConfiguration *runConfig);
};

} // namespace CrossProjectManager
} // namespace Internal
#endif // CROSSRUNCONTROLFACTORY_H
