# Spring Boot Tutorial

В этом туториале вы научитесь как создать простое веб-приложение с использованием [Spring Boot](http://projects.spring.io/spring-boot/).

## Шаг 1. Hello spring boot

Создаем пустой мавен проект с помощью команды:
```sh
mvn -B archetype:generate \
  -DarchetypeGroupId=org.apache.maven.archetypes \
  -DgroupId=it.sevenbits\
  -DartifactId=springboot-tutorial
```

Добавляем в `pom.xml`  зависимости для spring-boot и плагин для сборки fat-jar.

Запускаем `mvn dependency:tree`, чтобы скачать все новые зависимости и вывести их в виде дерева.

Создаем главный конфигурационный класс `Application.java` и класс контроллера `Home.java`

Для запуска проекта выполняем ```mvn spring-boot:run```

Открываем [localhost:8000](http://localhost:8080/) 

## Шаг 2. Рендеринг шаблонов

Добавляем в `pom.xml` библиотеку [thymeleaf](http://www.thymeleaf.org/). К сведению эта библиотека не основана на jsp. Это шаблонизатор для HTML5 и XML.  [Чем отличается jsp от thymeleaf](https://spring.io/blog/2012/10/30/spring-mvc-from-jsp-and-tiles-to-thymeleaf)

```xml
<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```

Так как эта библиотека уже интегрирована в `spring-boot` нам не нужно создавать `bean` с конфигурацией для нее. 

По-умолчанию все шаблоны должны находиться в `src/main/resources/templates`. Поэтому создаем шаблон `index.html` по адресу `src/main/resources/templates/home`. А в контроллере `HomeController#index` убираем аннотацию `@ResponseBody` и возвращаем строку `"home/index"`. 

```html
<!DOCTYPE HTML>
<html xmlns:th="http://www.thymeleaf.org" lang="en">
<head>
    <meta charset="UTF-8" />
    <title>SpringBootTutorial</title>
</head>
<body>
    <h1>Hello Spring Boot</h1>
</body>
</html>
```

```java
@Controller
public class HomeController {
    @RequestMapping(value = "/")
    public String index() {
        // Так как нет аннотации @ResponseBody, то spring будет искать шаблон по адресу home/index
        // Если шаблона не будет найдено, то вернется 404 ошибка
        return "home/index";
    }
}
```

Обратите внимание, что `thymeleaf` проверяет html на валидность, поэтому иногда можете получать 500 ошибку, если неправильно написали html: забыли закрыть тэг, например.

## Шаг 3. Добавим формочку

Добавим форму подписки на главную страницу. Для этого в методе `index` `HomeController` добавим аргумент  `Model` - это такой контейнер для объектов, которые нужно показать в шаблоне. Так же создадим form-object - просто джава класс, который представляет собой контейнер формы. 
 
```
 @RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(final Model model) {
        // В модель добавим новый объект формы подписки
        model.addAttribute("subscription", new SubscriptionForm());
        return "home/index";
    }

    @RequestMapping(value = "/", method = RequestMethod.POST)
    public String subscribe(@ModelAttribute SubscriptionForm form, final Model model) {
        // В запросе пришла заполненная форма. Отправим в модель этот объект и отрендерим ее на другом шаблоне.
        model.addAttribute("subscription", form);
        return "home/subscribed";
    }
```
 
В шаблоне добавим код для формы.

```html
<form action="#" th:action="@{/}" th:object="${subscription}" method="post">
            <input th:field="*{name}" name="name" placeholder="Your name" type="text" />
            <input th:field="*{email}" name="email" placeholder="Your email" type="text"/>
            <input type="submit" value="Subscribe" />
</form>
```

Добавим шаблон для вывода содержимого формы
```html
<h3>You successfully subscribed</h3>
<p th:text="'email: ' + ${subscriptionForm.email}" />
<p th:text="'name: ' + ${subscriptionForm.name}" />
<a href="/">Go to main page</a>
```
