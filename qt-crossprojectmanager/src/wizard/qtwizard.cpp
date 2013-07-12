/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of Qt Creator.
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
****************************************************************************/

#include "qtwizard.h"



#include <coreplugin/icore.h>
#include <coreplugin/editormanager/editormanager.h>

#include <cpptools/cpptoolsconstants.h>

#include <projectexplorer/kit.h>
#include <projectexplorer/projectexplorer.h>
#include <projectexplorer/task.h>
#include <qtsupport/qtkitinformation.h>
#include <qtsupport/qtsupportconstants.h>

#include <extensionsystem/pluginmanager.h>

#include <QCoreApplication>
#include <QVariant>

using namespace CrossProjectManager;
using namespace CrossProjectManager::Internal;

static Core::BaseFileWizardParameters
    wizardParameters(const QString &id,
                     const QString &category,
                     const QString &displayCategory,
                     const QString &name,
                     const QString &description,
                     const QIcon &icon)
{
    Core::BaseFileWizardParameters rc(Core::IWizard::ProjectWizard);
    rc.setCategory(category);
    rc.setDisplayCategory(QCoreApplication::translate("ProjectExplorer",
                                                      displayCategory.toLatin1()));
    rc.setIcon(icon);
    rc.setDisplayName(name);
    rc.setId(id);
    rc.setDescription(description);
    return rc;
}

QtWizard::QtWizard(const QString &id,
                   const QString &category,
                   const QString &displayCategory,
                   const QString &name,
                   const QString &description, const QIcon &icon) :
    Core::BaseFileWizard(wizardParameters(id,
                                          category,
                                          displayCategory,
                                          name,
                                          description,
                                          icon))
{
}

bool QtWizard::postGenerateFiles(const QWizard *w, const Core::GeneratedFiles &l, QString *errorMessage)
{
    return QtWizard::qt4ProjectPostGenerateFiles(w, l, errorMessage);
}

bool QtWizard::qt4ProjectPostGenerateFiles(const QWizard *w,
                                           const Core::GeneratedFiles &generatedFiles,
                                           QString *errorMessage)
{
    const BaseQt4ProjectWizardDialog *dialog = qobject_cast<const BaseQt4ProjectWizardDialog *>(w);

    // Generate user settings
    foreach (const Core::GeneratedFile &file, generatedFiles)
        if (file.attributes() & Core::GeneratedFile::OpenProjectAttribute) {
            dialog->writeUserFile(file.path());
            break;
        }

    // Post-Generate: Open the projects/editors
    return ProjectExplorer::CustomProjectWizard::postGenerateOpen(generatedFiles ,errorMessage);
}


bool QtWizard::lowerCaseFiles()
{
    QString lowerCaseSettingsKey = QLatin1String(CppTools::Constants::CPPTOOLS_SETTINGSGROUP);
    lowerCaseSettingsKey += QLatin1Char('/');
    lowerCaseSettingsKey += QLatin1String(CppTools::Constants::LOWERCASE_CPPFILES_KEY);
    const bool lowerCaseDefault = CppTools::Constants::lowerCaseFilesDefault;
    return Core::ICore::settings()->value(lowerCaseSettingsKey, QVariant(lowerCaseDefault)).toBool();
}

// ----------------- BaseQt4ProjectWizardDialog
BaseQt4ProjectWizardDialog::BaseQt4ProjectWizardDialog(QWidget *parent,
                                                       const Core::WizardDialogParameters &parameters) :
    ProjectExplorer::BaseProjectWizardDialog(parent, parameters),
    m_targetSetupPage(0),
    m_profileIds(parameters.extraValues().value(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)).value<QList<Core::Id> >())
{
    init();
}

BaseQt4ProjectWizardDialog::BaseQt4ProjectWizardDialog(Utils::ProjectIntroPage *introPage,
                                                       int introId, QWidget *parent,
                                                       const Core::WizardDialogParameters &parameters) :
    ProjectExplorer::BaseProjectWizardDialog(introPage, introId, parent, parameters),
    m_targetSetupPage(0),
    m_profileIds(parameters.extraValues().value(QLatin1String(ProjectExplorer::Constants::PROJECT_KIT_IDS)).value<QList<Core::Id> >())
{
    init();
}

BaseQt4ProjectWizardDialog::~BaseQt4ProjectWizardDialog()
{
    if (m_targetSetupPage && !m_targetSetupPage->parent())
        delete m_targetSetupPage;
}

void BaseQt4ProjectWizardDialog::init()
{
    connect(this, SIGNAL(projectParametersChanged(QString,QString)),
            this, SLOT(generateProfileName(QString,QString)));
}

int BaseQt4ProjectWizardDialog::addTargetSetupPage( int id)
{
    m_targetSetupPage = new Qt4ProjectManager::TargetSetupPage;
    m_targetSetupPage->setRequiredKitMatcher(new QtSupport::QtVersionKitMatcher(requiredFeatures()));

    resize(900, 450);
    if (id >= 0)
        setPage(id, m_targetSetupPage);
    else
        id = addPage(m_targetSetupPage);
    wizardProgress()->item(id)->setTitle(tr("Kits"));
    return id;
}

bool BaseQt4ProjectWizardDialog::writeUserFile(const QString &proFileName) const
{
    if (!m_targetSetupPage)
        return false;

    Qt4ProjectManager::Qt4Manager *manager = ExtensionSystem::PluginManager::getObject<Qt4ProjectManager::Qt4Manager>();
    Q_ASSERT(manager);

    Qt4ProjectManager::Qt4Project *pro = new Qt4ProjectManager::Qt4Project(manager, proFileName);
    bool success = m_targetSetupPage->setupProject(pro);
    if (success)
        pro->saveSettings();
    delete pro;
    return success;
}

bool BaseQt4ProjectWizardDialog::setupProject(Qt4ProjectManager::Qt4Project *project) const
{
    if (!m_targetSetupPage)
        return true;
    return m_targetSetupPage->setupProject(project);
}

bool BaseQt4ProjectWizardDialog::isQtPlatformSelected(const QString &platform) const
{
    QList<Core::Id> selectedKitList = selectedKits();

    QtSupport::QtPlatformKitMatcher matcher(platform);
    QList<ProjectExplorer::Kit *> kitList
            = ProjectExplorer::KitManager::instance()->kits(&matcher);
    foreach (ProjectExplorer::Kit *k, kitList) {
        if (selectedKitList.contains(k->id()))
            return true;
    }
    return false;
}

QList<Core::Id> BaseQt4ProjectWizardDialog::selectedKits() const
{
    if (!m_targetSetupPage)
        return m_profileIds;
    return m_targetSetupPage->selectedKits();
}

void BaseQt4ProjectWizardDialog::addExtensionPages(const QList<QWizardPage *> &wizardPageList)
{
    foreach (QWizardPage *p,wizardPageList)
        Core::BaseFileWizard::applyExtensionPageShortTitle(this, addPage(p));
}

void BaseQt4ProjectWizardDialog::generateProfileName(const QString &name, const QString &path)
{
    if (!m_targetSetupPage)
        return;

    const QString proFile =
        QDir::cleanPath(path + QLatin1Char('/') + name + QLatin1Char('/')
                        + name + QLatin1String(".pro"));

    m_targetSetupPage->setProFilePath(proFile);
}
