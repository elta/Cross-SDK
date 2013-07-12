#include "configpage.h"
#include "ui_configpage.h"

#include <projectexplorer/toolchain.h>
#include <projectexplorer/toolchainmanager.h>
#include <projectexplorer/kitinformation.h>
#include <projectexplorer/kit.h>
#include <projectexplorer/abi.h>
#include "crossprojectmanagerconstants.h"

#include "crosssdkinfo.h"

#include <QDebug>

using namespace CrossProjectManager;
using namespace Internal;

ConfigPage::ConfigPage(QWidget *parent) :
    QWizardPage(parent),
    ui(new Ui::ConfigPage)
{
    ui->setupUi(this);
    setTitle(QLatin1String("Configuration"));

    //add and setdefult toolchain

    foreach (ProjectExplorer::ToolChain *current, ProjectExplorer::ToolChainManager::instance()->toolChains()){
        if(current->id().startsWith(QLatin1String("CrossProjectManager"))){
            ui->comboBox_compiler->addItem(current->displayName());
        }
    }
    QString defultDisplayName;
    QList<ProjectExplorer::Kit *> kits=ProjectExplorer::KitManager::instance()->kits();
    foreach(ProjectExplorer::Kit *kit,kits)
    {
        if(kit->id()==Constants::CROSS_KIT_ID)
        {
            ProjectExplorer::ToolChain *toolchain=ProjectExplorer::ToolChainKitInformation::toolChain(kit);
            if(toolchain)
                defultDisplayName=toolchain->displayName();
            else{
                //current kit has not any complier
                defultDisplayName.clear();
            }
        }
    }
    int index=ui->comboBox_compiler->findText(defultDisplayName);
    if(index==-1){
        if(ui->comboBox_compiler->count()>=1)
            index=0;
        else
            qWarning("No compiler founded!");
    }
    ui->comboBox_compiler->setCurrentIndex(index);

    connect(ui->comboBox_compiler,SIGNAL(currentIndexChanged(int)),this,SLOT(updateComplier()));
    connect(ui->comboBox_target,SIGNAL(currentIndexChanged(int)),this,SLOT(updateTarget()));

    //should be updated
    updateComplier();
}

ConfigPage::~ConfigPage()
{
    delete ui;
}

void ConfigPage::updateComplier()
{
    foreach (ProjectExplorer::ToolChain *current, ProjectExplorer::ToolChainManager::instance()->toolChains()){
        if(current->id().startsWith(QLatin1String("CrossProjectManager"))){
            if(ui->comboBox_compiler->currentText()==current->displayName()){
                disconnect(ui->comboBox_target,SIGNAL(currentIndexChanged(int)),this,SLOT(updateTarget()));

                if(current->targetAbi().wordWidth()==Constants::CROSS_PROJECT_TARGET_ABI_WORDWIDTH_32){
                    ui->comboBox_target->clear();
                    ui->comboBox_target->addItem(QLatin1String("O32"),QVariant(int(_O32RunOn32)));
                }
                if(current->targetAbi().wordWidth()==Constants::CROSS_PROJECT_TARGET_ABI_WORDWIDTH_64){
                    ui->comboBox_target->clear();
                    ui->comboBox_target->addItem(QLatin1String("O32"),QVariant(int(_O32RunOn64)));
                    ui->comboBox_target->addItem(QLatin1String("N32"),QVariant(int(_N32RunOn64)));
                    ui->comboBox_target->addItem(QLatin1String("N64"),QVariant(int(_N64RunOn64)));
                }
                CrossSDKInfo::instance().setComplier(current);
                connect(ui->comboBox_target,SIGNAL(currentIndexChanged(int)),this,SLOT(updateTarget()));
            }
        }
    }
    updateTarget();
}

void ConfigPage::updateTarget()
{

    int index=ui->comboBox_target->currentIndex();
    QVariant data=ui->comboBox_target->itemData(index);
    bool ok;
    int type=data.toInt(&ok);
    if(!ok){
        qWarning("Undefined type");
        return;
    }
    CrossSDKInfo::instance().setQemuType(QemuType(type));
}
