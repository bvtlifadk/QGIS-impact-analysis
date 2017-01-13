# -*- coding: utf-8 -*-
"""
/***************************************************************************
 ImpactAnalysis
                                 A QGIS plugin
 A system to automate spatial overlay analysis of a large no of layers
                             -------------------
        begin                : 2017-01-13
        copyright            : (C) 2017 by Bo Victor Thomsen
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
    """Load ImpactAnalysis class from file ImpactAnalysis.

    :param iface: A QGIS interface instance.
    :type iface: QgsInterface
    """
    #
    from .impact_analysis import ImpactAnalysis
    return ImpactAnalysis(iface)
