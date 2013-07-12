#include "crossprojectmanagerplugin.h"
#include "crossprojectmanagerconstants.h"
#include "toolchain/crosslinuxtoolchain32bitfactory.h"
#include "toolchain/crosslinuxtoolchain64bitfactory.h"
#include "device/crossdevice32bit.h"
#include "device/crossdevice64bit.h"
#include "device/crossdevice32bitfactory.h"
#include "device/crossdevice64bitfactory.h"
#include "device/crossqemuruntime.h"
#include "device/crossqemumanager.h"
#include "device/mountmanager.h"
#include "buildrun/crossrunconfigurationfactory.h"
#include "buildrun/crossruncontrolfactory.h"
#include "buildrun/crossdeploystepfactory.h"
#include "buildrun/crossdeployconfigurationfactory.h"
#include "crosssettingspage.h"
#include "wizard/crosslinuxprojectwizard.h"

#include <coreplugin/icore.h>
#include <coreplugin/icontext.h>
#include <coreplugin/actionmanager/actionmanager.h>
#include <coreplugin/actionmanager/command.h>
#include <coreplugin/actionmanager/actioncontainer.h>
#include <coreplugin/coreconstants.h>
#include <coreplugin/modemanager.h>

#include <projectexplorer/kitmanager.h>
#include <projectexplorer/kit.h>
#include <projectexplorer/kitinformation.h>
#include <projectexplorer/toolchainmanager.h>
#include <projectexplorer/devicesupport/idevice.h>
#include <projectexplorer/devicesupport/devicemanager.h>

#include <QMessageBox>
#include <QMainWindow>
#include <QMenu>
#include <QInputDialog>
#include <QtPlugin>
#include <QDebug>
using namespace CrossProjectManager::Internal;



CrossProjectManagerPlugin::CrossProjectManagerPlugin()
{
    // Create your members

    //must be first
    CrossSDKInfo::instance(this);
    MountManager::instance(this);
    CrossQemuManager::instance(this);


}

CrossProjectManagerPlugin::~CrossProjectManagerPlugin()
{
    // Unregister objects from the plugin manager's object pool
    // Delete members
}

bool CrossProjectManagerPlugin::initialize(const QStringList &arguments, QString *errorString)
{
    // Register objects in the plugin manager's object pool
    // Load settings
    // Add actions to menus
    // Connect to other plugins' signals
    // In the initialize method, a plugin can be sure that the plugins it
    // depends on have initialized their members.
    
    Q_UNUSED(arguments)
    Q_UNUSED(errorString)






    //qemu actions
    QIcon qemuRunIcon = QIcon(QLatin1String(Constants::QEMU_RUN_ICON));
    m_qemuAction = new QAction(qemuRunIcon,tr("Run Qemu"), this);
    m_qemuAction->setToolTip(QLatin1String("Start Qemu"));
    m_qemuAction->setEnabled(true);
    Core::Command *cmd = Core::ActionManager::registerAction(m_qemuAction, Constants::QEMU_ACTION_ID,
                                                             Core::Context(Core::Constants::C_GLOBAL));
    cmd->setDefaultKeySequence(QKeySequence(tr("Ctrl+Alt+Meta+Q")));
    Core::ModeManager::addAction(m_qemuAction,0);

    m_mountAction = new QAction(tr("Mount..."),this);
    m_mountAction->setToolTip(QLatin1String("Mount virtual disk to /mnt"));
    m_mountAction->setEnabled(true);
    Core::Command *cmd2 = Core::ActionManager::registerAction(m_mountAction, Constants::MOUNT_ACTION_ID,
                                                              Core::Context(Core::Constants::C_GLOBAL));
    Core::ActionManager::actionContainer(Core::Constants::M_TOOLS)->addAction(cmd2);
    cmd2->setDefaultKeySequence(QKeySequence(tr("Ctrl+Alt+Meta+M")));



    m_unMountAction = new QAction(tr("Unmount..."),this);
    m_unMountAction->setToolTip(QLatin1String("Unmount virtual disk"));
    m_unMountAction->setEnabled(true);
    Core::Command *cmd3 = Core::ActionManager::registerAction(m_unMountAction, Constants::UNMOUNT_ACTION_ID,
                                                              Core::Context(Core::Constants::C_GLOBAL));
    Core::ActionManager::actionContainer(Core::Constants::M_TOOLS)->addAction(cmd3);
    cmd3->setDefaultKeySequence(QKeySequence(tr("Ctrl+Alt+Meta+U")));

    //add object
    addAutoReleasedObject(new CrossLinuxToolChain32BitFactory);
    addAutoReleasedObject(new CrossLinuxToolChain64BitFactory);
    addAutoReleasedObject(new CrossDevice32BitFactory);
    addAutoReleasedObject(new CrossDevice64BitFactory);
    addAutoReleasedObject(new CrossSettingsPage);
    addAutoReleasedObject(new CrossDeployConfigurationFactory);
    addAutoReleasedObject(new CrossDeployStepFactory);
    addAutoReleasedObject(new CrossRunConfigurationFactory);
    addAutoReleasedObject(new CrossRunControlFactory);

    //add wizard
    addAutoReleasedObject(new CrossLinuxCApp);
    addAutoReleasedObject(new CrossLinuxCppApp);
    addAutoReleasedObject(new LinuxKernelImage);
    addAutoReleasedObject(new LinuxKernelModule);
    addAutoReleasedObject(new LinuxLibCApp);
    addAutoReleasedObject(new LinuxLibCppApp);
    addAutoReleasedObject(new LinuxBare);
    addAutoReleasedObject(new LinuxUBoot);
    addAutoReleasedObject(new LinuxRTEM);



    connect(m_qemuAction, SIGNAL(triggered()), this, SLOT(qemuAction()));
    connect(m_mountAction, SIGNAL(triggered()), this, SLOT(mountAction()));
    connect(m_unMountAction, SIGNAL(triggered()), this, SLOT(unMountAction()));
    connect(&CrossQemuManager::instance(), SIGNAL(stateChanged(QProcess::ProcessState)), this, SLOT(updateQemuAction()));
    connect(&MountManager::instance(), SIGNAL(errorString(QString)), this, SLOT(mountMessage(QString)));
    connect(&MountManager::instance(), SIGNAL(messageString(QString)), this, SLOT(mountMessage(QString)));
    connect(&MountManager::instance(), SIGNAL(needPassword()), this, SLOT(updatePassword()));


    return true;
}

