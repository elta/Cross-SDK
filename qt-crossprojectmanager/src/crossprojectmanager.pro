TARGET = CrossProjectManager
TEMPLATE = lib
QT += network
DEFINES += CROSSPROJECTMANAGER_LIBRARY

# CrossProjectManager files

SOURCES += crossprojectmanagerplugin.cpp \
    kit/crosskit.cpp \
    crosssdkinfo.cpp \
    device/crossqemumanager.cpp \
    buildrun/crossrunconfiguration.cpp \
    buildrun/crossruncontrol.cpp \
    buildrun/crossruncontrolfactory.cpp \
    buildrun/crossrunconfigurationfactory.cpp \
    buildrun/crossdeploystep.cpp \
    buildrun/crossdeployconfiguration.cpp \
    buildrun/crossdeployconfigurationfactory.cpp \
    buildrun/crossdeploystepfactory.cpp \
    device/mountmanager.cpp \
    crosssettingspage.cpp \
    crosssettingswidget.cpp \
    wizard/qtwizard.cpp \
    wizard/qtprojectparameters.cpp \
    wizard/crosslinuxprojectwizard.cpp \
    wizard/crosslinuxwizarddialog.cpp \
    wizard/configpage.cpp \
    buildrun/crossapprunner.cpp \
    buildrun/crossdebugsupport.cpp \
    sshsupport/sshmanager.cpp \
    sshsupport/packageuploader.cpp \
    buildrun/crossdeployhelper.cpp \
    device/crossdevice32bit.cpp \
    device/crossdevice32bitfactory.cpp \
    device/crossdevice64bitfactory.cpp \
    device/crossdevice64bit.cpp \
    toolchain/crosslinuxtoolchain32bit.cpp \
    toolchain/crosslinuxtoolchain32bitfactory.cpp \
    toolchain/crosslinuxtoolchain64bitfactory.cpp \
    toolchain/crosslinuxtoolchain64bit.cpp

HEADERS += crossprojectmanagerplugin.h\
        crossprojectmanager_global.h\
        crossprojectmanagerconstants.h \
    kit/crosskit.h \
    device/crossqemuruntime.h \
    crosssdkinfo.h \
    device/crossqemumanager.h \
    buildrun/crossrunconfiguration.h \
    buildrun/crossruncontrol.h \
    buildrun/crossruncontrolfactory.h \
    buildrun/crossrunconfigurationfactory.h \
    buildrun/crossdeploystep.h \
    buildrun/crossdeployconfiguration.h \
    buildrun/crossdeployconfigurationfactory.h \
    buildrun/crossdeploystepfactory.h \
    device/mountmanager.h \
    crosssettingspage.h \
    crosssettingswidget.h \
    wizard/qtwizard.h \
    wizard/qtprojectparameters.h \
    wizard/crosslinuxprojectwizard.h \
    wizard/crosslinuxwizarddialog.h \
    wizard/configpage.h \
    buildrun/crossapprunner.h \
    buildrun/crossdebugsupport.h \
    sshsupport/sshmanager.h \
    sshsupport/packageuploader.h \
    buildrun/crossdeployhelper.h \
    device/crossdevice32bit.h \
    device/crossdevice32bitfactory.h \
    device/crossdevice64bitfactory.h \
    device/crossdevice64bit.h \
    toolchain/crosslinuxtoolchain32bit.h \
    toolchain/crosslinuxtoolchain32bitfactory.h \
    toolchain/crosslinuxtoolchain64bitfactory.h \
    toolchain/crosslinuxtoolchain64bit.h

# Qt Creator linking

QTCREATOR_SOURCES = $$(QTC_SOURCE)

#QTCREATOR_SOURCES = IDE_SOURCE_TREE

isEmpty(PROVIDER):PROVIDER = $$(PROVIDER)

## set the QTC_BUILD environment variable to override the setting here
IDE_BUILD_TREE = $$(QTC_BUILD)

include($$QTCREATOR_SOURCES/src/qtcreatorplugin.pri)
include($$QTCREATOR_SOURCES/src/plugins/coreplugin/coreplugin.pri)
include(crossprojectmanager_dependencies.pri)

LIBS += -L$$IDE_PLUGIN_PATH/QtProject

OTHER_FILES +=

FORMS += \
    device/crossqemuwidget.ui \
    crosssettingswidget.ui \
    wizard/configpage.ui

destinydir=$${IDE_BUILD_TREE}/share/qtcreator/templates/wizards
templatewizard.path	=$$destinydir
templatewizard.files	+= ./wizard/*
INSTALLS += templatewizard

RESOURCES += \
    Resource.qrc
