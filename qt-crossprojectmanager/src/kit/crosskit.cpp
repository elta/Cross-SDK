#include "crosskit.h"
#include "crossprojectmanagerconstants.h"
#include <projectexplorer/toolchain.h>
#include <projectexplorer/toolchainmanager.h>
#include <projectexplorer/kitinformation.h>
using namespace CrossProjectManager;
using namespace Internal;

////crosskit::crosskit(Core::Id id)
//    :ProjectExplorer::Kit(id)
//{
////    setDisplayName("Cross Kit");
////    QList<ProjectExplorer::ToolChain *> tcList = ProjectExplorer::ToolChainManager::instance()->toolChains();
////    foreach (ProjectExplorer::ToolChain *current, tcList) {
////        if (current->type()==Constants::CROSSLINUX_TOOLCHAIN_TYPE) {
////            ProjectExplorer::ToolChainKitInformation::setToolChain(this, current);
////        }
////    }

//}
