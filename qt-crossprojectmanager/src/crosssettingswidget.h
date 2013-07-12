#ifndef CROSSSETTINGSWIDGET_H
#define CROSSSETTINGSWIDGET_H

#include <QDialog>
#include <QFileDialog>
#include <utils/fileutils.h>
#include <QMap>


namespace Ui {
class CrossSettingsWidget;
}
namespace CrossProjectManager {
namespace Internal {


class CrossSettingsWidget : public QDialog
{
    Q_OBJECT
    
public:
    explicit CrossSettingsWidget(QWidget *parent = 0);
    ~CrossSettingsWidget();
    void setConfig(QMap<QString,QString> config);
    QMap<QString,QString> getConfig()const;
    QString searchKeywords() const;
private slots:
    void sdkLocationEditingFinished();
    void gnu32LocationEditingFinished();
    void gnu64LocationEditingFinished();
    void llvmLocationEditingFinished();
    void qemuLocationEditingFinished();
    void gnuLinuxLocationEditingFinished();

    void browseSDKLocation();
    void browseGnu32Location();
    void browseGnu64Location();
    void browsellvmLocation();
    void browseQemuLocation();
    void browseGnuLinuxLocation();

    void updateTarget();

private:
    void updateGUI();
    void connectSingals();

    Utils::FileName getLocation(QString describeString);
    void updateSDK(const QString &sdkRootLocation);

    QMap<QString,QString> m_config;
    Ui::CrossSettingsWidget *m_ui;
};

}
}
#endif // CROSSSETTINGSWIDGET_H
