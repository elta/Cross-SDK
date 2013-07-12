#include "crosssdkinfo.h"

#include <QApplication>
#include <projectexplorer/abi.h>
#include <debugger/debuggerkitinformation.h>
#include <qt4projectmanager/qmakekitinformation.h>
#include <projectexplorer/devicesupport/devicemanager.h>
#include <QDebug>

using namespace CrossProjectManager;
using namespace Internal;

CrossSDKInfo *CrossSDKInfo::m_instance=0;
CrossSDKInfo &CrossSDKInfo::instance(QObject *parent)
{
    if(m_instance==0)
        m_instance=new CrossSDKInfo(parent);
    return *m_instance;
}

bool CrossSDKInfo::isAviliable(const QMap<QString, QString> &config,QString &reason)
{
    if(!QDir(config[QLatin1String("sdkroot")]).exists()){
        reason=QLatin1String("Sdk path does not exists ,please check your configuration");
    }
    if(!QDir(config[QLatin1String(QLatin1String("gnu32"))]).exists()){
        reason=QLatin1String("Mipsel-gnu-linux path does not exists ,please check your configuration");
    }
    if(!QDir(config[QLatin1String("gnu64")]).exists()){
        reason=QLatin1String("Mips64el-gnu-linux path does not exists ,please check your configuration");
    }
    if(!QDir(config[QLatin1String("llvm")]).exists()){
        reason=QLatin1String("llvm path does not exists ,please check your configuration");
    }
    if(!QDir(config[QLatin1String("qemu")]).exists()){
        reason=QLatin1String("Qemu path does not exists ,please check your configuration");
    }
    if(!QDir(config[QLatin1String("gnulinux")]).exists()){
        reason=QLatin1String("Gnulinux path does not exists ,please check your configuration");
    }
    qDebug()<<reason;
    return true;
}

bool CrossSDKInfo::isAviliable(QString &reason)
{
    return isAviliable(m_config,reason);
}


void CrossSDKInfo::setConfig(QMap<QString, QString> config)
{
    m_config=config;
}

QMap<QString, QString> CrossSDKInfo::getConfig()
{
    return m_config;
}

CrossSDKInfo::CrossSDKInfo(QObject *parent)
    :QObject(parent)
{
    readSetting();
}

CrossSDKInfo::~CrossSDKInfo()
{
    writeSetting();
    m_instance=0;
}

void CrossSDKInfo::readSetting()
{
    QSettings settings(QLatin1String("crossprojectmanger"),QLatin1String("creator plugin"));
    //first time there is nothing about cross plugin
    //TODO first time detect need update!!
    if(settings.value(QLatin1String("sdkroot")).toString().isEmpty()){
        QDir sdkDir = QApplication::applicationDirPath();
        sdkDir.cdUp();
        sdkDir.cd(QLatin1String("lib"));
        QDir sdkPath(sdkDir.absolutePath());
        if(!sdkPath.exists()){
            return ;
        };
        //defult configuration
        updateSDK(sdkPath.path());
        m_qemuType=_O32RunOn32;

        return ;
    }


    m_config[QLatin1String("sdkroot")] =settings.value(QLatin1String("sdkroot")).toString();
    m_config[QLatin1String("gnu32")]   =settings.value(QLatin1String("gnu32")).toString();
    m_config[QLatin1String("gnu64")]   =settings.value(QLatin1String("gnu64")).toString();
    m_config[QLatin1String("llvm")]    =settings.value(QLatin1String("llvm")).toString();
    m_config[QLatin1String("qemu")]    =settings.value(QLatin1String("qemu")).toString();
    m_config[QLatin1String("gnulinux")]=settings.value(QLatin1String("gnulinux")).toString();

    m_qemuType=(QemuType)(settings.value(QLatin1String("qemutype")).toInt());
}

void CrossSDKInfo::writeSetting()
{
    QSettings settings(QLatin1String("crossprojectmanger"),QLatin1String("creator plugin"));
    settings.setValue(QLatin1String("sdkroot"),m_config[QLatin1String("sdkroot")]);
    settings.setValue(QLatin1String("gnu32"),m_config[QLatin1String("gnu32")]);
    settings.setValue(QLatin1String("gnu64"),m_config[QLatin1String("gnu64")]);
    settings.setValue(QLatin1String("llvm"),m_config[QLatin1String("llvm")]);
    settings.setValue(QLatin1String("qemu"),m_config[QLatin1String("qemu")]);
    settings.setValue(QLatin1String("gnulinux"),m_config[QLatin1String("gnulinux")]);
    settings.setValue(QLatin1String("qemutype"),(int)m_qemuType);
}

void CrossSDKInfo::updateSDK(const QString &sdkRootLocation)
{
    m_config[QLatin1String("sdkroot")] =sdkRootLocation;
    m_config[QLatin1String("gnu32")]   =sdkRootLocation+QLatin1String("/mipsel-linux-gnu");
    m_config[QLatin1String("gnu64")]   =sdkRootLocation+QLatin1String("/mips64el-linux-gnu");
    m_config[QLatin1String("llvm")]    =sdkRootLocation+QLatin1String("/llvm");
    m_config[QLatin1String("qemu")]    =sdkRootLocation+QLatin1String("/qemu");
    m_config[QLatin1String("gnulinux")]=sdkRootLocation+QLatin1String("/gnu-linux");
}

