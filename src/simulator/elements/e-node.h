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

#ifndef ENODE_H
#define ENODE_H

#include "e-pin.h"
#include "e-element.h"

class eNode
{
    public:
        eNode( QString id );
        ~eNode();

        QString itemId();

        //void connectorChanged( int c ); // Keep the num of connectors using this eNode
        void addEpin( ePin* epin );
        void addSubEpin( ePin* epin );
        void remEpin( ePin* epin );

        void addToChangedFast( eElement* el );
        void remFromChangedFast( eElement* el );
        
        void addToChangedSlow( eElement* el );
        void remFromChangedSlow( eElement* el );
        
        void addToNoLinList( eElement* el );
        void remFromNoLinList( eElement* el );

        void stampCurrent( ePin* epin, double data );
        void stampAdmitance( ePin* epin, double data );

        void pinChanged( ePin* epin, int enodeNum );

        int  getNodeNumber();
        void setNodeNumber( int n );

        double getVolt();
        void  setVolt( double volt );
        
        bool needFastUpdate() { return m_needFastUpdate; }

        void initialize();
        void stampMatrix();
        void setSingle( bool single ){ m_single = single; }      // This eNode can calculate it's own Volt

        QList<ePin*> getEpins();
        QList<ePin*> getSubEpins();

    private:
        QList<ePin*>     m_ePinList;
        QList<ePin*>     m_ePinSubList;  // Used by Connector to find connected dpins
        QList<eElement*> m_changedFast;
        QList<eElement*> m_changedSlow;
        QList<eElement*> m_nonLinear;

        QHash<ePin*, double> m_admitList;
        QHash<ePin*, double> m_currList;
        QHash<ePin*, int>    m_nodeList;
        //std::Hash<ePin*, double> m_pru;
        
        QHash<int, double> admit;
        //double m_totalCurr;
        double m_totalAdmit;

        double m_volt;
        int   m_nodeNum;
        int   m_numCons;

        QString m_id;
        
        bool m_needFastUpdate;
        bool m_currChanged;
        bool m_admitChanged;
        bool m_changed;
        bool m_single;
};
#endif


