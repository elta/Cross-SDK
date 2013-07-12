#ifndef CROSSSETTINGSPAGE_H
#define CROSSSETTINGSPAGE_H

#include <coreplugin/dialogs/ioptionspage.h>

namespace CrossProjectManager {
namespace Internal {

class CrossSettingsWidget;

class CrossSettingsPage : public Core::IOptionsPage
{
    Q_OBJECT
public:
    explicit CrossSettingsPage(QObject *parent=0);

    bool matches(const QString &searchKeyWord) const;
    QWidget *createPage(QWidget *parent);
    void apply();
    void finish();

private:
    QString m_keywords;
    CrossSettingsWidget *m_widget;
};

} // namespace Internal
} // namespace CrossProjectManager
#endif // CROSSSETTINGSPAGE_H
