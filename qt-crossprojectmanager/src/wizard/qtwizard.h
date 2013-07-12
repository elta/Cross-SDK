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

#ifndef QTWIZARD_H
#define QTWIZARD_H

#include "qtprojectparameters.h"
#include <projectexplorer/baseprojectwizarddialog.h>
#include <projectexplorer/customwizard/customwizard.h>
#include <coreplugin/basefilewizard.h>
#include <QSet>

#include <qt4projectmanager/qt4project.h>
#include <qt4projectmanager/qt4projectmanager.h>
#include <qt4projectmanager/qt4projectmanagerconstants.h>
#include <qt4projectmanager/wizards/targetsetuppage.h>


namespace ProjectExplorer { class Kit; }

namespace CrossProjectManager {
namespace Internal {

/* Base class for wizard creating Qt projects using QtProjectParameters.
 * To implement a project wizard, overwrite:
 * - createWizardDialog() to create up the dialog
 * - generateFiles() to set their contents
 * The base implementation provides the wizard parameters and opens
 * the finished project in postGenerateFiles().
 * The pro-file must be the last one of the generated files. */

class QtWizard : public Core::BaseFileWizard
{
    Q_OBJECT

protected:
    QtWizard(const QString &id,
             const QString &category,
             const QString &displayCategory,
             const QString &name,
             const QString &description,
             const QIcon &icon);

public:
    //static QString templateDir();
    //Query CppTools settings for the class wizard settings
    static bool lowerCaseFiles();
    static bool qt4ProjectPostGenerateFiles(const QWizard *w, const Core::GeneratedFiles &l, QString *errorMessage);

private:
    bool postGenerateFiles(const QWizard *w, const Core::GeneratedFiles &l, QString *errorMessage);
};



/* BaseQt4ProjectWizardDialog: Additionally offers modules page
 * and getter/setter for blank-delimited modules list, transparently
 * handling the visibility of the modules page list as well as a page
 * to select targets and Qt versions.
 */

class BaseQt4ProjectWizardDialog : public ProjectExplorer::BaseProjectWizardDialog
{

    Q_OBJECT

protected:
    explicit BaseQt4ProjectWizardDialog(Utils::ProjectIntroPage *introPage,
                                        int introId,
                                        QWidget *parent,
                                        const Core::WizardDialogParameters &parameters);
public:
    explicit BaseQt4ProjectWizardDialog(QWidget *parent,
                                        const Core::WizardDialogParameters &parameters);
    virtual ~BaseQt4ProjectWizardDialog();

    int addTargetSetupPage(int id = -1);

    bool writeUserFile(const QString &proFileName) const;
    bool setupProject(Qt4ProjectManager::Qt4Project  *project) const;
    bool isQtPlatformSelected(const QString &platform) const;
    QList<Core::Id> selectedKits() const;

    void addExtensionPages(const QList<QWizardPage *> &wizardPageList);

private slots:
    void generateProfileName(const QString &name, const QString &path);

private:
    inline void init();

    Qt4ProjectManager::TargetSetupPage *m_targetSetupPage;
    QList<Core::Id> m_profileIds;
};

} // namespace Internal
} // namespace CrossProjectManager

#endif // QTWIZARD_H
