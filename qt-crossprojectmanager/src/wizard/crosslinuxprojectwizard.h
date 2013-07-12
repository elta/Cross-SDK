#ifndef CROSSLINUXPROJECTWIZARD_H
#define CROSSLINUXPROJECTWIZARD_H

#include "qtwizard.h"

namespace CrossProjectManager {
namespace Internal {


class CrossLinuxCApp : public QtWizard
{
    Q_OBJECT
public:
    CrossLinuxCApp();

protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
    
};

class CrossLinuxCppApp : public QtWizard
{
    Q_OBJECT
public:
    CrossLinuxCppApp();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};


class LinuxKernelImage : public QtWizard
{
    Q_OBJECT
public:
    LinuxKernelImage();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};

class LinuxKernelModule : public QtWizard
{
    Q_OBJECT
public:
    LinuxKernelModule();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};

class LinuxLibCApp : public QtWizard
{
    Q_OBJECT
public:
    LinuxLibCApp();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};

class LinuxLibCppApp : public QtWizard
{
    Q_OBJECT
public:
    LinuxLibCppApp();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};

class LinuxUBoot : public QtWizard
{
    Q_OBJECT
public:
    LinuxUBoot();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};

class LinuxBare : public QtWizard
{
    Q_OBJECT
public:
    LinuxBare();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};

class LinuxRTEM : public QtWizard
{
    Q_OBJECT
public:
    LinuxRTEM();
protected:
    QWizard *createWizardDialog(QWidget *parent,
                                            const Core::WizardDialogParameters &wizardDialogParameters) const;
    Core::GeneratedFiles generateFiles(const QWizard *w,
                                                   QString *errorMessage) const;
    Core::FeatureSet requiredFeatures() const;
};



}}
#endif // CROSSLINUXPROJECTWIZARD_H
