#include "crosslinuxwizarddialog.h"
#include <projectexplorer/projectexplorerconstants.h>
#include "configpage.h"
using namespace CrossProjectManager;
using namespace Internal;
//c app
CrossLinuxCAPPDialog::CrossLinuxCAPPDialog(const QString &templateName,
                                           const QIcon &icon,
                                           QWidget *parent, const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Creates a plain C project using qmake, not using the Qt library."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters CrossLinuxCAPPDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}

//cpp app
CrossLinuxCPPAPPDialog::CrossLinuxCPPAPPDialog(const QString &templateName,
                                               const QIcon &icon,
                                               QWidget *parent, const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Creates a plain C++ project using qmake, not using the Qt library."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters CrossLinuxCPPAPPDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}

//kernel image
LinuxKernelImageDialog::LinuxKernelImageDialog(const QString &templateName,
                                               const QIcon &icon, QWidget *parent,
                                               const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Cross Linux Kernel Image without any files."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters LinuxKernelImageDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}

//kernel module
LinuxKernelModuleDialog::LinuxKernelModuleDialog(const QString &templateName,
                                                 const QIcon &icon,
                                                 QWidget *parent,
                                                 const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Cross Linux Kernel Module(Driver) without any files."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters LinuxKernelModuleDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}

//c lib
LinuxLibCAppDialog::LinuxLibCAppDialog(const QString &templateName,
                                       const QIcon &icon,
                                       QWidget *parent,
                                       const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Creates a (C) Library Project using qmake, not using the Qt library."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters LinuxLibCAppDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;

}

//cpp lib
LinuxLibCppAppDialog::LinuxLibCppAppDialog(const QString &templateName,
                                           const QIcon &icon,
                                           QWidget *parent,
                                           const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Creates a (C++) Library Project using qmake, not using the Qt library."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters LinuxLibCppAppDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}

//uboot
LinuxUBOOTDialog::LinuxUBOOTDialog(const QString &templateName,
                                   const QIcon &icon,
                                   QWidget *parent,
                                   const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("U-Boot Project without any files."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters LinuxUBOOTDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}

//bare
LinuxBareDialog::LinuxBareDialog(const QString &templateName,
                                 const QIcon &icon,
                                 QWidget *parent,
                                 const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Creates a Cross Bare C app using qmake, not using the Qt library."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters LinuxBareDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}

//retm
LinuxRTEMDialog::LinuxRTEMDialog(const QString &templateName,
                                 const QIcon &icon,
                                 QWidget *parent,
                                 const Core::WizardDialogParameters &parameters)
    :BaseQt4ProjectWizardDialog(parent,parameters)
{
    setWindowIcon(icon);
    setWindowTitle(templateName);
    setIntroDescription(tr("Creates a Cross Bare C app using qmake, not using the Qt library."));
    if (!parameters.extraValues().contains(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)))
        addTargetSetupPage();
    addPage(new ConfigPage);
    addExtensionPages(parameters.extensionPages());
}

QtProjectParameters LinuxRTEMDialog::parameters() const
{
    QtProjectParameters rc;
    rc.type = QtProjectParameters::ConsoleApp;
    rc.fileName = projectName();
    rc.path = path();

    return rc;
}
