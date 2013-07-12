#ifndef SSHMANAGER_H
#define SSHMANAGER_H

#include <QObject>

#include <ssh/sshconnection.h>

namespace CrossProjectManager {
namespace Internal {

class sshManager : public QObject
{
    Q_OBJECT
public:

    sshManager* instance();

    QSsh::SshConnection * getSshConnection();

    
signals:
    
public slots:

private:
    explicit sshManager(QObject *parent = 0);
    static sshManager *m_instance;
    QSsh::SshConnection *m_sshConnection;
};

}
}

#endif // SSHMANAGER_H
