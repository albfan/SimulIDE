include( ../commonplugin.pro )

TARGET  = $$qtLibraryTarget(avrplugin)


SOURCES =   avrcomponent.cpp \
            ../avr_common/avrcomponentpin.cpp \
            ../avr_common/avrprocessor.cpp \
            
HEADERS =   avrcomponent.h \
            ../avr_common/avrcomponentpin.h \
            ../avr_common/avrprocessor.h \
            
INCLUDEPATH += ../avr_common \
            /usr/include/simavr

DESTDIR = AVRplugin/AVRplugin_$$VERSION-$$_ARCH$$_BITS

LIBS  += /usr/lib/libsimavr.a

message( $$_ARCH )



