#include "crossrunconfiguration.h"


#include <qtsupport/qtoutputformatter.h>
#include <qtsupport/qtkitinformation.h>
#include <projectexplorer/kitinformation.h>
#include <projectexplorer/target.h>

#include <qt4projectmanager/qt4nodes.h>

using namespace CrossProjectManager;
using namespace Internal;
CrossRunConfiguration::CrossRunConfiguration(ProjectExplorer::Target *parent, Core::Id id)
    :RunConfiguration(parent,id)
{
    init();
}
CrossRunConfiguration::CrossRunConfiguration(ProjectExplorer::Target *parent, CrossRunConfiguration *source)
    :RunConfiguration(parent, source)
{
    init();
}

QWidget *CrossRunConfiguration::createConfigurationWidget()
{
    // no special running configurations
    return 0;
}

Utils::OutputFormatter *CrossRunConfiguration::createOutputFormatter() const
{
    return new QtSupport::QtOutputFormatter(target()->project());
}
QString CrossRunConfiguration::defaultDisplayName()
{
    return tr("Run on Qemu");
}

void CrossRunConfiguration::init()
{
    setDefaultDisplayName(defaultDisplayName());
}

