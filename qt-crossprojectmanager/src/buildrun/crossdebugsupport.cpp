#include "crossdebugsupport.h"
#include "device/crossqemuruntime.h"
#include "crosssdkinfo.h"
using namespace CrossProjectManager;
using namespace Internal;
using namespace ProjectExplorer;

ProjectExplorer::RunControl *CrossDebugSupport::createDebugRunControl(CrossRunConfiguration *runConfig,
                                                                      QString *errorMessage)
{
    Debugger::DebuggerStartParameters params;
    ProjectExplorer::Target *target = runConfig->target();
    ProjectExplorer::Kit *k = target->kit();
    if(!k){
        qWarning("Unexpected empty kit");
        return 0;
    }
    ProjectExplorer::ToolChain *toolchain=ProjectExplorer::ToolChainKitInformation::toolChain(k);
    if(!toolchain){
        qWarning("Unexpected empty toolchain");
        return 0;
    }
    if(toolchain->type()==QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_32BIT_TYPE)){
        params.debuggerCommand=CrossSDKInfo::instance().gnu32Path().path()+QLatin1String("/bin/mipsel-unknown-linux-gnu-gdb");
        params.solibSearchPath<<CrossSDKInfo::instance().gnu32Path().path()+QLatin1String("/mipsel-unknown-linux-gnu/lib");
        params.sysRoot=CrossSDKInfo::instance().gnu32Path().path()+QLatin1String("/mipsel-unknown-linux-gnu/mipsel-sysroot/");
    }
    else if(toolchain->type()==QLatin1String(Constants::CROSSLINUX_TOOLCHAIN_64BIT_TYPE)){
        params.debuggerCommand=CrossSDKInfo::instance().gnu64Path().path()+QLatin1String("/bin/mips64el-unknown-linux-gnu-gdb");
        params.solibSearchPath<<CrossSDKInfo::instance().gnu64Path().path()+QLatin1String("/mips64el-unknown-linux-gnu/lib");
        params.sysRoot=CrossSDKInfo::instance().gnu64Path().path()+QLatin1String("/mips64el-unknown-linux-gnu/mips64el-sysroot/");
    }
    params.startMode = Debugger::AttachToRemoteServer;
    params.sysRoot = ProjectExplorer::SysRootKitInformation::sysRoot(k).toString();
    if (ProjectExplorer::ToolChain *tc = ProjectExplorer::ToolChainKitInformation::toolChain(k))
        params.toolChainAbi = tc->targetAbi();
    //TODO verfiy!
    params.executable = target->activeBuildConfiguration()->buildDirectory()+QLatin1String("/")+target->project()->displayName();
    params.displayName = runConfig->displayName();
    params.remoteSetupNeeded = true;

    if (runConfig->debuggerAspect()->useCppDebugger())
        params.languages |= Debugger::CppLanguage;
    if (const ProjectExplorer::Project *project = runConfig->target()->project()) {
        params.projectSourceDirectory = project->projectDirectory();
        if (const ProjectExplorer::BuildConfiguration *buildConfig = runConfig->target()->activeBuildConfiguration()) {
            params.projectBuildDirectory = buildConfig->buildDirectory();
        }
        params.projectSourceFiles = project->files(ProjectExplorer::Project::ExcludeGeneratedFiles);
    }
    const CrossQemuRuntime rt;
    params.connParams = rt.sshParameter();
    params.remoteChannel=params.connParams.host+ QLatin1Char(':') + QString::number(1234);

    Debugger::DebuggerRunControl * const debuggerRunControl
            = Debugger::DebuggerPlugin::createDebugger(params, runConfig, errorMessage);
    if(debuggerRunControl)
    new CrossDebugSupport(params,runConfig, debuggerRunControl,toolchain);
    return debuggerRunControl;
}

