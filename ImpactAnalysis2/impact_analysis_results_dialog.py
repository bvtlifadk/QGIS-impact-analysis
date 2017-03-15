# -*- coding: utf-8 -*-
"""
/***************************************************************************
 ImpactAnalysisResultsDialog
                                 A QGIS plugin
 asd
                             -------------------
        begin                : 2017-01-22
        git sha              : $Format:%H$
        copyright            : (C) 2017 by asd
        email                : asd
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""

import os
import re
import ast
from PyQt4        import QtGui, uic, QtXml
from PyQt4.QtSql  import QSqlDatabase,QSqlQueryModel
from PyQt4.QtCore import pyqtSignal, pyqtSlot, QSettings, Qt, QVariant, QFile, QIODevice, QModelIndex
from qgis.gui     import QgsMessageBar,QgsMapTool
from qgis.core    import *
from qgis.utils   import iface
from impact_analysis2_tr import tr

FORM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'impact_analysis_results_dialog_base.ui'))

class ImpactAnalysisResultsDialog(QtGui.QDialog, FORM_CLASS):

    def __init__(self, parent=None, pid=None, wkt=None, ):
        """Constructor."""
        super(ImpactAnalysisResultsDialog, self).__init__(parent)
        self.setupUi(self)

        # Makes a number of functions and common data visible from the parent dialog        
        self.parent = parent
        
        # Final setup of GUI.........
        
        # Create action group for button "Zoom"
        self.agZoomObj = QtGui.QActionGroup(self,exclusive=True)
        self.acEntire = self.agZoomObj.addAction(QtGui.QAction(tr(u'To entire object'),self,checkable=True))
        self.acOverlap = self.agZoomObj.addAction(QtGui.QAction(tr(u'Only to overlap'),self,checkable=True))

        # Create sub menu for button "Zoom"
        self.pmZoomobj = QtGui.QMenu(self)
        self.pmZoomobj.addActions(self.agZoomObj.actions());
        self.acEntire.setChecked(True)

        # Attach menu to toolbutton and set style for button 
        self.pbZoomobj.setMenu(self.pmZoomobj)
        self.pbZoomobj.setPopupMode(QtGui.QToolButton.MenuButtonPopup)
        self.pbZoomobj.setToolButtonStyle(Qt.ToolButtonTextOnly)

        # Connect signal and slot for action group
        self.agZoomObj.triggered.connect(self.on_agZoomObj_triggered) 

        # Set intinil state of buttons to disabled
        self.pbCopy.setEnabled(False)
        self.pbWeblink.setEnabled(False)
        self.pbShowLayer.setEnabled(False)
        self.pbZoomobj.setEnabled(False)
        
    def loadtree(self,geom,epsg,pid,profilename,buffervalue):    

        epsg = self.xuni(epsg)
        pid = self.xuni(pid)
        profilename = self.xuni(profilename)
        
        # Create profile model
        if self.parent.dbmeta.isOpen():

            # Create model for treeview   
            model = QtGui.QStandardItemModel()
            model.setHorizontalHeaderLabels(['Identification'])

            # Find treeview widget from dialog            
            view = self.twResult
            view.setSelectionBehavior(QtGui.QAbstractItemView.SelectRows)
            view.clicked.connect(self.on_viewClicked)

            # Set model and looks for treeview
            view.setModel(model)
            view.setUniformRowHeights(True)
            view.setAlternatingRowColors(True)
            view.header().setStretchLastSection(True)
            view.setEditTriggers(QtGui.QAbstractItemView.NoEditTriggers)

            # Fetch profile data from database
            profilemodel = QSqlQueryModel()
            profilemodel.setQuery('select * from "' + self.parent.config['db_schema'] + '"."profiles_layers_view" where pid = ' + str(pid),self.parent.dbmeta)
            
            # Create root item
            profile = QtGui.QStandardItem(tr(u'{} ({} layers)').format(profilename,profilemodel.rowCount()))

            # Get profile link (if it can be retrieved (no of layers > 0)
            if profilemodel.rowCount() > 0:
                profile.setData (u'p|' + self.xuni(profilemodel.record(0).value('profile_link')) + u'|||')
            else:
                profile.setData (u'p||||')

            # Create root item          
            model.appendRow(profile)

            # rowcounter layers with non-zero conflicts 
            nextRow = 0            

            # Iterate through layers in selected profile.....
            for i in range(profilemodel.rowCount()):                   

                # Fetch record nr. i
                r = profilemodel.record(i)

                # Rowcount default (-1 --> db not open)
                rc = -1
                
                # Open or reconnect database for layer
                dbl = self.parent.connectDatabase ('c'+str(r.value('cid')), r.value('servertypename'), r.value('host'),  r.value('port'), r.value('username'), r.value('password'), r.value('database'), r.value('serverconnection'))
                if not dbl is None:

                    # Create wkt string for layer query 
                    # (it has to be converted for each layer - they might have different projections)
                    wkt = self.parent.cnvobj2wkt(geom,epsg,r.value('epsg'))

                    # Fetch layerdata from database
                    layermodel = QSqlQueryModel()

                    # Generate SQL statement
                    sel1 = r.value('sql_detail').format(r.value('profilename'),r.value('layername'),r.value('compoundid'),r.value('linkid'),r.value('geomid'),r.value('schemaname'),r.value('tablename'))
                    sel2 = r.value('sql_filter').format(wkt,r.value('epsg'),buffervalue,r.value('geomid'))
                    sel = sel1 + u' where '+ sel2

                    # Execute SQL and create layermodel content
                    layermodel.setQuery(sel,dbl)
                    rc = layermodel.rowCount()

                    # Create stub QStandardItem for layer
                    lName = QtGui.QStandardItem(tr(u'{} ({} overlaps)').format(r.value('layername'),rc))           
                    lName.setData (u'l|' + self.xuni(r.value('layerlink'))+ u'|' + self.xuni(r.value('qlr_file')) + u'||')

                    for j in range(rc): 

                        # Fetch record nr. j
                        q = layermodel.record(j)

                        # Append data to lName item
                        li = QtGui.QStandardItem(q.value('layerid'))
                        li.setData(u'i|'+self.xuni(q.value('link')) + '|' + self.xuni(r.value('qlr_file')) + '|' + self.xuni(q.value('wkt_geom')) + '|' + self.xuni(r.value('epsg')))
                        lName.appendRow(li)

                #Append layerinfo to profile item        
                if rc > 0:
                    lName.setBackground(QtGui.QColor(255,230,230))
                    lName.sortChildren(0)
                    profile.insertRow(nextRow,lName)
                    nextRow = nextRow + 1
                elif rc == 0:
                    profile.appendRow(lName)
                else:
                    pass # db not found
        
        view.expandToDepth(0)

    # User interface events...............
            
    def on_viewClicked(self,index):
        item = self.twResult.model().itemFromIndex(index);

        #Fetch associated data into list variable "txt"
        txt = item.data().split('|')

        # Set Copy button
        self.pbCopy.setEnabled(True)

        # Set Weblink button
        http = txt[1]
        self.pbWeblink.setEnabled(self.is_http_url(http) or os.path.isfile(http))

        # Set Show layer button
        self.pbShowLayer.setEnabled(txt[0] != 'p' and os.path.isfile(txt[2]))
        
        # Set Zoom button
        self.pbZoomobj.setEnabled(txt[0] == 'i')
    
    def on_agZoomObj_triggered(self, action):
        self.on_pbZoomobj_clicked()
        
    @pyqtSlot()     
    def on_pbCopy_clicked(self):

        # Format
        st = u"{}\t{}\t{}\n"

        # Headerline        
        s = st.format('layer','id','link')

        #Fetch selected row
        index = self.twResult.selectedIndexes()[0]

        #Fetch associated data into list variable "txt"
        itm = index.model().itemFromIndex(index)
        txt = itm.data().split('|')

        if txt[0] == 'p':
        
            #Fetch all conflict data
        
            # Iterate Layers 
            for l in range(itm.rowCount()): 
                li = itm.child(l,0)
                ltxt = li.text()
                # Iterate items in layers
                for i in range(li.rowCount()): 
                    ii = li.child(i,0)
                    itxt = ii.data().split('|')
                    s += st.format(ltxt,ii.text(),itxt[1])

        if txt[0] == 'l':
        
            #Fetch conflict data in specific layer
        
            ltxt = itm.text()
            # Iterate items in layers
            for i in range(itm.rowCount()): 
                ii = itm.child(i,0)
                itxt = ii.data().split('|')
                s += st.format(ltxt,ii.text(),itxt[1])

        if txt[0] == 'i':
        
            #Fetch conflict data for specific item
        
            ltxt = itm.parent().text()
            itxt = itm.data().split('|')  
            s += st.format(ltxt,itm.text(),itxt[1])

        # Copy to Clipboard                
        cb = QtGui.QApplication.clipboard()
        cb.setText(s)
        self.parent.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'Data copied to the clipboard; change to the desired program and use Ctrl+V'),QgsMessageBar.INFO,3)
        
    @pyqtSlot()     
    def on_pbZoomobj_clicked(self):

        #Fetch selected row
        index = self.twResult.selectedIndexes()[0]

        #Fetch associated data into list variable "txt"
        txt = index.model().itemFromIndex(index).data().split('|')

        if txt[0] == 'i':

            # Find kort EPSG
            epsg_out = self.parent.iface.mapCanvas().mapRenderer().destinationCrs().authid().replace('EPSG:','')

            # Find konfliktobjekt og konverter til kort EPSG
            geom = self.parent.cnvwkt2obj(txt[3],txt[4],epsg_out)

            # Vis konfliktobjekt på kort
            self.parent.resitem.setMarkerGeom(geom)

            # Modificer om nødvendigt konfliktobjekt til overlap med søgeobjekt
            if self.acOverlap.isChecked() and geom.type() != QGis.Point:
                geom = geom.intersection(self.parent.searchobj.buffer(self.parent.dsbBuffer.value(),12))

            # Buffer af geom for at finde kortstørrelse-rektangel
            bufgeom = geom.buffer(self.parent.config['search_buffer'], 2)
            rect = bufgeom.boundingBox()

            # Find kort
            mc = self.parent.iface.mapCanvas()

            # Sæt extend af kort og refresh
            mc.setExtent(rect)
            mc.refresh()

        else:
            self.parent.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'Can''t zoom to specified item'),QgsMessageBar.CRITICAL,3)
            
    @pyqtSlot()     
    def on_pbShowLayer_clicked(self):
      
        index = self.twResult.selectedIndexes()[0]
        txt = index.model().itemFromIndex(index).data().split('|')

        if txt[0] != 'p':
            qlr_file = txt[2]
            if not self.load_qlr_file (qlr_file):
                self.parent.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'Can''t open qlr-file: "{}"'.format(qlr_file)),QgsMessageBar.CRITICAL,3)
        else:
            self.parent.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'Can''t load layers from specified item'),QgsMessageBar.CRITICAL,3)

    @pyqtSlot()     
    def on_pbWeblink_clicked(self):
        index = self.twResult.selectedIndexes()[0]
        txt = index.model().itemFromIndex(index).data().split('|')
        http = txt[1]
        if self.is_http_url(http) or os.path.isfile(http):
            os.startfile(http)
        else:
            self.parent.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'The supplied link: "{}" is neither a HTTP address nor a file reference'.format(http)),QgsMessageBar.CRITICAL,3)

                
    def load_qlr_file(self, path):

        ret = False
        group = QgsLayerTreeGroup()
        f = QFile(path)

        if f.open(QIODevice.ReadOnly):
            doc = QtXml.QDomDocument()
            if doc.setContent( f.readAll() ):
                QgsLayerDefinition.loadLayerDefinition(doc, group)
                nodes = group.children()
                for n in nodes:
                    group.takeChild(n)
                    QgsProject.instance().layerTreeRoot().insertChildNodes(0, nodes)
                ret = True
            f.close
        return ret
            
    def is_http_url(self,s):
        if re.match('https?://(?:www)?(?:[\w-]{2,255}(?:\.\w{2,6}){1,2})(?:/[\w&%?#-]{1,300})?',s):
            return True
        else:
            return False      

    def xuni(self,s):
        return u'' if s is None else unicode(s)        
        