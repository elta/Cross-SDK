#include "crossprojectmanagerconstants.h"
#include "crosssettingspage.h"
#include "crosssettingswidget.h"
#include "crosssdkinfo.h"
using namespace CrossProjectManager;
using namespace Internal;

CrossSettingsPage::CrossSettingsPage(QObject *parent)
    :Core::IOptionsPage(parent)
{
    setId(Constants::CROSS_SETTINGS_ID);
    setDisplayName(QLatin1String("Cross Configurations"));
    setCategory(Constants::CROSS_SETTINGS_CATEGORY);
    setDisplayCategory(QLatin1String(Constants::CROSS_SETTINGS_CATEGORY));
    setCategoryIcon(QLatin1String(Constants::CROSS_SETTINGS_ICON));
}

bool CrossSettingsPage::matches(const QString &searchKeyWord) const
{
    return m_keywords.contains(searchKeyWord, Qt::CaseInsensitive);
}

QWidget *CrossSettingsPage::createPage(QWidget *parent)
{
    m_widget = new CrossSettingsWidget(parent);
    if (m_keywords.isEmpty())
        m_keywords = m_widget->searchKeywords();
    return m_widget;
}

void CrossSettingsPage::apply()
{
    CrossSDKInfo::instance().setConfig(m_widget->getConfig());
}

void CrossSettingsPage::finish()
{
}
