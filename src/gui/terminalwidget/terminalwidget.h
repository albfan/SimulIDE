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

#ifndef TERMINALWIDGET_H
#define TERMINALWIDGET_H

#include <QtWidgets>

#include "outpaneltext.h"

class TerminalWidget : public QWidget
{
    Q_OBJECT

    public:
        TerminalWidget( QWidget *parent = 0);
        ~TerminalWidget();
        
 static TerminalWidget* self() { return m_pSelf; }
 
    public slots:
        void onTextChanged();
        void onValueChanged();

    private:
 static TerminalWidget* m_pSelf;
 
        QVBoxLayout   m_verticalLayout;
        QHBoxLayout   m_horizontLayout;
        QLineEdit     m_sendText;
        QLineEdit     m_sendValue;
        OutPanelText  m_outPanel;
};

#endif
