# SimulIDE

Electronic Circuit Simulator

SimulIDE is a simple real time electronic circuit simulator.

It's intended for general purpose electronics and microcontroller simulation, supporting PIC and AVR.

PIC simulation is provided by gpsim and avr simulation by simavr.

This is not an accurate simulator for circuit analisis, it aims to be the fast, simple and easy to use, so this means simple and not very accurate electronic models and limited features.

Intended for hobbist or students to learn and experiment with simple circuits.

## Building SimulIDE:

You need several dependencies:
 - qt5
 - qt serialport
 - freeglut3
 - simavr
 - gpsim

Once installed:

```
$ cd build
$ qmake .
$ make
```

## Building plugins:

Components like arduino are provided as plugins

```
$ cd plugins
$ qmake .
$ make
$ cd avr
$ qmake .
$ make
$ cd ..
$ cd arduino
$ qmake .
$ make
```

## Running SimulIDE:

You need to copy all necessary files to release directory

```
cd release/SimulIDE_<ersion>-<arch>
mkdir plugins
cp ../../plugins/arduino/Arduino328plugin/Arduino328plugin_0.3.1-Lin64/libarduino328plugin.so plugins/
cp ../../plugins/avr/AVRplugin/AVRplugin_0.3.1-Lin64/libavrplugin.so plugins/
cp ../../plugins/arduino/Arduino328plugin/data/ data
cp -r ../../plugins/arduino/Arduino328plugin/data/ data
cp -r ../../plugins/arduino/Arduino328plugin/examples examples
```

Now you can run program

```
./SimulIDE_0.3.1 
```
