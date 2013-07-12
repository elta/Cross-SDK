#include "crossdeploystep.h"
#include "crossprojectmanagerconstants.h"
#include "crosssdkinfo.h"
#include "device/mountmanager.h"
#include "projectexplorer/project.h"
#include "projectexplorer/target.h"
#include <projectexplorer/projectexplorer.h>
#include <qt4projectmanager/qt4buildconfiguration.h>
#include <projectexplorer/buildstepspage.h>
#include <projectexplorer/buildmanager.h>
#include <projectexplorer/buildsteplist.h>

#include "device/crossqemumanager.h"

using namespace CrossProjectManager;
using namespace Internal;

CrossDeployStep::CrossDeployStep(ProjectExplorer::BuildStepList *bsl, BuildStep *bs)
    :ProjectExplorer::BuildStep(bsl,bs)
{
    runInit();
}


CrossDeployStep::CrossDeployStep(ProjectExplorer::BuildStepList *bsl)
    :ProjectExplorer::BuildStep(bsl,Core::Id(Constants::CROSS_DEPLOY_STEP_ID))
{
    runInit();
}
void CrossDeployStep::runInit()
{
    m_eventLoop=0;
    m_deployHelper= new crossDeployHelper(this);

    setDisplayName(tr("Deploy now"));

    connect(&MountManager::instance(),SIGNAL(errorString(QString)),this,SLOT(errorMSg(QString)));
    connect(&MountManager::instance(),SIGNAL(messageString(QString)),this,SLOT(Msg(QString)));
    connect(this,SIGNAL(needStartQemu()),&CrossQemuManager::instance(),SLOT(startRuntime()));
    connect(this,SIGNAL(needUploadFiles(QString)),m_deployHelper,SLOT(upload(QString)));
    connect(m_deployHelper,SIGNAL(uploadSuccessful(bool)),this,SLOT(handleUploadDone(bool)));
    connect(m_deployHelper,SIGNAL(message(QString,ProjectExplorer::BuildStep::OutputFormat)),
            this,SIGNAL(addOutput(QString,ProjectExplorer::BuildStep::OutputFormat)));
}

//Interface
ProjectExplorer::BuildStepConfigWidget *CrossDeployStep::createConfigWidget()
{
    return new CrossDeployConfigWidget ;
}

bool CrossDeployStep::init()
{
    const Qt4ProjectManager::Qt4BuildConfiguration *bc = qobject_cast<Qt4ProjectManager::Qt4BuildConfiguration *>(target()->activeBuildConfiguration());
    if (!bc) {
        emit addOutput(QLatin1String("Cannot create  package: current build configuration is not Qt 4."),ErrorMessageOutput);
        return false;
    }

    m_buildPath=bc->buildDirectory();
    if(m_buildPath.isEmpty())
        return false;
    return true;
}
void CrossDeployStep::run(QFutureInterface<bool> &fi)
{
    fi.reportResult(deploy());
}

//slots
void CrossDeployStep::errorMSg(const QString &msg)
{
    emit addOutput(msg,ErrorMessageOutput);
}

void CrossDeployStep::Msg(const QString &msg)
{
    emit addOutput(msg,MessageOutput);
}

//deploy step
bool CrossDeployStep::deploy()
{
    if(!CrossQemuManager::instance().isRuning()){
        //must used signal to start qemu !!
        emit needStartQemu();
    }
    while(!CrossQemuManager::instance().isComplateStarted()){
        emit addOutput(QString(QLatin1String("Qemu has not been start up complately, waiting ...")),MessageOutput);
        if(!CrossQemuManager::instance().isRuning())
            return false;
    }
    emit addOutput(QLatin1String("Qemu started"),MessageOutput);
    m_eventLoop=new QEventLoop;
    emit needUploadFiles(target()->activeBuildConfiguration()->buildDirectory());
    bool returnValue=m_eventLoop->exec();
    if(returnValue){
        emit addOutput(QLatin1String("Files sucessful uploaded"),MessageOutput);
    }
    else{
        emit addOutput(QLatin1String("Upload files failed. see log above find the possiable reasons"),ErrorOutput);
    }
    delete m_eventLoop;
    m_eventLoop=0;
    return returnValue;
}

void CrossDeployStep::handleUploadDone(const bool &result)
{
    if(!m_eventLoop)
        return;
    if(result)
        m_eventLoop->exit(1);
    else
        m_eventLoop->exit(0);
}


