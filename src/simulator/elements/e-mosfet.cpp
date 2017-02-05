/***************************************************************************
 *   Copyright (C) 2016 by santiago González                               *
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

#include "e-mosfet.h"
#include <QDebug>
#include <math.h>   // fabs(x,y

eMosfet::eMosfet( std::string id )
    : eResistor( id )
{
    m_resist = high_imp;
    m_RDSon  = 1;
    m_Gth    = 3;
    
    m_DScurrent = cero_doub;
    m_lastDScurrent = cero_doub;
    m_lastGateV = cero_doub;
    m_dewltaCurr = 0;
    m_converged = true;
    
    m_ePin.resize(3);
}
eMosfet::~eMosfet(){}

void eMosfet::initialize()
{
    m_DScurrent = cero_doub;
    m_lastDScurrent = cero_doub;
    m_lastGateV = cero_doub;
    m_dewltaCurr = 0;
    m_converged = true;
    
    if( (m_ePin[0]->isConnected()) 
      & (m_ePin[1]->isConnected())
      & (m_ePin[2]->isConnected()) ) 
    {
        m_ePin[0]->getEnode()->addToNoLinList(this);
        m_ePin[1]->getEnode()->addToNoLinList(this);
        m_ePin[2]->getEnode()->addToNoLinList(this);
    }
    eResistor::initialize();
}

void eMosfet::setVChanged()
{
    double Vgs = m_ePin[2]->getVolt()-m_ePin[1]->getVolt();
    double Vds = m_ePin[0]->getVolt()-m_ePin[1]->getVolt();
    double GateV = Vgs - m_Gth;
    
    qDebug() <<" ";
    qDebug() << QString::fromStdString(m_elmId)<<"STAGE "<<m_converged;
    
    if( Vds < 0 )
    {
        //if( DScurrent < 1e-6 )  DScurrent = 0;
        m_DScurrent = 0;
        m_ePin[0]->stampCurrent( 0 );
        m_ePin[1]->stampCurrent( 0 );

        return;
    }
    if( GateV < 0 )   GateV = cero_doub;
    if( Vds > GateV ) Vds   = GateV;
    
    double DScurrent = (GateV*Vds - (Vds*Vds)/2)/(m_RDSon*7);
    
    qDebug() << "this current calc = "<< DScurrent;
    qDebug() << "last current real = "<< m_DScurrent;
    
    if( fabs(DScurrent-m_DScurrent)<1e-5 )
    {
        qDebug() <<"CONVERGED:           ";
        m_converged = true;
        return;
    }
    double lastDscurrent = DScurrent;
    
    if( m_converged )                  // First step after a convergence
    {
        m_totalInc = (DScurrent - m_DScurrent);
        m_dewltaCurr = m_totalInc/1e6;
        DScurrent = m_DScurrent + m_dewltaCurr;
        m_converged = false;
    }
    else
    {
        double dewltaCurr = m_lastDScurrent - DScurrent;
        double deltaRatio = dewltaCurr/m_dewltaCurr;
        
        //qDebug() << "last current calc = "<< m_lastDScurrent;
        //qDebug() << "this delta current= "<< dewltaCurr;
        //qDebug() << "last delta current= "<< m_dewltaCurr;
        //qDebug() << "last    m_totalInc= "<< m_totalInc;
        //qDebug() << "deltaRatio        = "<< deltaRatio;
        
        DScurrent = m_DScurrent + 1*(DScurrent - m_DScurrent)/(deltaRatio+1);
        
        //qDebug() << "new  current real = "<<DScurrent;
        m_converged = true;
        
        //if( fabs(DScurrent-m_DScurrent)<1e-5 ) return;
    }
    if( DScurrent < 0 ) DScurrent = 0;
    if( DScurrent != m_DScurrent)
    {
        //if( DScurrent < 1e-6 )  DScurrent = 0;
        m_DScurrent = DScurrent;
        m_ePin[0]->stampCurrent(-DScurrent );
        m_ePin[1]->stampCurrent( DScurrent );
    }
m_lastDScurrent = lastDscurrent;
    
    /*
    int state;
    
    if( GSVolt < 3 )                                          // Oppened
    {
        state    = 0;
        m_deltaV = 0;
        m_resist = high_imp;
    }
    else                                                       // Closed
    {
        state    = 1;                                           // ohmic
        m_resist = m_RDSon;
        
        double DSVolt = m_ePin[0]->getVolt()-m_ePin[1]->getVolt();
        double deltaV = DSVolt-( GSVolt - m_vTh );
        
        if( deltaV < 0 ) deltaV = 0;
        if( deltaV != m_deltaV )                               
        {
            double current = 0;
            if( deltaV > 0) current = deltaV/m_resist;         // Active

            m_ePin[0]->stampCurrent( current );
            m_ePin[1]->stampCurrent(-current );
        }
        m_deltaV = deltaV;
        //qDebug() << DSVolt << GSVolt;
    }
    if( state != m_state ) 
    {
        eResistor::stamp();
        m_state = state;
    }
    //qDebug() << m_state;
    //qDebug() << ".............";*/
}
