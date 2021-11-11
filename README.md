# Проект YaMDb
Проект YaMDb собирает отзывы пользователей на произведения. Произведения делятся на категории: "Книги", "Фильмы", "Музыка". Список категорий может быть расширен.
Сами произведения в YaMDb не хранятся, здесь нельзя посмотреть фильм или послушать музыку.
В каждой категории есть произведения: книги, фильмы или музыка. Например, в категории "Книги" могут быть произведения "Винни Пух и все-все-все" и "Марсианские хроники", а в категории "Музыка" — песня "Давеча" группы "Насекомые" и вторая сюита Баха. Произведению может быть присвоен жанр из списка предустановленных (например, "Сказка", "Рок" или "Артхаус"). Новые жанры может создавать только администратор.
Благодарные или возмущённые читатели оставляют к произведениям текстовые отзывы и выставляют произведению рейтинг.

# Ресурсы API YaMDb
**AUTH**: аутентификация.

**USERS**: пользователи.

**TITLES**: произведения, к которым пишут отзывы (определённый фильм, книга или песенка).

**CATEGORIES**: категории (типы) произведений ("Фильмы", "Книги", "Музыка").

**GENRES**: жанры произведений. Одно произведение может быть привязано к нескольким жанрам.

**REVIEWS**: отзывы на произведения. Отзыв привязан к определённому произведению.

**COMMENTS**: комментарии к отзывам. Комментарий привязан к определённому отзыву.

# Алгоритм регистрации пользователей
Пользователь отправляет POST-запрос с параметром email и username на `/api/v1/auth/signup/`.
YaMDB отправляет письмо с кодом подтверждения (confirmation_code) на адрес email (функция в разработке).
Пользователь отправляет POST-запрос с параметрами email и confirmation_code на `/api/v1/auth/token/`, в ответе на запрос ему приходит token (JWT-токен).
Эти операции выполняются один раз, при регистрации пользователя. В результате пользователь получает токен и может работать с API, отправляя этот токен с каждым запросом.

# Пользовательские роли
**Аноним** — может просматривать описания произведений, читать отзывы и комментарии.

**Аутентифицированный пользователь (user)** — может читать всё, как и Аноним, дополнительно может публиковать отзывы и ставить рейтинг произведениям (фильмам/книгам/песенкам), может комментировать чужие отзывы и ставить им оценки; может редактировать и удалять свои отзывы и комментарии.

**Модератор (moderator)** — те же права, что и у Аутентифицированного пользователя плюс право удалять и редактировать любые отзывы и комментарии.

**Администратор (admin)** — полные права на управление проектом и всем его содержимым. Может создавать и удалять произведения, категории и жанры. Может назначать роли пользователям.

**Администратор Django** — те же права, что и у роли Администратор.

# Запуск стека приложений с помощью docker-compose
Склонируйте репозиторий. 

В корневой директории создайте файл `.env` с переменными окружения для работы с базой данных:
```
DB_NAME=postgres # имя базы данных
POSTGRES_USER=postgres # логин для подключения к базе данных
POSTGRES_PASSWORD=postgres # пароль для подключения к БД (установите свой)
DB_HOST=db # название сервиса (контейнера)
DB_PORT=5432 # порт для подключения к БД
```

Выполните команду `docker-compose up -d` для запуска сервера разработки.

Выполните миграции: `docker-compose exec web python manage.py migrate --noinput`.

Для заполнения базы начальными данными, выполните команды:
```
docker-compose exec web python manage.py shell

# выполнить в открывшемся терминале:
>>> from django.contrib.contenttypes.models import ContentType
>>> ContentType.objects.all().delete()
>>> quit()

docker-compose exec web python manage.py loaddata fixtures.json
```

Создайте суперпользователя: 

`docker-compose exec web python manage.py createsuperuser` 

Выполните _collectstatic_: 

`docker-compose exec web python manage.py collectstatic --no-input`.

Проект запущен и доступен по адресу http://gastrolerontour.ru/api/v1/.

# CI/CD
Для проекта YaMDB настроен _workflow_ со следующими инструкциями:
- автоматический запуск тестов
- обновление образов на Docker Hub
- автоматический деплой на боевой сервер при пуше в главную ветку main
- отправка уведомления в Telegram.

![YaMDB workflow](https://github.com/rodionbogoveev/yamdb_final/actions/workflows/yamdb_workflow.yml/badge.svg)

# В разработке
Нужно доработать отправку кода при регистрации на e-mail.