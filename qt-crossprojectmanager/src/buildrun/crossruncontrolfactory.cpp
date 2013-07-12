#include "crossruncontrolfactory.h"

#include "crossruncontrol.h"
#include "crossdeployconfiguration.h"

#include <projectexplorer/target.h>
#include <projectexplorer/project.h>
#include <projectexplorer/buildconfiguration.h>
#include <QDebug>

#include <crosssdkinfo.h>

#include <device/crossqemuruntime.h>
#include "crossdebugsupport.h"
using namespace CrossProjectManager;
using namespace Internal;
using namespace ProjectExplorer;
CrossRunControlFactory::CrossRunControlFactory(QObject *parent)
    : IRunControlFactory(parent)
{
}

bool CrossRunControlFactory::canRun(RunConfiguration *runConfiguration, RunMode mode) const
{
    if (mode != NormalRunMode && mode != DebugRunMode)
        return false;
    const CrossRunConfiguration * const crossRunConfig
            = qobject_cast<CrossRunConfiguration *>(runConfiguration);

    if (!crossRunConfig || !crossRunConfig->isEnabled())
        return false;
    return true;
}

RunControl *CrossRunControlFactory::create(RunConfiguration *runConfiguration, RunMode mode, QString *errorMessage)
{
    //TODO debug mode and so on

    if(!canRun(runConfiguration, mode))
        return 0;

    CrossRunConfiguration *rc = qobject_cast<CrossRunConfiguration *>(runConfiguration);
    if(!rc)
        return 0;

    CrossDeployConfiguration *activeDeployConf = qobject_cast<CrossDeployConfiguration *>(
                rc->target()->activeDeployConfiguration());
    if (!activeDeployConf) {
        if (errorMessage)
            *errorMessage = tr("No active deploy configuration");
        return 0;
    }

    if (mode == ProjectExplorer::NormalRunMode) {
        CrossRunControl *runControl = new CrossRunControl(rc);
        return runControl;
    }

    //debug mode
    ProjectExplorer::RunControl * const runControl =
            CrossDebugSupport::createDebugRunControl(rc,errorMessage);
    if (!runControl)
        return 0;
    return runControl;
}

QString CrossRunControlFactory::displayName() const
{
    return tr("Run on qemu");
}
