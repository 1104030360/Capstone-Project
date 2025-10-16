import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv


class DatabaseConnector:
    _instance = None

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(DatabaseConnector, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'initialized'):
            self.initialized = True
            print("Initializing DatabaseConnector")
            # 載入 .env
            load_dotenv()
            self.connection = self.create_connection()
            if self.connection:
                print("Database connection created successfully")
            else:
                print("Failed to create database connection")

    def create_connection(self):
        try:
            # 從環境變數讀取
            connection = mysql.connector.connect(
                host=os.getenv('DB_HOST'),
                database=os.getenv('DB_NAME'),
                user=os.getenv('DB_USER'),
                password=os.getenv('DB_PASSWORD')
            )
            if connection.is_connected():
                print("Successfully connected to the database")
                return connection
            else:
                print("Failed to connect to the database")
                return None
        except Error as e:
            print(f"Error while connecting to MySQL: {e}")
            return None

    def check_login(self, username, password):
        try:
            print(f"Checking login for user: {username}")
            cursor = self.connection.cursor(dictionary=True)
            cursor.callproc('sp_check_login', [username, password])
            for result in cursor.stored_results():
                user = result.fetchone()
                if user:
                    print("Login successful")
                    return {'success': True, 'account_level': user['account_level'], 'account_id': user['account_id']}
                else:
                    print("Login failed: user not found")
                    return {'success': False}
        except Error as e:
            print(f"Error executing stored procedure: {e}")
            return {'success': False}

    def get_account_name(self, account_id):
        try:
            print(f"Getting account name for account ID: {account_id}")
            cursor = self.connection.cursor(dictionary=True)
            cursor.callproc('sp_get_account_name', [account_id])
            for result in cursor.stored_results():
                account = result.fetchone()
                if account:
                    print(f"Account name retrieved: {account['account_name']}")
                    return account['account_name']
                else:
                    print("Account name not found")
                    return ""
        except Error as e:
            print(f"Error executing stored procedure: {e}")
            return ""

    def close_connection(self):
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("Database connection closed")