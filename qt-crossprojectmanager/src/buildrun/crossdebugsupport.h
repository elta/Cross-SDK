#ifndef CROSSDEBUGSUPPORT_H
#define CROSSDEBUGSUPPORT_H

#include <QObject>
#include <debugger/debuggerkitinformation.h>
#include <debugger/debuggerstartparameters.h>
#include <debugger/debuggerrunner.h>
#include <debugger/debuggerplugin.h>
#include <debugger/debuggerengine.h>
#include <projectexplorer/runconfiguration.h>
#include <projectexplorer/target.h>
#include <projectexplorer/toolchain.h>
#include <projectexplorer/buildconfiguration.h>
#include "crossrunconfiguration.h"

#include "crossapprunner.h"
#include <projectexplorer/devicesupport/deviceapplicationrunner.h>
namespace CrossProjectManager {
namespace Internal {

class CrossDebugSupport : public QObject
{
    Q_OBJECT
public:

    static ProjectExplorer::RunControl *createDebugRunControl(CrossRunConfiguration *runConfig,
                                                              QString *errorMessage);
    explicit CrossDebugSupport(Debugger::DebuggerStartParameters params,
                               CrossRunConfiguration *runConfig,
                               Debugger::DebuggerRunControl *runControl, ProjectExplorer::ToolChain *toolchain);
public slots:
    void setupGdbServer();

    void handleRemoteProcessStarted();
    void handleRemoteProcessFinished(bool success);
    void handleProgressReport(const QString &progressOutput);
    void handleRemoteOutput(const QByteArray &output);
    void handleError(const QString &error);

private:
    void setFinished();
    enum State {
        Inactive,
        GatheringPorts,
        StartingRemoteProcess,
        Debugging
    };
    Debugger::DebuggerEngine *m_engine;
    Debugger::DebuggerStartParameters m_params;
    CrossRunConfiguration *m_runConfig;
    ProjectExplorer::DeviceApplicationRunner *m_runner;
    ProjectExplorer::IDevice::ConstPtr m_device;
    State m_state;
    ProjectExplorer::ToolChain *m_toolChain;
};

}}

#endif // CROSSDEBUGSUPPORT_H
