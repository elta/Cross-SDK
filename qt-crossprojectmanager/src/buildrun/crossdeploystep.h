#ifndef CROSSDEPLOYSTEP_H
#define CROSSDEPLOYSTEP_H
#include <QLabel>
#include <QLineEdit>
#include <QGridLayout>
#include <QInputDialog>
#include <projectexplorer/buildstep.h>
#include <QEventLoop>
#include "device/mountmanager.h"
#include "crossdeployconfigurationfactory.h"
#include "crossdeploystepfactory.h"
#include "crossdeployhelper.h"

namespace CrossProjectManager {
namespace Internal {

class CrossDeployConfigWidget : public ProjectExplorer::BuildStepConfigWidget
{
    Q_OBJECT
public:
    CrossDeployConfigWidget(){}
    QString summaryText() const{return QLatin1String("Deploy project files to qemu");}
    QString displayName() const{return QLatin1String("Deploy project files to qemu");}
};

class CrossDeployStep : public ProjectExplorer::BuildStep
{
    Q_OBJECT
    friend class CrossDeployStepFactory;
public:
    CrossDeployStep(ProjectExplorer::BuildStepList *bsl);
    void run(QFutureInterface<bool> &fi);
    bool init();
    ProjectExplorer::BuildStepConfigWidget *createConfigWidget();
signals:
    void needStartQemu();
    void needUploadFiles(const QString &);
public slots:
    void errorMSg(const QString &msg);
    void Msg(const QString &msg);
    bool deploy();

    void handleUploadDone(const bool & result);
protected :
    CrossDeployStep(ProjectExplorer::BuildStepList *bsl, ProjectExplorer::BuildStep *bs);
private:
    void runInit();
    QString m_buildPath;
    QEventLoop *m_eventLoop;
    crossDeployHelper *m_deployHelper;

};

} // namespace CrossProjectManager
} // namespace Internal

#endif // CROSSDEPLOYSTEP_H
