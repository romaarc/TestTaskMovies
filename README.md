# TestTaskMovies
<p align="justify">
    <img src="https://i.postimg.cc/4xcm7vsM/film-reel-2.png">
</p>

# Описание
Разработать простое приложение для просмотра  фильмов. 
API для фильмов нужно брать через сервис ​https://www.themoviedb.org/.​
Документацию по работе API этого сервиса можно получить по ссылке ​https://www.themoviedb.org/documentation/api

## Функционал для реализации:
- Получить список фильмов и вывести в виде ленты первые 20 записей
- Данные должны быть кэшированы чтобы вывести их при следующем открытии
страницы
- Если у фильма есть фото, то его также нужно вывести в ленте
- При прокручивании ленты до конца нужно автоматически подгрузить ещё 20
записей в ленту (Примечание: Если сайт не позволяет загружать фильмы через пагинацию, при прокручивании страницы можете повторно загружать фильмы из того же источника)
- При нажатии на фильм нужно открыть другую страницу, где можно прочитать детали фильма (Примечание: Вам нужно брать детальную информацию фильма)
 В деталях новости нужно вывести все данные, которые передаются в API
- При протягивании вверз (swipe) данные должны быть обновлены

# Примерный интерфейс
<p align="center">
    <img src="https://i.postimg.cc/wxmWTvrB/Screenshot-2021-11-19-at-14-10-34.png">
</p>

# Экраны
- https://user-images.githubusercontent.com/28999468/142624738-c00e80db-1a17-4f65-ab84-eec04dbc4a2a.mov

- https://user-images.githubusercontent.com/28999468/142624270-9d9f33f0-7ace-4ac8-b280-1d4310999100.mov

- https://user-images.githubusercontent.com/28999468/142625309-ff68646f-352a-412a-907a-a5a93cf0ec0c.mov

## Installation

У вас должны быть установлены SPM Kingfisher

## Детали реализации

### Deployment Target: 
iOS 13, Project without Storyboard and Xibs, only layout with code

### Архитектура приложения
Специально сделана реализация на MVC, мои другие проекты будут на других архитектурах 
<br>
**MVC + Coordinator + Services (Core Data Stack + URLSession)**.<br>

### All tests code coverage
<img width="989" alt="Screenshot 2021-11-19 at 16 26 38" src="https://user-images.githubusercontent.com/28999468/142630248-3b0d702e-a2fd-45fe-9071-e654711ba3ad.png">

## Subscribe, Like & Share.

![Alt Text](https://media.giphy.com/media/bYUbS6XYDi3Ze/giphy.gif)
