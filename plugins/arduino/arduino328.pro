include( ../commonplugin.pro )

TARGET  = $$qtLibraryTarget(arduino328plugin)


SOURCES =   arduino328.cpp \
            ../avr_common/avrcomponentpin.cpp \
            ../avr_common/avrprocessor.cpp 
            
HEADERS =   arduino328.h \
            ../avr_common/avrcomponentpin.h \
            ../avr_common/avrprocessor.h 

INCLUDEPATH += ../avr_common \
               /usr/include/simavr 

DESTDIR = Arduino328plugin/Arduino328plugin_$$VERSION-$$_ARCH$$_BITS

LIBS  += /usr/lib/libsimavr.a

message( $$_ARCH $$_BITS )



