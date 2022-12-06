БД "Компьютерная фирма"

Схема БД состоит из четырех таблиц:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, price, screen)
Printer(code, model, color, type, price)

Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). 
Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. В таблице PC для каждого ПК, однозначно определяемого 
уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), 
размер диска - hd (в гигабайтах), скорость считывающего устройства - cd (например, '4x') и цена - price (в долларах). Таблица Laptop аналогична таблице РС за 
исключениемтого, что вместо скорости CD содержит размер экрана -screen (в дюймах). В таблице Printer для каждой модели принтера указывается, является ли он 
цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.


Задания:

Задание: 8 
Найдите производителя, выпускающего ПК, но не ПК-блокноты.

Ответ: 
SELECT maker FROM Product
WHERE type = 'PC'
EXCEPT
SELECT maker FROM Product
WHERE type = 'Laptop'

Задание: 16 
Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i),
Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

Ответ:
SELECT DISTINCT A.model as model1, B.model as model2, A.speed as speed, A.ram as ram
FROM PC as A, PC B
WHERE A.ram = B.ram AND A.speed = B.speed AND A.model > B.model

Задание: 20 
Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

Ответ: 
SELECT maker, COUNT(model) as num 
FROM Product WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3
 
Задание 23 
Найдите производителей, которые производили бы как ПК со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц. 
Вывести: Maker

Ответ:
SELECT maker FROM Product, PC 
WHERE Product.model = PC.model AND speed >=750
INTERSECT
SELECT maker FROM Product, Laptop
WHERE Product.model = Laptop.model AND speed >=750



БД "Корабли"
Рассматривается БД кораблей, участвовавших во второй мировой войне. Имеются следующие отношения:

Classes (class, type, country, numGuns, bore, displacement)
Ships (name, class, launched)
Battles (name, date)
Outcomes (ship, battle, result)

Корабли в «классах» построены по одному и тому же проекту, и классу присваивается либо имя первого корабля, построенного по данному проекту, либо названию класса
дается имя проекта, которое не совпадает ни с одним из кораблей в БД. Корабль, давший название классу, называется головным.
Отношение Classes содержит имя класса, тип (bb для боевого (линейного) корабля или bc для боевого крейсера), страну, в которой построен корабль, число главных орудий,
калибр орудий (диаметр ствола орудия в дюймах) и водоизмещение ( вес в тоннах). В отношении Ships записаны название корабля, имя его класса и год спуска на воду.
В отношение Battles включены название и дата битвы, в которой участвовали корабли, а в отношении Outcomes – результат участия данного корабля в битве 
(потоплен-sunk, поврежден - damaged или невредим - OK).
Замечания. 1) В отношение Outcomes могут входить корабли, отсутствующие в отношении Ships. 2) Потопленный корабль в последующих битвах участия не принимает.


Задания:

Задание: 14 
Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.

Ответ:
SELECT Ships.class as class, Ships.name as name, Classes.country as country
FROM Classes JOIN Ships ON Classes.class = Ships.class
WHERE numGuns >=10

Задание: 34 
По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. 
Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.

Ответ:
SELECT name FROM classes, ships 
WHERE launched >= 1922 AND displacement > 35000 AND type = 'bb' 
AND ships.class = classes.class

Задание: 43 
Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

Ответ: 
SELECT DISTINCT Battles.name
FROMBattles
WHERE year(Battles.date) NOT IN (SELECT Ships.launched
FROM Ships WHERE Ships.launched is not NULL)


Задание: 45 
Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.

Ответ:
SELECT name FROM Ships WHERE name LIKE '% % %' UNION 
SELECT ship as name FROM Outcomes WHERE ship LIKE '% % %'
