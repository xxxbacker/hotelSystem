# Чибисов А. А. 43ИС-21
# Вариант 5. Гостиница.
# В базе данных хранятся сведения о свободных и занятых одно- и многоместных номерах разной категории и проживающих.
# Таблицы: Категории (Код категории, название), Номера (Код номера, код категории, номер, мест),  Граждане (Код гражданина, ФИО, паспорт), Размещение (Код размещения, код гражданина, код номера, дата въезда, срок проживания).
# Требуется:
# - определить количество полностью свободных номеров, то есть тех, в которых не поселены граждане;
# - сравнительную степень занятости (в процентах) номеров по категориям.

from PyQt6.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QPushButton, QLabel, QWidget, QMessageBox, QSpacerItem, QSizePolicy
from PyQt6.QtGui import QFont, QPalette, QColor, QPixmap
from PyQt6.QtCore import Qt
import mysql.connector

class HotelSystem(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Гостиница")
        self.setFixedSize(590, 700)
        self.setup_ui()

    def setup_ui(self):
        # Установка фона окна
        palette = self.palette()
        palette.setColor(QPalette.ColorRole.Window, QColor("#FFF5E4"))
        self.setPalette(palette)

        # Шрифты
        title_font = QFont("Arial", 20, QFont.Weight.Bold)
        button_font = QFont("Arial", 14)

        # Главный виджет
        central_widget = QWidget()
        self.setCentralWidget(central_widget)

        # Основной макет
        main_layout = QVBoxLayout(central_widget)
        main_layout.setAlignment(Qt.AlignmentFlag.AlignTop)
        main_layout.setSpacing(20)  # Пространство между элементами

        # Заголовок
        title_label = QLabel('Добро пожаловать в систему "Гостиница"')
        title_label.setFont(title_font)
        title_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        title_label.setStyleSheet("color: #6C757D;")  # Серо-коричневый текст
        main_layout.addWidget(title_label)

        # Кнопки
        free_rooms_btn = QPushButton("Свободные номера")
        free_rooms_btn.setFont(button_font)
        free_rooms_btn.setStyleSheet(self.button_style())
        free_rooms_btn.clicked.connect(self.get_free_rooms)

        occupancy_btn = QPushButton("Занятость номеров")
        occupancy_btn.setFont(button_font)
        occupancy_btn.setStyleSheet(self.button_style())
        occupancy_btn.clicked.connect(self.get_room_occupancy)

        main_layout.addWidget(free_rooms_btn)
        main_layout.addWidget(occupancy_btn)

        spacer = QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding)
        main_layout.addSpacerItem(spacer)

        image_label = QLabel()
        pixmap = QPixmap("11.jpg").scaled(480, 300, Qt.AspectRatioMode.KeepAspectRatio, Qt.TransformationMode.SmoothTransformation)
        image_label.setPixmap(pixmap)
        image_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        main_layout.addWidget(image_label)

    def button_style(self):
        return """
            QPushButton {
                background-color: #A8D5BA;  /* Нежно-зелёный цвет */
                color: #ffffff;
                border: 2px solid #6C757D;
                border-radius: 15px;
                padding: 15px;
            }
            QPushButton:hover {
                background-color: #F7A76C;  /* Нежно-оранжевый при наведении */
                color: #FFFFFF;
            }
        """

    def get_free_rooms(self):
        try:
            connection = self.connect_to_db()
            cursor = connection.cursor()
            query = """
                SELECT COUNT(*) AS FreeRooms
                FROM Rooms
                WHERE RoomID NOT IN (
                    SELECT RoomID FROM Placements
                );
            """
            cursor.execute(query)
            result = cursor.fetchone()
            QMessageBox.information(self, "Свободные номера", f"Свободных номеров: {result[0]}")
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", str(e))
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def get_room_occupancy(self):
        try:
            connection = self.connect_to_db()
            cursor = connection.cursor()
            query = """
                SELECT Categories.CategoryName, 
                       ROUND(100.0 * SUM(IF(RoomID IN (SELECT RoomID FROM Placements), 1, 0)) / COUNT(*), 2) AS OccupancyRate
                FROM Rooms
                INNER JOIN Categories ON Rooms.CategoryID = Categories.CategoryID
                GROUP BY Categories.CategoryName;
            """
            cursor.execute(query)
            results = cursor.fetchall()
            occupancy_text = "\n".join([f"{row[0]}: {row[1]}%" for row in results])
            QMessageBox.information(self, "Занятость номеров", f"Процент занятости:\n{occupancy_text}")
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", str(e))
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()

    def connect_to_db(self):
        return mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="HotelSystem"
        )

if __name__ == "__main__":
    app = QApplication([])
    window = HotelSystem()
    window.show()
    app.exec()
