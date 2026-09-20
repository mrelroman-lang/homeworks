import sentry_sdk
from sentry_sdk import capture_message, capture_exception
import os

sentry_sdk.init(
    dsn="http://f72b28f825b31df79d69fed7eac5d939@localhost:9000/2",
    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/python/data-management/data-collected/ for more info
    send_default_pii=True,
    traces_sample_rate=1.0,          # трассировки (transactions)
    profiles_sample_rate=1.0,        # профилирование (если поддерживается версией)
    debug=True,                      # в логах видеть ушло ли событие
    environment="development",       # среда (dev/staging/prod)
    release="test-release-1.0"       # релиз для теста
)

def send_simple_message():
    """Отправляет обычное сообщение (не ошибку)"""
    capture_message("Это тестовое сообщение из Python-проекта", level="info")
    print("[OK] Обычное сообщение отправлено.")

def trigger_exception():
    """Намеренно вызывает ошибку, чтобы Sentry её поймал"""
    try:
        # Искусственная ошибка
        result = 1 / 0
    except ZeroDivisionError as e:
        capture_exception(e)
        print("[OK] Исключение поймано и отправлено в Sentry.")

def send_error_with_context():
    """Отправляет ошибку с дополнительными данными (контекст, теги, extra)"""
    with sentry_sdk.push_scope() as scope:
        scope.set_tag("component", "test-script")
        scope.set_context("user_info", {"username": "roman", "role": "admin"})
        scope.set_extra("custom_field", "test_value")
        capture_message("Сообщение с контекстом", level="error")
    print("[OK] Сообщение с контекстом отправлено.")

if __name__ == "__main__":
    print("Отправка тестовых событий в Sentry...")
    send_simple_message()
    trigger_exception()
    send_error_with_context()
    print("Готово. Проверь проект в интерфейсе Sentry.")