ProjectExplorer::Kit *CrossSDKInfo::getCrossKit()
{
    ProjectExplorer::KitManager *kitmanager=ProjectExplorer::KitManager::instance();
    ProjectExplorer::Kit *targetKit=kitmanager->find(Constants::CROSS_KIT_ID);
    if(!targetKit){
        targetKit=new ProjectExplorer::Kit(Constants::CROSS_KIT_ID);
        targetKit->setDisplayName(QLatin1String("Cross Kit"));
    }
    kitmanager->registerKit(targetKit);
    kitmanager->setDefaultKit(targetKit);
    return targetKit;
}


void CrossSDKInfo::setQemuType(QemuType qt)
{
    m_qemuType=qt;
    //Warning is this right??
    ProjectExplorer::DeviceManager *dm = ProjectExplorer::DeviceManager::instance();
    ProjectExplorer::Kit *targetKit=getCrossKit();
    ProjectExplorer::IDevice::ConstPtr crossDevice;

    if(m_qemuType==_O32RunOn32){
        crossDevice=dm->find(Constants::CROSS_DEVICE_32_BIT_ID);
        ProjectExplorer::DeviceTypeKitInformation::setDeviceTypeId(targetKit,Core::Id(Constants::CROSS_DEVICE_32_BIT_TYPE));
    }
    else{
        crossDevice=dm->find(Constants::CROSS_DEVICE_64_BIT_ID);
        ProjectExplorer::DeviceTypeKitInformation::setDeviceTypeId(targetKit,Core::Id(Constants::CROSS_DEVICE_64_BIT_TYPE));
    }
    if(!crossDevice){
        qWarning("QEMU device not found. ");
        return;
    }

    ProjectExplorer::DeviceKitInformation::setDevice(targetKit,crossDevice);

    //very important !
    ProjectExplorer::ToolChain *toolChain=getComplier();
    QString mkspec;
    QString sysroot;
    if(toolChain->type()==QString::fromAscii(Constants::CROSSLINUX_TOOLCHAIN_32BIT_TYPE)){
        mkspec=QLatin1String(Constants::MKSPEC_MIPSEL_O32);
        sysroot=CrossSDKInfo::instance().gnu32Path().path()+QLatin1String("/mipsel-unknown-linux-gnu/mipsel-sysroot/");
    }
    else if(toolChain->type()==QString::fromAscii(Constants::CROSSLINUX_TOOLCHAIN_64BIT_TYPE)){
        if(m_qemuType==_O32RunOn64)
            mkspec=QLatin1String(Constants::MKSPEC_MIPS64EL_O32);
        else if(m_qemuType==_N32RunOn64)
            mkspec=QLatin1String(Constants::MKSPEC_MIPS64EL_N32);
        else if(m_qemuType==_N64RunOn64)
            mkspec=QLatin1String(Constants::MKSPEC_MIPS64EL_N64);
        sysroot=CrossSDKInfo::instance().gnu64Path().path()+QLatin1String("/mips64el-unknown-linux-gnu/mips64el-sysroot/");
    }
    Qt4ProjectManager::QmakeKitInformation::setMkspec(targetKit,Utils::FileName::fromString(mkspec));
    ProjectExplorer::SysRootKitInformation::setSysRoot(targetKit,Utils::FileName::fromString(sysroot));
}

QemuType CrossSDKInfo::getQemuType() const
{
    return m_qemuType;
}

void CrossSDKInfo::setComplier(ProjectExplorer::ToolChain *toolchain)
{
    if(!toolchain){
        qWarning("Tool chain can't be 0");
        return;
    }
    ProjectExplorer::Kit *targetKit=getCrossKit();
    //important for debug!!
    Debugger::DebuggerKitInformation::DebuggerItem dbitem;
    dbitem.engineType=Debugger::GdbEngineType;

    if(toolchain->targetAbi().wordWidth()==64)
        dbitem.binary=Utils::FileName::fromString(CrossSDKInfo::instance().gnu64Path().path()+QLatin1String("/bin/mips64el-unknown-linux-gnu-gdb"));
    else{
        dbitem.binary=Utils::FileName::fromString(CrossSDKInfo::instance().gnu32Path().path()+QLatin1String("/bin/mipsel-unknown-linux-gnu-gdb"));
    }
    Debugger::DebuggerKitInformation::setDebuggerItem(targetKit,dbitem);
    ProjectExplorer::ToolChainKitInformation::setToolChain(targetKit, toolchain);


}

ProjectExplorer::ToolChain *CrossSDKInfo::getComplier()
{
    ProjectExplorer::Kit *targetKit=getCrossKit();
    ProjectExplorer::ToolChain *toolchain=ProjectExplorer::ToolChainKitInformation::toolChain(targetKit);
    return toolchain;
}
