/***************************************************************************
 *   Copyright (C) 2012 by santiago González                               *
 *   santigoro@gmail.com                                                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.  *
 *                                                                         *
 ***************************************************************************/

#ifndef ARDUINO328_H
#define ARDUINO328_H

#include "avrcomponentpin.h"
#include "mcucomponent.h"
#include "ledsmd.h"
#include "e-source.h"
#include "e-node.h"

//#include "sim_uart_pty.h"

#include "itemlibiface.h"

#if defined(MYSHAREDLIB_LIBRARY)
#  define MYSHAREDLIB_EXPORT Q_DECL_EXPORT
#else
#  define MYSHAREDLIB_EXPORT Q_DECL_IMPORT
#endif

class LibraryItem;

class MYSHAREDLIB_EXPORT Arduino328 : public McuComponent
{
    Q_OBJECT

    public:

        Arduino328( QObject* parent, QString type, QString id );
        ~Arduino328();

        static Component* construct( QObject* parent, QString type, QString id );
        static LibraryItem * libraryItem();

        int getRamValue( int address );
        
        void adcread( int channel );
        
        void paint( QPainter *p, const QStyleOptionGraphicsItem *option, QWidget *widget );
        
        static void adc_hook( struct avr_irq_t* irq, uint32_t value, void* param )
        {
            Q_UNUSED(irq);
            // get the pointer out of param and asign it to AVRComponentPin*
            Arduino328* ptrArduino328 = reinterpret_cast<Arduino328*> (param);

            int channel = int( value/524288 );
            ptrArduino328->adcread( channel );
        }
        
    public slots:
        virtual void remove();

    private:
        void attachPins();
        void initBoard();
        void initBootloader();
        void addPin( QString id, QString type, QString label, int pos, int xpos, int ypos, int angle );

        eSource* m_ground;
        eNode*   m_groundEnode;
        ePin*    m_groundpin;
        LedSmd*  m_boardLed;
        eNode*   m_boardLedEnode;
        Pin*     m_pb5Pin;
        
        QHash<int, AVRComponentPin*> m_ADCpinList;
        
        AvrProcessor m_avr;
        
        //uart_pty_t m_uart_pty;

};

class Arduino328Plugin : public QObject,  ItemLibIface
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "com.SimulIDE.Plugin.ItemLibIface/1.0")
    Q_INTERFACES(ItemLibIface)

    public:
            LibraryItem *libraryItem();
};
#endif
