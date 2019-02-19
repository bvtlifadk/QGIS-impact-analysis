# -*- coding: utf-8 -*-
"""
/***************************************************************************
 ImpactAnalysis2DockWidget
                                 A QGIS plugin
 Generates multilayer automated overlays analysis
                             -------------------
        begin                : 2017-03-01
        git sha              : $Format:%H$
        copyright            : (C) 2017 by Bo Victor Thomsen,  Municipality of Frederikssund, Denmark
        email                : bvtho@frederikssund.dk
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
from PyQt4.QtSql  import QSqlDatabase
from PyQt4        import QtGui, uic #, QtXml
from PyQt4.QtCore import pyqtSignal, pyqtSlot, QSettings, Qt
from PyQt4.QtGui import QApplication

from qgis.gui     import QgsMessageBar, QgsMapTool
from qgis.utils   import iface
from qgis.core    import QgsCoordinateReferenceSystem, QgsCoordinateTransform, QgsGeometry, QgsMapLayer
from mapTools     import AddPointTool, CaptureTool
from canvas_items import CanvasItems
from impact_analysis2_tr import tr
from impact_analysis_results_dialog import ImpactAnalysisResultsDialog
import resources


FORM_CLASS, _ = uic.loadUiType(os.path.join(
    os.path.dirname(__file__), 'impact_analysis2_dockwidget_base.ui'))


class ImpactAnalysis2DockWidget(QtGui.QDockWidget, FORM_CLASS):

    closingPlugin = pyqtSignal()

    def __init__(self, parent=None, iface=None):
        """Constructor."""
        super(ImpactAnalysis2DockWidget, self).__init__(parent)

        # Local references to QGIS iface and parent 
        self.iface = iface
        
        # Create (empty) references for search geometry and for "old" search geometry
        self.searchobj = None
        self.searchobj_ref = None      

        # Primary setup of the GUI
        self.setupUi(self)

        # Read settings.....
        self.config = self.readConfig()

        # Set up connection to meta db
        self.dbmeta = self.connectDatabase('meta',self.config['db_type'],self.config['db_host'],self.config['db_port'],self.config['db_username'],self.config['db_password'],self.config['db_database'],self.config['db_connection'])

        # Read rest of settings from meta db
        if not (self.dbmeta is None): 
            self.config.update(self.loadSettings(self.dbmeta,self.config['db_schema'],'settings','base'))

        # Reference to canvas objects "buffer", "search" and "result"
        self.bufitem = CanvasItems(self.iface.mapCanvas(),self.config['buffer_color'],self.config['buffer_style'],self.config['buffer_width'],None,None)
        self.srsitem = CanvasItems(self.iface.mapCanvas(),self.config['search_color'],self.config['search_style'],self.config['search_width'],self.config['search_icon'],self.config['search_size'])
        self.resitem = CanvasItems(self.iface.mapCanvas(),self.config['result_color'],self.config['result_style'],self.config['result_width'],self.config['result_icon'],self.config['result_size']) 
            
        # Final setup of the GUI....................

        # Menu for toolbutton 
        self.pmSearchobj = QtGui.QMenu(self)

        # First set of menu actions (Actiongroup agSearchObj1): Draw polygon .. Previous object
        self.agSearchObj1 = QtGui.QActionGroup(self,exclusive=True)
        self.acPol  = self.agSearchObj1.addAction(QtGui.QAction(QtGui.QIcon(':/plugins/ImpactAnalysis2/icons/Icons8-Ios7-Maps-Polygon.ico'),tr(u'Draw polygon'),self,checkable=True))
        self.acLin  = self.agSearchObj1.addAction(QtGui.QAction(QtGui.QIcon(':/plugins/ImpactAnalysis2/icons/Icons8-Ios7-Maps-Polyline.ico'),tr(u'Draw line'),self,checkable=True))
        self.acPnt  = self.agSearchObj1.addAction(QtGui.QAction(QtGui.QIcon(':/plugins/ImpactAnalysis2/icons/Icons8-Ios7-Maps-Geo-Fence.ico'),tr(u'Draw point'),self,checkable=True))
        self.acAlay = self.agSearchObj1.addAction(QtGui.QAction(QtGui.QIcon(':/plugins/ImpactAnalysis2/icons/Icons8-Ios7-Maps-Layers.ico'),tr(u'Active selection'),self,checkable=True))
        self.acPobj = self.agSearchObj1.addAction(QtGui.QAction(QtGui.QIcon(':/plugins/ImpactAnalysis2/icons/Icons8-Ios7-Maps-Quest.ico'),tr(u'Previous object'),self,checkable=True))
        self.pmSearchobj.addActions(self.agSearchObj1.actions());

        # Menu separator
        self.pmSearchobj.addSeparator()

        # Second set of menu action : Use overlapping objects from administrative layer
        self.acOvl = QtGui.QAction(tr(u'Use as a pointer to administrative layer'),self,checkable=True) 
        self.pmSearchobj.addAction(self.acOvl)

        # connect trigger function for menu
        self.agSearchObj1.triggered.connect(self.on_agSearchObj1_triggered)    
        self.acOvl.triggered.connect(self.on_acOvl_triggered)    

        # Attach menu to search toolbutton and set style for button 
        self.pbSearchobj.setMenu(self.pmSearchobj)
        self.pbSearchobj.setPopupMode(QtGui.QToolButton.MenuButtonPopup)
        self.pbSearchobj.setToolButtonStyle(Qt.ToolButtonTextBesideIcon)
        
        #Fetch data from database
        self.loadProfiles(self.dbmeta,self.config['db_schema'],'profiles',self.cbProfiles)
        
    def unload(self):

        # Cleanup...
        self.bufitem.clearMarkerGeom()
        self.srsitem.clearMarkerGeom()
        self.resitem.clearMarkerGeom()
        
    def closeEvent(self, event):

        self.closingPlugin.emit()
        event.accept()

    # User interface events................................................

    def on_agSearchObj1_triggered_x (self,action):

        if action.isChecked():
            icon = QtGui.QIcon(action.icon())   
            self.pbSearchobj.setIcon (icon)      
            self.pbSearchobj.setText (action.text() + '->[]' if self.acOvl.isChecked() else action.text()) 

    def on_agSearchObj1_triggered(self,action):

        self.on_agSearchObj1_triggered_x(action)
        self.on_pbSearchobj_clicked()        

    def on_acOvl_triggered (self):

        if self.acOvl.isChecked() and self.config['adm_layer']<0:
            self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'Administrative layer not set, action cancelled'),QgsMessageBar.CRITICAL,3)
            self.acOvl.setChecked(False)

        txt = self.pbSearchobj.text().replace("->[]","")
        self.pbSearchobj.setText (txt + '->[]' if self.acOvl.isChecked() else txt)                    

    def geometryAdded(self, geom):
    
        if not geom is None:            

            # Find EPSG projection id
            epsg = self.iface.mapCanvas().mapRenderer().destinationCrs().authid().replace('EPSG:','')    

            # Change geometry to a collection of objects from administrative layer if necessary
            if self.acOvl.isChecked():
                geom = self.convertGeom2AdmCollection (geom,epsg,self.dbmeta, self.config['db_schema'], 'layers',self.config['adm_layer'])
     
            if not geom is None:            

            
                # check and correct buffervalue compared with geometry type
                self.dsbBuffer.setValue(self.checkBufferValue(geom,self.config['buffer_min'],self.dsbBuffer.value()))
                
                # Save geometry object for future reference
                self.searchobj = geom
                
                # Show search object and buffer in map        
                self.srsitem.setMarkerGeom(geom)
                self.bufitem.setMarkerGeomBuffer(geom,self.dsbBuffer.value())
        
                # Set active tool to Pan
                self.iface.actionPan().trigger()
        
                # Create instance of result dialog (All the gooodies start there)
                dlg = ImpactAnalysisResultsDialog(self)
                
                pdict = self.cbProfiles.itemData (self.cbProfiles.currentIndex())
                
                QtGui.QApplication.setOverrideCursor(Qt.WaitCursor)
                dlg.loadtree(geom, epsg, pdict['pid'], pdict['profilename'], self.dsbBuffer.value())
                QApplication.restoreOverrideCursor()

                dlg.show()
                result = dlg.exec_()
        
                # Save search object for furture reference reference
                self.searchobj_ref = self.searchobj
        
                # Cleanup...
                self.bufitem.clearMarkerGeom()
                self.srsitem.clearMarkerGeom()
                self.resitem.clearMarkerGeom()
        
    @pyqtSlot()
    def on_pbSearchobj_clicked(self):

        geoms =  None
        canvas = self.iface.mapCanvas()

        # Which tool is activated ?  
        if self.acPol.isChecked():    # "Draw polygon" is checked
            tool = CaptureTool(canvas, self.geometryAdded, CaptureTool.CAPTURE_POLYGON)
            canvas.setMapTool(tool)        
        elif self.acLin.isChecked():  # "Draw line" is checked
            tool = CaptureTool(canvas, self.geometryAdded, CaptureTool.CAPTURE_LINE)
            canvas.setMapTool(tool)        
        elif self.acPnt.isChecked():  # "Draw point" is checked
            tool = AddPointTool(canvas, self.geometryAdded)
            canvas.setMapTool(tool)        
        elif self.acAlay.isChecked(): # "Use active layer selection" is checked
            layer = self.iface.activeLayer()
            if (layer) and (layer.type() == QgsMapLayer.VectorLayer):
                selection = layer.selectedFeatures()
                if (selection):
                    # Combine geometries in collection
                    for f in selection:
                        if geoms == None:
                            geoms = f.geometry()
                        else:
                            geoms = geoms.combine( f.geometry() )

            if (geoms != None):
                self.geometryAdded(geoms) # Activate the result dialog immediately            
            else:
                self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'No selected vector objects found in active layer'),QgsMessageBar.CRITICAL,3)
                self.on_cbProfiles_currentIndexChanged(self.cbProfiles.currentIndex()) # Leave system in legal state
        elif self.acPobj.isChecked():     # "Use previous search object" is checked
            geoms = self.searchobj_ref
            if (geoms != None):
                self.geometryAdded(geoms) # Activate the result dialog immediately            
            else:
                self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'No existing search object found'),QgsMessageBar.CRITICAL,3)
                self.on_cbProfiles_currentIndexChanged(self.cbProfiles.currentIndex()) # Leave system in legal state
        else:
            # We should never reach this code path...
            self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'Unknown search tool'),QgsMessageBar.CRITICAL,3)
            self.on_cbProfiles_currentIndexChanged(self.cbProfiles.currentIndex()) # Leave system in legal state
        
    @pyqtSlot(int)   
    def on_cbProfiles_currentIndexChanged(self,i):

        #Fetch the dict from the chosen profile
        dict = self.cbProfiles.itemData (i)

        tool = dict['tool']
        searchtype = dict['searchtype']
        buffersize = dict['buffersize']

        # Set buffer value
        self.dsbBuffer.setValue(buffersize)
        
        # Set the appropriate draw action and run the trigger function
        action = self.agSearchObj1.actions()[tool]
        action.setChecked(True)
        self.on_agSearchObj1_triggered_x(action)

        # Set the appropriate searchtype action and run the trigger function
        self.acOvl.setChecked(searchtype == 1)
        self.on_acOvl_triggered()

    # Helper functions....................................................        
        
    def readConfig(self):

        s = QSettings()
        k = unicode(__package__)
        # Read settings values for connection to meta database with additional information
        config = {
            # Settings used for Postgres a.o. database types
            'db_type':       unicode(s.value(k + u'/database/type',       u'QPSQL',                         type=str)),
            'db_host':       unicode(s.value(k + u'/database/host',       u'f-pgsql01.ad.frederikssund.dk', type=str)),
            'db_database':   unicode(s.value(k + u'/database/database',   u'conflict',                      type=str)),
            'db_username':   unicode(s.value(k + u'/database/username',   u'conflict',                      type=str)),
            'db_password':   unicode(s.value(k + u'/database/password',   u'conflict',                      type=str)),
            'db_port':               s.value(k + u'/database/port',       5432,                             type=int),
            'db_schema':     unicode(s.value(k + u'/database/schema',     u'conflict',                      type=str)),
            # Settings used for ODBC connction
            'db_connection': unicode(s.value(k + u'/database/connection', u'',                              type=str))
        }

        # Persist db connection values (Necessary for first time use)
        s.setValue(k + "/database/type",       config['db_type']) 
        s.setValue(k + "/database/host",       config['db_host']) 
        s.setValue(k + "/database/database",   config['db_database']) 
        s.setValue(k + "/database/username",   config['db_username']) 
        s.setValue(k + "/database/password",   config['db_password']) 
        s.setValue(k + "/database/port",       config['db_port'])
        s.setValue(k + "/database/schema",     config['db_schema']) 
        s.setValue(k + "/database/connection", config['db_connection']) 
        s.sync
        return config
        
    def connectDatabase (self, con_name, db_type,db_host,db_port,db_username,db_password,db_database,db_connection):
        
        # Is the connect already defined ? 
        db = QSqlDatabase.database (con_name)

        if not db.isValid(): # Nope, create connection...........
    
            # Is it an ODBC connection ?
            if db_type.find('QODBC') >= 0:
                db = QSqlDatabase.addDatabase('QODBC',con_name)
                db.setDatabaseName(db_connection.format(db_host,db_port,db_username,db_password,db_database))
    
            # Other types (Postgres, SQLite a.o)
            else:
                db = QSqlDatabase.addDatabase(db_type,con_name)
                db.setHostName(db_host)
                db.setPort(db_port)
                db.setUserName(db_username)
                db.setPassword(db_password)
                db.setDatabaseName(db_database)
    
            if db.isValid():
    
                if not db.open():
                    self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'Connection to database failed: ') + unicode(db.lastError().type()) + u' ' + unicode(db.lastError().text()), QgsMessageBar.CRITICAL,20)
                    return None
                else:
                    return db
            else:
                self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'Database type : ') + xstr(db_type) + tr(u' is not a valid database type'), QgsMessageBar.CRITICAL,20)
                return None
        
        else:
            if not db.open():
                self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'Connection to database failed: ') + unicode(db.lastError().type()) + u' ' + unicode(db.lastError().text()), QgsMessageBar.CRITICAL,20)
                return None
            else:
                return db
        
    def xstr(s):
        return '' if s is None else str(s)        

            
    def loadSettings (self, db, schema, table, maingroup):

        s = {}
        
        # Set default values (If the db settings table is not configured properly)
        s['search_color']  = u'#FF0000'
        s['search_style']  = 1
        s['search_width']  = 4
        s['search_icon']   = 1
        s['search_size']   = 30
        s['buffer_color']  = u'#777777'
        s['buffer_style']  = 1
        s['buffer_width']  = 4
        s['result_color']  = u'#FDA040'
        s['result_style']  = 1 
        s['result_width']  = 4
        s['result_icon']   = 4
        s['result_size']   = 15
        s['search_buffer'] = 199.99
        s['buffer_min']    = 0.5
        s['buffer_std']    = -0.1
        s['adm_layer']    = -1
    
        # Create schema / Table combibation with correct nomenclature
        tb = u'"{}"."{}"'.format(schema.replace('"',''),table.replace('"',''))
        
        # Query settings table to find the database based setings
        query = db.exec_(u'select name, itemvalue, itemtype from {0} where maingroup = \'{1}\''.format(tb,maingroup))
         

        if query.size() > 0:
            while query.next(): 
                s[query.value(0)] = int(query.value(1)) if query.value(2) == 'int' else float(query.value(1)) if query.value(2) == 'float' else query.value(1)

        else:
            self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'),tr(u'No settings loaded from settings database: ' + tb), QgsMessageBar.CRITICAL,3)
        return s
            

            
    def loadProfiles(self, db, schema, table, combobox):
        if db.isOpen():

            # Create schema / Table combination with correct nomenclature
            tb = '"{0}"."{1}"'.format(schema.replace('"',''),table.replace('"',''))
            # Find profiles and load into combobox
            query = db.exec_('select pid, profilename, default_tool, default_buffersize, default_searchtype from '+ tb)
            if query.size() > 0:
                while query.next(): 
                    dict = {'pid': query.value(0),'tool': query.value(2), 'buffersize': query.value(3), 'searchtype': query.value(4),'profilename':  query.value(1)}
                    combobox.addItem(query.value(1),dict)
                combobox.setCurrentIndex(0)
            else:
                self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'No profiles loaded from database "') + tb, QgsMessageBar.CRITICAL,3)

                
    def convertGeom2AdmCollection (self,geom,epsg,db,schema,table,pkid):

        geoms = None
        
        # Create schema / Table combinations with correct nomenclature
        tbl = self.qtf(schema) + '.' + self.qtf(table)
        tbs = self.qtf(schema) + '.' + self.qtf('servertypes')
        tbc = self.qtf(schema) + '.' + self.qtf('connections')
        
        # Find information about administrative layer
        #                0                 1                   2             3            4      5       6       7           8           9           10            11           12        13
        sqlstr = 'select s.servertypename, s.serverconnection, s.sql_filter, s.wkt_field, c.cid, c.host, c.port, c.database, c.username, c.password, l.schemaname, l.tablename, l.geomid, l.epsg from {0} l left join {1} c on (c.cid = l.cid) left join {2} s on (s.sid = c.sid) where l.lid = {3}'
        query = db.exec_(sqlstr.format(tbl,tbc,tbs,str(pkid)))
                
        if query.size() > 0:

            query.next()

            # Convert geom til wkt with layer projection
            wkt = self.cnvobj2wkt (geom,epsg,query.value(13))
            #                           con_name,            db_type,        db_host,        db_port,        db_username,    db_password,    db_database,    db_connection
            dbl = self.connectDatabase ('c'+str(query.value(4)), query.value(0), query.value(5), query.value(6), query.value(8), query.value(9), query.value(7), query.value(1))
            if not dbl is None:
                if dbl.isOpen():            
                    # Select af list of geometries from administrative layer which overlaps the search object
                    sqlstrl = 'select {0} from {1}.{2} where {3}'.format(query.value(3).format(self.qtf(query.value(12))), self.qtf(query.value(10)), self.qtf(query.value(11)), query.value(2).format(wkt,query.value(13),0.1,self.qtf(query.value(12))))
                    queryl = dbl.exec_(sqlstrl)
                    while queryl.next(): 
                        if geoms == None:
                            geoms = QgsGeometry.fromWkt(queryl.value(0))
                        else:
                            geoms = geoms.combine( QgsGeometry.fromWkt(queryl.value(0)))
                    if geom is None:
                        self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'No objects in adminstrative layer overlaps the search object'), QgsMessageBar.CRITICAL,20)
                else:
                    self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'Database for administrative layer not open'), QgsMessageBar.CRITICAL,20)
            else:
                self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'Database for administrative layer not found'), QgsMessageBar.CRITICAL,20)
        else:
            self.iface.messageBar().pushMessage  (tr(u'Impact Analysis'), tr(u'Definition for administrative layer not found'), QgsMessageBar.CRITICAL,20)
        
        return geoms
                
    def checkBufferValue (self, geom, minval, nuvval):
    
        # Find geometry type
        gtx = -1 if geom == None else geom.type()
        
        # Check/set value: type = point/line, orginal object user is true and value less than min value        
        if gtx in [0,1] and minval > nuvval:
            self.iface.messageBar().pushMessage (tr(u'Impact Analysis'),tr(u'Buffersize changed.. Original value ({}) changed to minimum buffer value ({}) for point and lines').format(nuvval,minval), QgsMessageBar.WARNING,3)
            return minval
        else:
            return nuvval

    def msgbox (self,txt1):
        cb = QtGui.QApplication.clipboard()
        cb.setText(txt1)
        msgBox = QtGui.QMessageBox()
        msgBox.setText(txt1)
        msgBox.exec_()
        
    def qtf (self,s):
        return '""' if s is None else '"' + str(s).replace('"','') + '"'       

    def cnvobj2wkt (self,gobj,epsg_in,epsg_out):
        crsSrc = QgsCoordinateReferenceSystem(int(epsg_in))
        crsDest = QgsCoordinateReferenceSystem(int(epsg_out))
        xform = QgsCoordinateTransform(crsSrc, crsDest)
        i = gobj.transform(xform)
        return gobj.exportToWkt()

    def cnvwkt2obj (self,wkt,epsg_in,epsg_out):
        gobj = QgsGeometry.fromWkt(wkt)
        crsSrc = QgsCoordinateReferenceSystem(int(epsg_in))
        crsDest = QgsCoordinateReferenceSystem(int(epsg_out))
        xform = QgsCoordinateTransform(crsSrc, crsDest)
        i = gobj.transform(xform)
        return gobj

    def xuni(s):
        return u'' if s is None else unicode(s)        
        