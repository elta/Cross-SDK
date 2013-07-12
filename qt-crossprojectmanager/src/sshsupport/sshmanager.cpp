#include <ssh/sshconnectionmanager.h>

#include "device/crossqemuruntime.h"
#include "sshmanager.h"

namespace CrossProjectManager {
namespace Internal {

sshManager *sshManager::m_instance=0;

sshManager::sshManager(QObject *parent) :
    QObject(parent)
{
}


sshManager *sshManager::instance()
{
    if(m_instance==0)
        m_instance=new sshManager;
    return m_instance;
}

QSsh::SshConnection *sshManager::getSshConnection()
{
    const CrossQemuRuntime rt;
    m_sshConnection = QSsh::SshConnectionManager::instance().acquireConnection(rt.sshParameter());
    return m_sshConnection;
}






}
}
