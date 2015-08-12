# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'qtdesigner.ui'
#
# Created: Fri Jun  5 00:44:30 2009
#      by: PyQt4 UI code generator 4.4.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

class Ui_MplMainWindow(object):
    def setupUi(self, MplMainWindow):
        MplMainWindow.setObjectName("MplMainWindow")
        MplMainWindow.resize(607, 434)
        self.mplcentralwidget = QtGui.QWidget(MplMainWindow)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mplcentralwidget.sizePolicy().hasHeightForWidth())
        self.mplcentralwidget.setSizePolicy(sizePolicy)
        self.mplcentralwidget.setObjectName("mplcentralwidget")
        self.verticalLayout_2 = QtGui.QVBoxLayout(self.mplcentralwidget)
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.mplhorizontalLayout = QtGui.QHBoxLayout()
        self.mplhorizontalLayout.setSizeConstraint(QtGui.QLayout.SetNoConstraint)
        self.mplhorizontalLayout.setObjectName("mplhorizontalLayout")
        self.mpllineEdit = QtGui.QLineEdit(self.mplcentralwidget)
        self.mpllineEdit.setMinimumSize(QtCore.QSize(489, 21))
        self.mpllineEdit.setObjectName("mpllineEdit")
        self.mplhorizontalLayout.addWidget(self.mpllineEdit)
        self.mplpushButton = QtGui.QPushButton(self.mplcentralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mplpushButton.sizePolicy().hasHeightForWidth())
        self.mplpushButton.setSizePolicy(sizePolicy)
        self.mplpushButton.setMinimumSize(QtCore.QSize(91, 25))
        self.mplpushButton.setObjectName("mplpushButton")
        self.mplhorizontalLayout.addWidget(self.mplpushButton)
        self.verticalLayout_2.addLayout(self.mplhorizontalLayout)
        self.mpl = MplWidget(self.mplcentralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.mpl.sizePolicy().hasHeightForWidth())
        self.mpl.setSizePolicy(sizePolicy)
        self.mpl.setObjectName("mpl")
        self.verticalLayout_2.addWidget(self.mpl)
        MplMainWindow.setCentralWidget(self.mplcentralwidget)
        self.mplmenuBar = QtGui.QMenuBar(MplMainWindow)
        self.mplmenuBar.setGeometry(QtCore.QRect(0, 0, 607, 25))
        self.mplmenuBar.setObjectName("mplmenuBar")
        self.mplmenuFile = QtGui.QMenu(self.mplmenuBar)
        self.mplmenuFile.setObjectName("mplmenuFile")
        MplMainWindow.setMenuBar(self.mplmenuBar)
        self.mplactionOpen = QtGui.QAction(MplMainWindow)
        self.mplactionOpen.setIconVisibleInMenu(False)
        self.mplactionOpen.setObjectName("mplactionOpen")
        self.mplactionQuit = QtGui.QAction(MplMainWindow)
        self.mplactionQuit.setObjectName("mplactionQuit")
        self.mplmenuFile.addAction(self.mplactionOpen)
        self.mplmenuFile.addSeparator()
        self.mplmenuFile.addAction(self.mplactionQuit)
        self.mplmenuBar.addAction(self.mplmenuFile.menuAction())

        self.retranslateUi(MplMainWindow)
        QtCore.QMetaObject.connectSlotsByName(MplMainWindow)

    def retranslateUi(self, MplMainWindow):
        MplMainWindow.setWindowTitle(QtGui.QApplication.translate("MplMainWindow", "Matplotlib In Qt Designer - Count letters frequency in a file", None, QtGui.QApplication.UnicodeUTF8))
        self.mpllineEdit.setText(QtGui.QApplication.translate("MplMainWindow", "/usr/share/dict/words", None, QtGui.QApplication.UnicodeUTF8))
        self.mplpushButton.setText(QtGui.QApplication.translate("MplMainWindow", "Parse this file", None, QtGui.QApplication.UnicodeUTF8))
        self.mplmenuFile.setTitle(QtGui.QApplication.translate("MplMainWindow", "File", None, QtGui.QApplication.UnicodeUTF8))
        self.mplactionOpen.setText(QtGui.QApplication.translate("MplMainWindow", "Open", None, QtGui.QApplication.UnicodeUTF8))
        self.mplactionQuit.setText(QtGui.QApplication.translate("MplMainWindow", "Quit", None, QtGui.QApplication.UnicodeUTF8))

from mplwidget import MplWidget
