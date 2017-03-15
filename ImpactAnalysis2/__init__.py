# -*- coding: utf-8 -*-
"""
/***************************************************************************
 ImpactAnalysis2
                                 A QGIS plugin
 Generates multilayer automated overlays analysis
                             -------------------
        begin                : 2017-03-01
        copyright            : (C) 2017 by Bo Victor Thomsen,  Municipality of Frederikssund, Denmark
        email                : bvtho@frederikssund.dk
        git sha              : $Format:%H$
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
 This script initializes the plugin, making it known to QGIS.
"""


# noinspection PyPep8Naming
def classFactory(iface):  # pylint: disable=invalid-name
    """Load ImpactAnalysis2 class from file ImpactAnalysis2.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .impact_analysis2 import ImpactAnalysis2
    return ImpactAnalysis2(iface)
