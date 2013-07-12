#include "crosssettingswidget.h"
#include "ui_crosssettingswidget.h"
#include "crosssdkinfo.h"
#include <QTextStream>
namespace CrossProjectManager{
namespace Internal{

CrossSettingsWidget::CrossSettingsWidget(QWidget *parent) :
    QDialog(parent),
    m_ui(new Ui::CrossSettingsWidget)
{
    m_ui->setupUi(this);
    setConfig(CrossSDKInfo::instance().getConfig());
    updateGUI();
    connectSingals();

    //set defult target
    {
        m_ui->comboBox_target->addItem(QLatin1String("O32(Run on 64 bit QEMU)"),QVariant(int(_O32RunOn64)));
        m_ui->comboBox_target->addItem(QLatin1String("O32(Run on 32 bit QEMU)"),QVariant(int(_O32RunOn32)));
        m_ui->comboBox_target->addItem(QLatin1String("N32"),QVariant(int(_N32RunOn64)));
        m_ui->comboBox_target->addItem(QLatin1String("N64"),QVariant(int(_N64RunOn64)));
        QemuType defultTarget=CrossSDKInfo::instance().getQemuType();
        int index=m_ui->comboBox_target->findData(QVariant(int(defultTarget)));
        m_ui->comboBox_target->setCurrentIndex(index);
    }
    connect(m_ui->comboBox_target,SIGNAL(currentIndexChanged(int)),this,SLOT(updateTarget()));
}

CrossSettingsWidget::~CrossSettingsWidget()
{
    delete m_ui;
}

void CrossSettingsWidget::setConfig(QMap<QString, QString> config)
{
    m_config=config;
}

QMap<QString, QString> CrossSettingsWidget::getConfig() const
{
    return m_config;
}

//slots....
void CrossSettingsWidget::sdkLocationEditingFinished()
{
    Utils::FileName dir = Utils::FileName::fromUserInput(m_ui->lineEdit_root->text());
    updateSDK(dir.toString());
    updateGUI();
}

void CrossSettingsWidget::gnu32LocationEditingFinished()
{
    m_config[QLatin1String("gnu32")]=m_ui->lineEdit_gnu32->text();
    updateGUI();
}

void CrossSettingsWidget::gnu64LocationEditingFinished()
{
    m_config[QLatin1String("gnu64")]=m_ui->lineEdit_gnu64->text();
    updateGUI();
}

void CrossSettingsWidget::llvmLocationEditingFinished()
{
    m_config[QLatin1String("llvm")]=m_ui->lineEdit_llvm->text();
    updateGUI();
}

void CrossSettingsWidget::qemuLocationEditingFinished()
{
    m_config[QLatin1String("qemu")]=m_ui->lineEdit_qemu->text();
    updateGUI();
}

void CrossSettingsWidget::gnuLinuxLocationEditingFinished()
{
    m_config[QLatin1String("gnulinux")]=m_ui->lineEdit_gnulinux->text();
    updateGUI();
}

//slots too...damn too much!!
void CrossSettingsWidget::browseSDKLocation()
{
    Utils::FileName dir=getLocation(QLatin1String("SDK ROOT:"));
    updateSDK(dir.toString());
    updateGUI();
}

void CrossSettingsWidget::browseGnu32Location()
{
    Utils::FileName dir=getLocation(QLatin1String("Mipsel-linux-gnu"));
    m_config[QLatin1String("gnu32")]=dir.toString();
    updateGUI();
}

void CrossSettingsWidget::browseGnu64Location()
{
    Utils::FileName dir=getLocation(QLatin1String("Mips64el-linux-gnu"));
    m_config[QLatin1String("gnu64")]=dir.toString();
    updateGUI();
}

void CrossSettingsWidget::browsellvmLocation()
{
    Utils::FileName dir=getLocation(QLatin1String("llvm"));
    m_config[QLatin1String("llvm")]=dir.toString();
    updateGUI();
}

void CrossSettingsWidget::browseQemuLocation()
{
    Utils::FileName dir=getLocation(QLatin1String("Qemu"));
    m_config[QLatin1String("qemu")]=dir.toString();
    updateGUI();
}

void CrossSettingsWidget::browseGnuLinuxLocation()
{
    Utils::FileName dir=getLocation(QLatin1String("Gnu-linux"));
    m_config[QLatin1String("gnulinux")]=dir.toString();
    updateGUI();
}

void CrossSettingsWidget::updateTarget()
{
    int index=m_ui->comboBox_target->currentIndex();
    QVariant data=m_ui->comboBox_target->itemData(index);
    bool ok;
    int type=data.toInt(&ok);
    if(!ok){
        qWarning("Undefined type");
        return;
    }
    CrossSDKInfo::instance().setQemuType(QemuType(type));
}



//helper function
void CrossSettingsWidget::updateGUI()
{
    m_ui->lineEdit_root->setText(m_config[QLatin1String("sdkroot")]);
    m_ui->lineEdit_gnu32->setText(m_config[QLatin1String("gnu32")]);
    m_ui->lineEdit_gnu64->setText(m_config[QLatin1String("gnu64")]);
    m_ui->lineEdit_llvm->setText(m_config[QLatin1String("llvm")]);
    m_ui->lineEdit_qemu->setText(m_config[QLatin1String("qemu")]);
    m_ui->lineEdit_gnulinux->setText(m_config[QLatin1String("gnulinux")]);
}

void CrossSettingsWidget::connectSingals()
{
    connect(m_ui->pushButton_root,SIGNAL(clicked()),this,SLOT(browseSDKLocation()));
    connect(m_ui->pushButton_gnu32,SIGNAL(clicked()),this,SLOT(browseGnu32Location()));
    connect(m_ui->pushButton_gnu64,SIGNAL(clicked()),this,SLOT(browseGnu64Location()));
    connect(m_ui->pushButton_llvm,SIGNAL(clicked()),this,SLOT(browsellvmLocation()));
    connect(m_ui->pushButton_qemu,SIGNAL(clicked()),this,SLOT(browseQemuLocation()));
    connect(m_ui->pushButton_gnulinux,SIGNAL(clicked()),this,SLOT(browseGnuLinuxLocation()));

    connect(m_ui->lineEdit_root,SIGNAL(textEdited(QString)),this,SLOT(sdkLocationEditingFinished()));
    connect(m_ui->lineEdit_gnu32,SIGNAL(textEdited(QString)),this,SLOT(gnu32LocationEditingFinished()));
    connect(m_ui->lineEdit_gnu64,SIGNAL(textEdited(QString)),this,SLOT(gnu64LocationEditingFinished()));
    connect(m_ui->lineEdit_llvm,SIGNAL(textEdited(QString)),this,SLOT(llvmLocationEditingFinished()));
    connect(m_ui->lineEdit_qemu,SIGNAL(textEdited(QString)),this,SLOT(qemuLocationEditingFinished()));
    connect(m_ui->lineEdit_gnulinux,SIGNAL(textEdited(QString)),this,SLOT(gnuLinuxLocationEditingFinished()));

}

Utils::FileName CrossSettingsWidget::getLocation(QString describeString)
{
    Utils::FileName dir = Utils::FileName::fromString(QFileDialog::getExistingDirectory(this, describeString));
    return dir;
}


QString CrossSettingsWidget::searchKeywords() const
{
    QString rc;
    QTextStream(&rc) << m_ui->label_root->text()
        << ' ' << m_ui->label_gnu32->text()
        << ' ' << m_ui->label_gnu64->text()
        << ' ' << m_ui->label_llvm->text()
        << ' ' << m_ui->label_qemu->text()
        << ' ' << m_ui->label_gnulinux->text();
    rc.remove(QLatin1Char('&'));
    return rc;
}


void CrossSettingsWidget::updateSDK(const QString &sdkRootLocation)
{
    m_config[QLatin1String("sdkroot")] =sdkRootLocation;
    m_config[QLatin1String("gnu32")]   =sdkRootLocation+QLatin1String("/mipsel-linux-gnu");
    m_config[QLatin1String("gnu64")]   =sdkRootLocation+QLatin1String("/mipsel-linux-gnu");
    m_config[QLatin1String("llvm")]    =sdkRootLocation+QLatin1String("/llvm");
    m_config[QLatin1String("qemu")]    =sdkRootLocation+QLatin1String("/qemu");
    m_config[QLatin1String("gnulinux")]=sdkRootLocation+QLatin1String("/gnu-linux");
}

}
}
