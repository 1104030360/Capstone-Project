"""
My first application
"""

import importlib.metadata
import sys

from PySide6 import QtWidgets, QtQml
from pathlib import Path
from PySide6.QtCore import QUrl, QObject, Slot
from myapp.database import DatabaseConnector
from myapp.init import server_home_init, admin_home_init


class DatabaseConnectorWrapper(QObject):
    def __init__(self):
        super().__init__()
        print("Initializing DatabaseConnectorWrapper")
        self.db_connector = DatabaseConnector()
        if self.db_connector.connection:
            print("DatabaseConnectorWrapper initialized successfully")
        else:
            print("Failed to initialize DatabaseConnectorWrapper")

    @Slot(str, str, result='QVariantMap')
    def checkLogin(self, username, password):
        result = self.db_connector.check_login(username, password)
        return result


class MainWindow(QObject):
    def __init__(self, engine):
        super().__init__()
        self.engine = engine
        self.db_connector_wrapper = DatabaseConnectorWrapper()
        self.engine.rootContext().setContextProperty("mainWindow", self)
        self.engine.rootContext().setContextProperty("DatabaseConnector", self.db_connector_wrapper)

    @Slot(str, str, result='QVariantMap')
    def checkLogin(self, username, password):
        result = self.db_connector_wrapper.checkLogin(username, password)
        return result

    @Slot(str)
    def launchServerHome(self, account_id):
        server_home_init.launch(self.engine, account_id)

    @Slot(str)
    def launchAdminHome(self, account_id):
        admin_home_init.launch(self.engine, account_id)


def main():
    try:
        print("Starting application")
        app_module = sys.modules["__main__"].__package__
        metadata = importlib.metadata.metadata(app_module)
        QtWidgets.QApplication.setApplicationName(metadata["Formal-Name"])

        app = QtWidgets.QApplication(sys.argv)
        print("QGuiApplication created")

        engine = QtQml.QQmlApplicationEngine()
        print("QQmlApplicationEngine created")

        main_window = MainWindow(engine)
        print("MainWindow created")

        qml_file = Path(__file__).resolve().parent / "qml/pages/login.qml"
        print(f"Loading QML file from {qml_file}")

        engine.load(QUrl.fromLocalFile(qml_file))
        print("QML file loaded")

        if not engine.rootObjects():
            print("No root objects found")
            sys.exit(-1)

        mainWindow = engine.rootObjects()[0]
        print("Main window object retrieved")

        screen = app.primaryScreen().availableGeometry()
        window = mainWindow.geometry()
        x = (screen.width() - window.width()) / 2
        y = (screen.height() - window.height()) / 2
        mainWindow.setPosition(x, y)
        print("Main window positioned")

        def on_app_about_to_quit():
            main_window.db_connector_wrapper.db_connector.close_connection()

        app.aboutToQuit.connect(on_app_about_to_quit)

        sys.exit(app.exec())
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(-1)


if __name__ == "__main__":
    main()
