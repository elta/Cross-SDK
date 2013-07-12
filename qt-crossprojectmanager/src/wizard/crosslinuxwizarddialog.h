#ifndef CROSSLINUXWIZARDDIALOG_H
#define CROSSLINUXWIZARDDIALOG_H
#include "qtwizard.h"

namespace CrossProjectManager {
namespace Internal {
class CrossLinuxCAPPDialog : public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    CrossLinuxCAPPDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};

class CrossLinuxCPPAPPDialog : public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    CrossLinuxCPPAPPDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};

class LinuxKernelImageDialog :public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    LinuxKernelImageDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};

class LinuxKernelModuleDialog :public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    LinuxKernelModuleDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};

class LinuxLibCAppDialog :public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    LinuxLibCAppDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};

class LinuxLibCppAppDialog :public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    LinuxLibCppAppDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};


class LinuxUBOOTDialog :public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    LinuxUBOOTDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};
class LinuxBareDialog :public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    LinuxBareDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};
class LinuxRTEMDialog :public BaseQt4ProjectWizardDialog
{
    Q_OBJECT
public:
    LinuxRTEMDialog(const QString &templateName,
                           const QIcon &icon,
                           QWidget *parent, const Core::WizardDialogParameters &parameters);
     QtProjectParameters parameters() const;
};

} // namespace Internal
} // namespace CrossProjectManager

#endif // CROSSLINUXWIZARDDIALOG_H
