
include( version )

TEMPLATE = app

SOURCES += ../src/*.cpp \
    ../src/gui/*.cpp \
    ../src/gui/circuitwidget/*.cpp \
    ../src/gui/circuitwidget/components/*.cpp \
    ../src/gui/circuitwidget/components/mcu/*.cpp \
    ../src/gui/oscopewidget/*.cpp \
    ../src/gui/plotterwidget/*.cpp \
    ../src/gui/terminalwidget/*.cpp \
    ../src/gui/QPropertyEditor/*.cpp \
    ../src/gui/editorwidget/*.cpp \
    ../src/gui/editorwidget/findreplacedialog/*.cpp \
    ../src/simulator/*.cpp \
    ../src/simulator/elements/*.cpp \
    ../src/simulator/elements/processors/*.cpp \

HEADERS += ../src/*.h \
    ../src/gui/*.h \
    ../src/gui/circuitwidget/*.h \
    ../src/gui/circuitwidget/components/*.h \
    ../src/gui/circuitwidget/components/mcu/*.h \
    ../src/gui/oscopewidget/*.h \
    ../src/gui/plotterwidget/*.h \
    ../src/gui/terminalwidget/*.h \
    ../src/gui/QPropertyEditor/*.h \
    ../src/gui/editorwidget/*.h \
    ../src/gui/editorwidget/findreplacedialog/*.h \
    ../src/simulator/*.h \
    ../src/simulator/elements/*.h \
    ../src/simulator/elements/processors/*.h \

INCLUDEPATH += ../src \
    ../src/gui \
    ../src/gui/circuitwidget \
    ../src/gui/circuitwidget/components \
    ../src/gui/circuitwidget/components/mcu \
    ../src/gui/oscopewidget \
    ../src/gui/plotterwidget \
    ../src/gui/terminalwidget \
    ../src/gui/QPropertyEditor \
    ../src/gui/editorwidget \
    ../src/gui/editorwidget/findreplacedialog \
    ../src/simulator \
    ../src/simulator/elements \
    ../src/simulator/elements/processors \
    ../include/simavr/sim \
    #/usr/local/include/gpsim\
    #/usr/include/glib-2.0\
    #/usr/lib/i386-linux-gnu/glib-2.0/include\
    #/usr/lib/x86_64-linux-gnu/glib-2.0/include \
    
#FORMS += ../src/gui/editorwidget/findreplacedialog/*.ui 

QMAKE_CXXFLAGS_RELEASE -= -O
QMAKE_CXXFLAGS_RELEASE -= -O1
QMAKE_CXXFLAGS_RELEASE -= -O2
QMAKE_CXXFLAGS_RELEASE *= -O3
QMAKE_CXXFLAGS += -Wno-unused-parameter

RESOURCES = ../src/application.qrc
# TRANSLATIONS += SimulIDE.ts

QT += concurrent
QT += widgets
QT += xml
QT += gui

CONFIG += qt \
    warn_on \
#    debug
CONFIG += static

CONFIG -= debug_and_release debug_and_release_target

message( "-----------------------------" )
message( "       " $$VERSION $$_ARCH $$_BITS )
message( "-----------------------------" )

BUILD_DIR    = build
INCLUDEPATH += $$BUILD_DIR 
OBJECTS_DIR  = $$BUILD_DIR 
MOC_DIR      = $$BUILD_DIR 

TARGET = ../release/SimulIDE_$$VERSION-$$_ARCH$$_BITS/SimulIDE_$$VERSION


isEqual( _ARCH,"Lin") {
    QMAKE_LFLAGS += -Wl,-export-dynamic
}
 

isEqual( _ARCH,"Win") {
    Release:DESTDIR = ../release
    
    QMAKE_LIBS += -lws2_32
}

