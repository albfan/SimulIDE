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

#include "terminalwidget.h"
#include "baseprocessor.h"

TerminalWidget* TerminalWidget::m_pSelf = 0l;

TerminalWidget::TerminalWidget( QWidget *parent )
    : QWidget( parent )
    ,m_verticalLayout(this)
    ,m_horizontLayout()
    ,m_sendText(this)
    ,m_sendValue(this)
    ,m_outPanel(this)
{
    m_pSelf = this;
    this->setVisible( false );
    
    setMinimumSize(QSize(200, 200));
    
    m_verticalLayout.setObjectName(tr("verticalLayout"));
    m_verticalLayout.setContentsMargins(0, 0, 0, 0);
    m_verticalLayout.setSpacing(0);

    QLabel* sendTextLabel = new QLabel(this);
    sendTextLabel->setText("Send Text:");
    m_sendText.setMaxLength( 50 );
    
    QLabel* sendValueLabel = new QLabel(this);
    sendValueLabel->setText("    Send Value:");
    m_sendValue.setMaxLength( 3 );
    m_sendValue.setMaximumWidth(40);
    m_sendValue.setValidator( new QIntValidator(0, 255, this) );
    
    m_horizontLayout.addWidget( sendTextLabel );
    m_horizontLayout.addWidget( &m_sendText );
    m_horizontLayout.addWidget( sendValueLabel );
    m_horizontLayout.addWidget( &m_sendValue );
    
    m_verticalLayout.addLayout( &m_horizontLayout );
    m_verticalLayout.addWidget( &m_outPanel );
    
    connect( &m_sendText, SIGNAL(returnPressed()),
                    this, SLOT(onTextChanged()));
                    
    connect( &m_sendValue, SIGNAL(returnPressed()),
                    this, SLOT(onValueChanged()));
}
TerminalWidget::~TerminalWidget() { }

void TerminalWidget::onTextChanged()
{
    QString text = m_sendText.text();
    //qDebug() << text ;
    
    QByteArray array = text.toLatin1();
    
    for( int i=0; i<array.size(); i++ )
        BaseProcessor::self()->uartIn( array.at(i) );

    //m_sendText.clear();
    m_outPanel.appendText( "Sent: \""+text+"\"\n" );
}

void TerminalWidget::onValueChanged()
{
    QString text = m_sendValue.text();

    BaseProcessor::self()->uartIn( text.toInt() );

    m_sendText.clear();
    
    m_outPanel.appendText( "Sent: "+text+"\n" );
}


#include "moc_terminalwidget.cpp"
