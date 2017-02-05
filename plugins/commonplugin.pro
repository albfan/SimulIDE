
include( ../version )

TEMPLATE = lib


INCLUDEPATH +=  ../../src \
                ../../src/gui \
                ../../src/gui/circuitwidget \
                ../../src/gui/circuitwidget/components \
                ../../src/gui/circuitwidget/components/mcu \
                ../../src/gui/oscopewidget \
                ../../src/gui/plotterwidget \
                ../../src/gui/terminalwidget \
                ../../src/gui/QPropertyEditor \
                ../../src/gui/editorwidget \
                ../../src/gui/editorwidget/findreplacedialog \
                ../../src/simulator \
                ../../src/simulator/elements \
                ../../src/simulator/elements/processors \
                

OBJECTS_DIR = build
MOC_DIR     = build

CONFIG  += plugin
CONFIG  += qt

QT += concurrent
QT += widgets
QT += xml
QT += gui

DEFINES += MYSHAREDLIB_LIBRARY

QMAKE_CFLAGS_SHLIB += -fpic
