#ifndef CROSSSDKINFO_H
#define CROSSSDKINFO_H

#include <QObject>
#include <QDir>
#include <QMap>
#include <QSettings>
#include <projectexplorer/toolchain.h>
#include <projectexplorer/kitmanager.h>
#include <projectexplorer/kit.h>
#include <projectexplorer/kitinformation.h>

#include "crossprojectmanagerconstants.h"
namespace CrossProjectManager {
namespace Internal {

typedef enum{
    _N64RunOn64,
    _N32RunOn64,
    _O32RunOn64,
    _O32RunOn32
}QemuType;

//note: This class's function is manage user's configuration
//in future will add some cutome wizard this is a globe setting.
class CrossSDKInfo : public QObject{
    Q_OBJECT
public:
    static CrossSDKInfo& instance(QObject *parent=0);
    void setConfig(QMap<QString,QString> config);
    QMap<QString,QString> getConfig();
    bool isAviliable(const QMap<QString,QString> & config, QString &reason);
    bool isAviliable(QString &reason);

    //don't ask me why use QLatin1String(&&&&&) instead "****";
    //ask qtcreator.pri
    // DEFINES += QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII
    //You then need to explicitly call fromAscii(),
    //fromLatin1(), fromUtf8(), or fromLocal8Bit() to construct a QString from an 8-bit string,
    //or use the lightweight QLatin1String class, for example:
    //QString url = QLatin1String("http://www.unicode.org/");

    QDir sdkRoot(){return QDir(m_config[QLatin1String("sdkroot")]);}
    QDir gnu32Path(){return QDir(m_config[QLatin1String("gnu32")]);}
    QDir gnu64Path(){return QDir(m_config[QLatin1String("gnu64")]);}
    QDir llvmPath(){return QDir(m_config[QLatin1String("llvm")]);}
    QDir qemuPath(){return QDir(m_config[QLatin1String("qemu")]);}
    QDir gnuLinuxPath(){return QDir(m_config[QLatin1String("gnulinux")]);}

    //attention: device should be updated!
    void setQemuType(QemuType qt);
    QemuType getQemuType()const;
    void setComplier(ProjectExplorer::ToolChain *toolchain);
    ProjectExplorer::ToolChain * getComplier();
signals:
    void SDKPathError();

private:
    CrossSDKInfo(QObject *parent);
    ~CrossSDKInfo();
    void readSetting();
    void writeSetting();
    void updateSDK(const QString &sdkRootLocation);
    static ProjectExplorer::Kit * getCrossKit();

    static CrossSDKInfo *m_instance;
    QMap<QString,QString> m_config;
    QemuType m_qemuType;

};

} // namespace Internal
} // namespace CrossProjectManager
#endif // CROSSSDKINFO_H
