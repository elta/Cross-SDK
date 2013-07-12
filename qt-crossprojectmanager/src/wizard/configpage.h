#ifndef CONFIGPAGE_H
#define CONFIGPAGE_H

#include <QWizardPage>

namespace Ui {
class ConfigPage;
}
namespace CrossProjectManager {
namespace Internal {
class ConfigPage : public QWizardPage
{
    Q_OBJECT
    
public:
    explicit ConfigPage(QWidget *parent = 0);
    ~ConfigPage();
    
public slots:
    void updateComplier();
    void updateTarget();

private:
    Ui::ConfigPage *ui;
};

}}

#endif // CONFIGPAGE_H