CrossDebugSupport::CrossDebugSupport(Debugger::DebuggerStartParameters params,
                                     CrossRunConfiguration *runConfig,
                                     Debugger::DebuggerRunControl *runControl,
                                     ToolChain *toolchain) :
    QObject(runControl),
    m_engine(runControl->engine()),
    m_params(params),
    m_runConfig(runConfig),
    m_runner(new DeviceApplicationRunner(this)),
    m_device(DeviceKitInformation::device(runConfig->target()->kit())),
    m_state(Inactive),
    m_toolChain(toolchain)
{

    connect(m_engine, SIGNAL(requestRemoteSetup()),this, SLOT(setupGdbServer()));

    connect(m_runner, SIGNAL(reportError(QString)), SLOT(handleError(QString)));
    connect(m_runner, SIGNAL(remoteProcessStarted()),        this, SLOT(handleRemoteProcessStarted()));
    connect(m_runner, SIGNAL(finished(bool)), SLOT(handleRemoteProcessFinished(bool)));
    connect(m_runner, SIGNAL(reportProgress(QString)),       this, SLOT(handleProgressReport(QString)));
    connect(m_runner, SIGNAL(remoteStdout(QByteArray)),      this, SLOT(handleRemoteOutput(QByteArray)));

}

void CrossDebugSupport::setupGdbServer()
{
    QString target=m_runConfig->target()->project()->displayName();
    QString gdbserver;
    QemuType qemu=CrossSDKInfo::instance().getQemuType();
    if(m_toolChain->targetAbi().wordWidth()==Constants::CROSS_PROJECT_TARGET_ABI_WORDWIDTH_32)
        gdbserver=QLatin1String("gdbserver");
    if(m_toolChain->targetAbi().wordWidth()
            ==Constants::CROSS_PROJECT_TARGET_ABI_WORDWIDTH_64){
        if(qemu==_O32RunOn64)
            gdbserver=QLatin1String("gdbserver-o32");
        else if(qemu==_N32RunOn64)
            gdbserver=QLatin1String("gdbserver-n32");
        else if(qemu==_N64RunOn64)
            gdbserver=QLatin1String("gdbserver");
    }

    const QString remoteCommandLine =
            QString::fromLatin1("%1 %2 /root/%3")
            .arg(gdbserver)
            .arg(m_params.remoteChannel)
            .arg(target);
    m_runner->start(m_device, remoteCommandLine.toUtf8());
}


void CrossDebugSupport::handleRemoteProcessStarted()
{
    if (m_engine)
        m_engine->notifyEngineRemoteSetupDone(1234, -1);
}

void CrossDebugSupport::handleRemoteProcessFinished(bool success)
{
    if (m_engine || m_state == Inactive)
        return;

    if (m_state == Debugging) {
        if (!success)
            m_engine->notifyInferiorIll();

    } else {
        const QString errorMsg = tr("The gdbserver closed unexpectedly.");
        m_engine->notifyEngineRemoteSetupFailed(errorMsg);
    }
}

void CrossDebugSupport::handleProgressReport(const QString &progressOutput)
{
    if (m_engine)
        m_engine->showMessage(progressOutput + QLatin1Char('\n'), Debugger::AppStuff);
}

void CrossDebugSupport::handleRemoteOutput(const QByteArray &output)
{
    if (m_engine)
        m_engine->showMessage(QString::fromUtf8(output), Debugger::AppOutput);
}


void CrossDebugSupport::handleError(const QString &error)
{
    if (m_state == Debugging) {
        if (m_engine) {
            m_engine->showMessage(error, Debugger::AppError);
            m_engine->notifyInferiorIll();
        }
    } else if (m_state != Inactive) {
        setFinished();
        if (m_engine)
            m_engine->notifyEngineRemoteSetupFailed(tr("Initial setup failed: %1").arg(error));
    }
}


void CrossDebugSupport::setFinished()
{
    m_state = Inactive;
    m_runner->stop(m_device->processSupport()->killProcessByNameCommandLine(QLatin1String("gdbserver")).toUtf8());
}
