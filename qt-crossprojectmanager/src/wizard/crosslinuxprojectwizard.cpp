#include "crosslinuxprojectwizard.h"
#include "crossprojectmanagerconstants.h"
#include <qtsupport/qtsupportconstants.h>
#include "crosslinuxwizarddialog.h"
using namespace CrossProjectManager;
using namespace Internal;

/*
 *QtWizard(const QString &id,
             const QString &category,
             const QString &displayCategory,
             const QString &name,
             const QString &description,
             const QIcon &icon);
             */
static const char mainCpp[] =
        "#include <iostream>\n\n"
        "int main()\n"
        "{\n"
        "    std::cout<<\"hello world !\\n\";\n\n"
        "    return 0;\n"
        "}\n";

static const char mainC[] =
        "#include <stdio.h>\n\n"
        "int main()\n"
        "{\n"
        "    printf(\"hello world !\\n\");\n\n"
        "    return 0;\n"
        "}\n";

static const char mainSourceFileC[] = "main";

CrossLinuxCApp::CrossLinuxCApp()
    :QtWizard(QLatin1String("A.Plain C App"),
              QLatin1String("B.Projects"),
              QLatin1String("Cross Linux Project"),
              QLatin1String("Cross Linux (C) Application Project"),
              QLatin1String("Creates a plain C project using qmake, not using the Qt library."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

//c app
QWizard *CrossLinuxCApp::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    CrossLinuxCAPPDialog *dialog = new CrossLinuxCAPPDialog(displayName(), icon(),
                                                            parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles CrossLinuxCApp::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const CrossLinuxCAPPDialog *wizard = qobject_cast<const CrossLinuxCAPPDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(mainC));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}


Core::FeatureSet CrossLinuxCApp::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}

