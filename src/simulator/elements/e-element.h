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

#ifndef EELEMENT_H
#define EELEMENT_H

#include <string>
#include "e-pin.h"
#include <QPointer>

class eElement
{
    public:
    eElement( std::string id=0 );
        virtual ~eElement();

        virtual void initEpins();
        virtual void setNumEpins( int n );

        virtual ePin* getEpin( int pin );
        virtual ePin* getEpin( QString pinName );
        
        virtual void setEpin( int num, ePin* pin );

        std::string getId(){ return m_elmId; }

        virtual void initialize(){;}
        virtual void stamp(){;}

        virtual void updateStep(){;}
        virtual void setVChanged(){;}
        
        virtual bool converged() { return m_converged; }

        static constexpr double cero_doub = 1e-14;
        static constexpr double high_imp = 1e14;
        static constexpr double digital_high = 5.0;
        static constexpr double digital_low = 0.0;
        static constexpr double digital_threshold = 2.5;


    protected:
        std::vector<ePin*> m_ePin;

        std::string m_elmId;
        
        bool m_converged;
};

#endif

