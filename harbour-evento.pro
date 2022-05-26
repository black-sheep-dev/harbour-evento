# VERSION
VERSION = 0.1.0
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

TARGET = harbour-evento
DEFINES += APP_TARGET=\\\"$$TARGET\\\"

CONFIG += link_pkgconfig sailfishapp
PKGCONFIG += nemonotifications-qt5

SOURCES += src/harbour-evento.cpp \
    src/eventsmodel.cpp \
    src/sortfiltermodel.cpp

DISTFILES += qml/harbour-evento.qml \
    qml/cover/CoverPage.qml \
    qml/dialogs/EditEventDialog.qml \
    qml/pages/MainPage.qml \
    qml/pages/AboutPage.qml \
    rpm/harbour-evento.changes.in \
    rpm/harbour-evento.changes.run.in \
    rpm/harbour-evento.spec \
    rpm/harbour-evento.yaml \
    translations/*.ts \
    harbour-evento.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 512x512

include(translations/translations.pri)

icons.files = icons/*.svg
icons.path = $$INSTALL_ROOT/usr/share/harbour-evento/icons

INSTALLS += icons

HEADERS += \
    src/eventsmodel.h \
    src/sortfiltermodel.h