//cpp app
CrossLinuxCppApp::CrossLinuxCppApp()
    :QtWizard(QLatin1String("A.Plain C++ App"),
              QLatin1String("B.Projects"),
              QLatin1String("Cross Linux Project"),
              QLatin1String("Cross Linux (C++) Application Project"),
              QLatin1String("Creates a plain C++ project using qmake, not using the Qt library."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *CrossLinuxCppApp::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    CrossLinuxCPPAPPDialog *dialog = new CrossLinuxCPPAPPDialog(displayName(), icon(),
                                                                parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles CrossLinuxCppApp::generateFiles(const QWizard *w, QString *errorMessage) const
{

    Q_UNUSED(errorMessage);

    const CrossLinuxCPPAPPDialog *wizard = qobject_cast<const CrossLinuxCPPAPPDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".cpp"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(mainCpp));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet CrossLinuxCppApp::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}

//kernel
LinuxKernelImage::LinuxKernelImage()
    :QtWizard(QLatin1String("A.Cross Linux Kernel Image c app"),
              QLatin1String("B.Projects"),
              QLatin1String("Cross Linux Project"),
              QLatin1String("Cross Linux Kernel Image Project"),
              QLatin1String("Cross Linux Kernel Image without any files."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *LinuxKernelImage::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    LinuxKernelImageDialog *dialog = new LinuxKernelImageDialog(displayName(), icon(),
                                                                parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles LinuxKernelImage::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const LinuxKernelImageDialog *wizard = qobject_cast<const LinuxKernelImageDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(""));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet LinuxKernelImage::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}

//kernel module
LinuxKernelModule::LinuxKernelModule()
    :QtWizard(QLatin1String("A.Cross Linux Kernel Module c app"),
              QLatin1String("B.Projects"),
              QLatin1String("Cross Linux Project"),
              QLatin1String("Cross Linux Kernel Module(Driver) Project"),
              QLatin1String("Cross Linux Kernel Module(Driver) without any files."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *LinuxKernelModule::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    LinuxKernelModuleDialog *dialog = new LinuxKernelModuleDialog(displayName(), icon(),
                                                                  parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles LinuxKernelModule::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const LinuxKernelModuleDialog *wizard = qobject_cast<const LinuxKernelModuleDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(""));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet LinuxKernelModule::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}

//c lib
LinuxLibCApp::LinuxLibCApp()
    :QtWizard(QLatin1String("A.Plain C lib App"),
              QLatin1String("B.Projects"),
              QLatin1String("Cross Linux Project"),
              QLatin1String("Cross Linux (C) Library Project"),
              QLatin1String("Creates a (C) Library Project using qmake, not using the Qt library."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *LinuxLibCApp::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    LinuxLibCAppDialog *dialog = new LinuxLibCAppDialog(displayName(), icon(),
                                                        parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles LinuxLibCApp::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const LinuxLibCAppDialog *wizard = qobject_cast<const LinuxLibCAppDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(""));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet LinuxLibCApp::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}


//cpp lib
LinuxLibCppApp::LinuxLibCppApp()
    :QtWizard(QLatin1String("A.Plain Cpp lib App"),
              QLatin1String("B.Projects"),
              QLatin1String("Cross Linux Project"),
              QLatin1String("Cross Linux (C++) Library Project"),
              QLatin1String("Creates a (C++) Library Project using qmake, not using the Qt library."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *LinuxLibCppApp::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    LinuxLibCppAppDialog *dialog = new LinuxLibCppAppDialog(displayName(), icon(),
                                                            parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles LinuxLibCppApp::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const LinuxLibCppAppDialog *wizard = qobject_cast<const LinuxLibCppAppDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(""));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet LinuxLibCppApp::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}

//u-boot
LinuxUBoot::LinuxUBoot()
    :QtWizard(QLatin1String("A.Cross U-Boot C App"),
              QLatin1String("C.Projects"),
              QLatin1String("U-Boot Project"),
              QLatin1String("Cross U-Boot Project"),
              QLatin1String("U-Boot Project without any files."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *LinuxUBoot::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    LinuxUBOOTDialog *dialog = new LinuxUBOOTDialog(displayName(), icon(),
                                                            parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles LinuxUBoot::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const LinuxUBOOTDialog *wizard = qobject_cast<const LinuxUBOOTDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(""));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet LinuxUBoot::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}

//bare
LinuxBare::LinuxBare()
    :QtWizard(QLatin1String("A.Cross Bare C App"),
              QLatin1String("D.Projects"),
              QLatin1String("Cross Bare Project"),
              QLatin1String("Cross Bare System Project"),
              QLatin1String("Creates a Cross Bare C app using qmake, not using the Qt library."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *LinuxBare::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    LinuxBareDialog *dialog = new LinuxBareDialog(displayName(), icon(),
                                                            parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles LinuxBare::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const LinuxBareDialog *wizard = qobject_cast<const LinuxBareDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(mainC));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet LinuxBare::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}

//LinuxRTEM
LinuxRTEM::LinuxRTEM()
    :QtWizard(QLatin1String("A.Cross RTEM SYSTEM App"),
              QLatin1String("F.Projects"),
              QLatin1String("Cross RTEM Project"),
              QLatin1String("Cross RTEM System Project"),
              QLatin1String("Creates RTEM app using qmake, not using the Qt library."),
              QIcon(QLatin1String(":/res/icon/console.png")))
{
}

QWizard *LinuxRTEM::createWizardDialog(QWidget *parent, const Core::WizardDialogParameters &wizardDialogParameters) const
{
    LinuxRTEMDialog *dialog = new LinuxRTEMDialog(displayName(), icon(),
                                                            parent, wizardDialogParameters);
    return dialog;
}

Core::GeneratedFiles LinuxRTEM::generateFiles(const QWizard *w, QString *errorMessage) const
{
    Q_UNUSED(errorMessage);

    const LinuxRTEMDialog *wizard = qobject_cast<const LinuxRTEMDialog *>(w);
    const QtProjectParameters params = wizard->parameters();
    const QString projectPath = params.projectPath();

    // Create files: Source
    const QString sourceFileName = Core::BaseFileWizard::buildFileName(projectPath, QLatin1String(mainSourceFileC), QLatin1String(".c"));
    Core::GeneratedFile source(sourceFileName);
    source.setContents(QLatin1String(mainC));
    source.setAttributes(Core::GeneratedFile::OpenEditorAttribute);
    // Create files: Profile
    const QString profileName = Core::BaseFileWizard::buildFileName(projectPath, params.fileName,  QLatin1String(".pro"));

    Core::GeneratedFile profile(profileName);
    profile.setAttributes(Core::GeneratedFile::OpenProjectAttribute);
    QString contents;
    {
        QTextStream proStr(&contents);
        QtProjectParameters::writeProFileHeader(proStr);
        params.writeProFile(proStr);
        proStr << "\n\nSOURCES += " << QFileInfo(sourceFileName).fileName() << '\n';
    }
    profile.setContents(contents);
    return Core::GeneratedFiles() <<  source << profile;
}

Core::FeatureSet LinuxRTEM::requiredFeatures() const
{
    return Core::Feature(QtSupport::Constants::FEATURE_QT_CONSOLE);
}
