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

#include "qtprojectparameters.h"
#include <utils/codegeneration.h>

#include <QTextStream>
#include <QDir>
#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>

namespace CrossProjectManager {
namespace Internal {

// ----------- QtProjectParameters
QtProjectParameters::QtProjectParameters()
  : type(ConsoleApp)
{
}

QString QtProjectParameters::projectPath() const
{
    QString rc = path;
    if (!rc.isEmpty())
        rc += QDir::separator();
    rc += fileName;
    return rc;
}


void QtProjectParameters::writeProFile(QTextStream &str) const
{

    const QString &effectiveTarget = target.isEmpty() ? fileName : target;
    if (!effectiveTarget.isEmpty())
        str << "TARGET = " <<  effectiveTarget << '\n';
    switch (type) {
    case ConsoleApp:
        // Mac: Command line apps should not be bundles
        str << "CONFIG   += console\nCONFIG   -=qt\nCONFIG   -= app_bundle\n\n";
    case GuiApp:
        str << "TEMPLATE = app\n";
        break;
    case StaticLibrary:
        str << "TEMPLATE = lib\nCONFIG += staticlib\n";
        break;
    case SharedLibrary:
        str << "TEMPLATE = lib\n\nDEFINES += " << libraryMacro(fileName) << '\n';
        break;
    case Qt4Plugin:
        str << "TEMPLATE = lib\nCONFIG += plugin\n";
        break;
    default:
        break;
    }

    if (!targetDirectory.isEmpty())
        str << "\nDESTDIR = " << targetDirectory << '\n';
}

void QtProjectParameters::writeProFileHeader(QTextStream &str)
{
    const QChar hash = QLatin1Char ('#');
    const QChar nl = QLatin1Char('\n');
    const QChar blank = QLatin1Char(' ');
    // Format as '#-------\n# <Header> \n#---------'
    QString header = QLatin1String(" Project created by ");
    header += QCoreApplication::applicationName();
    header += blank;
    header += QDateTime::currentDateTime().toString(Qt::ISODate);
    const QString line = QString(header.size(), QLatin1Char('-'));
    str << hash << line << nl << hash << nl << hash << header << nl
        << hash <<nl << hash << line << nl << nl;
}


QString createMacro(const QString &name, const QString &suffix)
{
    QString rc = name.toUpper();
    const int extensionPosition = rc.indexOf(QLatin1Char('.'));
    if (extensionPosition != -1)
        rc.truncate(extensionPosition);
    rc += suffix;
    return Utils::fileNameToCppIdentifier(rc);
}

QString QtProjectParameters::exportMacro(const QString &projectName)
{
    return createMacro(projectName, QLatin1String("SHARED_EXPORT"));
}

QString QtProjectParameters::libraryMacro(const QString &projectName)
{
     return createMacro(projectName, QLatin1String("_LIBRARY"));
}

} // namespace Internal
} // namespace CrossProjectManager
