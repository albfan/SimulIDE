include( ../commonplugin.pro )

TARGET  = $$qtLibraryTarget(avrplugin)


SOURCES =   avrcomponent.cpp \
            ../avr_common/avrcomponentpin.cpp \
            ../avr_common/avrprocessor.cpp \
            
HEADERS =   avrcomponent.h \
            ../avr_common/avrcomponentpin.h \
            ../avr_common/avrprocessor.h \
            
INCLUDEPATH += ../avr_common \
            ../avr_common/simavr/sim 

DESTDIR = AVRplugin/AVRplugin_$$VERSION-$$_ARCH$$_BITS

LIBS  += ../avr_common/simavr/lib-$$_ARCH$$_BITS/libsimavr.a

message( $$_ARCH )



