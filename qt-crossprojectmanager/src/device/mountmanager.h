#ifndef MOUNTMANAGER_H
#define MOUNTMANAGER_H

#include <QObject>
#include <QProcess>
namespace CrossProjectManager {
namespace Internal {

/*!
  \class CrossProjectManager::MountManager
  \brief Provides an interface for manage mount options and provide sudo password.
*/
class MountManager : public QObject
{
    Q_OBJECT
public:
    static MountManager& instance(QObject *parent=0);
    QString getMountDir()const;
    QString getPassWord()const ;
    bool isMounted()const;
signals:
    void needPassword();
    void errorString(const QString &);
    void messageString(const QString &);
public slots:
    bool mount();
    bool unmount();
    void setPassWord(const QString &psw );
    void setMountDir(QString mdir);
private:
    MountManager(QObject *parent = 0);
    bool isPasswordCorrect();
    bool mountedDirExists() const;

    static MountManager *m_instance;
    QString m_mountdir;
    QString m_imgdir;
    QString m_userPassWord;
};

} // namespace Internal
} // namespace CrossProjectManager

#endif // MOUNTMANAGER_H
