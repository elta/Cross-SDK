#include "crossruncontrol.h"
#include "device/crossqemumanager.h"

#include <projectexplorer/target.h>
#include <projectexplorer/project.h>
using namespace CrossProjectManager;
using namespace Internal;
using namespace ProjectExplorer;

CrossRunControl::CrossRunControl(CrossRunConfiguration *rc)
    : RunControl(rc, NormalRunMode),
      m_device(DeviceKitInformation::device(rc->target()->kit())),
      running(false)
{
    m_AppRunner=new DeviceApplicationRunner(this);
    connect(m_AppRunner,SIGNAL(remoteStdout(QByteArray)),this,SLOT(addStdOutMessage(QByteArray)));
    connect(m_AppRunner,SIGNAL(remoteStderr(QByteArray)),this,SLOT(addStdErrorMessage(QByteArray)));
    connect(m_AppRunner,SIGNAL(remoteProcessStarted()),this,SLOT(handleProcessStarted()));
    connect(m_AppRunner,SIGNAL(reportError(QString)),this,SLOT(handleReportError(QString)));
    connect(m_AppRunner,SIGNAL(reportProgress(QString)),this,SLOT(handleReportProgress(QString)));
    connect(m_AppRunner,SIGNAL(finished(bool)),this,SLOT(handleFinished(bool)));
}

void CrossRunControl::start()
{
    Target *target=runConfiguration()->target();
    const QString remoteCommandLine = QString::fromLatin1("/root/%1").arg(target->project()->displayName());
    m_AppRunner->start(m_device, remoteCommandLine.toUtf8());
}

RunControl::StopResult CrossRunControl::stop()
{
    Target *target=runConfiguration()->target();
    m_AppRunner->stop(m_device->processSupport()->killProcessByNameCommandLine(target->project()->displayName()).toUtf8());
    return AsynchronousStop;
}

bool CrossRunControl::isRunning() const
{
    return running;
}

QIcon CrossRunControl::icon() const
{
    return QIcon(QLatin1String(ProjectExplorer::Constants::ICON_RUN_SMALL));
}

void CrossRunControl::addStdOutMessage(const QByteArray &str)
{
    appendMessage(QLatin1String(str), Utils::StdOutFormat);
}

void CrossRunControl::addStdErrorMessage(const QByteArray &str)
{
    appendMessage(QLatin1String(str), Utils::StdErrFormat);
}

void CrossRunControl::handleProcessStarted()
{
    running=true;
    appendMessage(QString::fromAscii("App started.\n"), Utils::NormalMessageFormat);
}

void CrossRunControl::handleFinished(const bool &result)
{
    running=false;
    if(result){
        appendMessage(QString::fromAscii("App finished.\n"), Utils::NormalMessageFormat);
    }
    else{
        appendMessage(QString::fromAscii("App finish with error\n"), Utils::ErrorMessageFormat);
    }
}

void CrossRunControl::handleReportError(const QString &str)
{
    QString s=str;
    s.append(QLatin1String("\n"));
    appendMessage(s, Utils::ErrorMessageFormat);
}

void CrossRunControl::handleReportProgress(const QString &str)
{
    QString s=str;
    s.append(QLatin1String("\n"));
    appendMessage(s, Utils::NormalMessageFormat);

}


