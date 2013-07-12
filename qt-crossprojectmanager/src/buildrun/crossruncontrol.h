#ifndef CROSSRUNCONTROL_H
#define CROSSRUNCONTROL_H
#include <projectexplorer/runconfiguration.h>
#include <projectexplorer/devicesupport/deviceapplicationrunner.h>
#include "crossrunconfiguration.h"

#include "crossapprunner.h"

namespace CrossProjectManager {
namespace Internal {
class CrossRunControl : public ProjectExplorer::RunControl
{
    Q_OBJECT
public:
    explicit CrossRunControl(CrossRunConfiguration *rc);
    StopResult stop();
    void start();
    bool isRunning() const;
    QIcon icon() const;
public slots:
    void addStdOutMessage(const QByteArray&str);
    void addStdErrorMessage(const QByteArray&str);
    void handleProcessStarted();
    void handleFinished(const bool &result);
    void handleReportError(const QString&str);
    void handleReportProgress(const QString&str);
private:
    ProjectExplorer::IDevice::ConstPtr m_device;
    ProjectExplorer::DeviceApplicationRunner *m_AppRunner;
    bool running;
};

} // namespace CrossProjectManager
} // namespace Internal
#endif // CROSSRUNCONTROL_H