void CrossProjectManagerPlugin::extensionsInitialized()
{
    // Retrieve objects from the plugin manager's object pool
    // In the extensionsInitialized method, a plugin can be sure that all
    // plugins that depend on it are completely initialized.


    //Add new qemu device

    ProjectExplorer::DeviceManager *dm = ProjectExplorer::DeviceManager::instance();
    dm->addDevice(CrossDevice32Bit::create());
    dm->addDevice(CrossDevice64Bit::create());

    //NO kit setup here!!
    //don't konw why I can't use kit stuff here
    //It will cause a lot of warning....
    //so move to crossdkinfo
}

ExtensionSystem::IPlugin::ShutdownFlag CrossProjectManagerPlugin::aboutToShutdown()
{
    // Save settings
    // Disconnect from signals that are not needed during shutdown
    // Hide UI (if you add UI that is not in the main window directly)
    return SynchronousShutdown;
}

void CrossProjectManagerPlugin::qemuAction()
{
    if(CrossQemuManager::instance().isRuning()){
        CrossQemuManager::instance().stopRuntime();
    }
    else{
        CrossQemuManager::instance().startRuntime();
    }
    updateQemuAction();
}

void CrossProjectManagerPlugin::mountAction()
{
    MountManager::instance().mount();
}

void CrossProjectManagerPlugin::unMountAction()
{
    MountManager::instance().unmount();
}

void CrossProjectManagerPlugin::updateQemuAction()
{
    QIcon qemuStopIcon = QIcon(QLatin1String(Constants::QEMU_STOP_ICON));
    QIcon qemuRunIcon = QIcon(QLatin1String(Constants::QEMU_RUN_ICON));

    if(CrossQemuManager::instance().isRuning()){
        m_qemuAction->setIcon(qemuStopIcon);
        m_qemuAction->setToolTip(QLatin1String("Stop Qemu"));
    }
    else{
        m_qemuAction->setIcon(qemuRunIcon);
        m_qemuAction->setToolTip(QLatin1String("Start Qemu"));
    }
}

void CrossProjectManagerPlugin::mountMessage(const QString &s)
{
    QMessageBox::warning(0,QLatin1String("Message"),s);
}

void CrossProjectManagerPlugin::updatePassword()
{
    QString str =QInputDialog::getText(0,QLatin1String("Please input your super user password"),
                                       QLatin1String("Super User PassWord"),QLineEdit::Password);
    MountManager::instance().setPassWord(str);
}

Q_EXPORT_PLUGIN2(CrossProjectManager, CrossProjectManagerPlugin)

