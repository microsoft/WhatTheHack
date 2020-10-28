-- the veggie
INSERT INTO pizzaitem (id, quantity, ingredient_id)
VALUES
(1, 1, 20),
(2, 1, 13),
(3, 1, 16),
(4, 1, 14),
(5, 1, 21),
(6, 1, 23),
(7, 1, 20),
(8, 1, 13),
(9, 1, 16),
(10, 1, 14),
(11, 1, 21),
(12, 1, 23);

INSERT INTO pizzaside (id, name) VALUES
(1, 'The Veggie'),
(2, 'The Veggie');

INSERT INTO pizzaside_pizzaitem (pizzaside_id, pizzaitems_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 10),
(2, 11),
(2, 12);

INSERT INTO pizza (id, bakestyle_id, crust_id, cutstyle_id, size_id, left_pizzaside_id, right_pizzaside_id)
VALUES (1, 1, 1, 1, 1, 1, 2);

INSERT INTO orderitem (id, quantity, pizza_id) VALUES (1, 1, 1);
INSERT INTO orderitemtemplate (id, orderitem_id, imageFileName) VALUES (1, 1, 'the_veggie.jpg');

-- four cheese
INSERT INTO pizzaitem (id, quantity, ingredient_id) VALUES
(21, 1, 31),
(22, 1, 28),
(23, 1, 30),
(24, 1, 37),
(25, 1, 23),
(26, 1, 31),
(27, 1, 28),
(28, 1, 30),
(29, 1, 37),
(30, 1, 23);

INSERT INTO pizzaside (id, name) VALUES
(3, 'Four Cheese'),
(4, 'Four Cheese');

INSERT INTO pizzaside_pizzaitem (pizzaside_id, pizzaitems_id) VALUES
(3, 21),
(3, 22),
(3, 23),
(3, 24),
(3, 25),
(4, 26),
(4, 27),
(4, 28),
(4, 29),
(4, 30);

INSERT INTO pizza (id, bakestyle_id, crust_id, cutstyle_id, size_id, left_pizzaside_id, right_pizzaside_id)
VALUES (2, 1, 1, 1, 1, 3, 4);

INSERT INTO orderitem (id, quantity, pizza_id) VALUES (2, 1, 2);
INSERT INTO orderitemtemplate (id, orderitem_id, imageFileName) VALUES (2, 2, 'four_cheese.jpg');

-- pepperoni classic
INSERT INTO pizzaitem (id, quantity, ingredient_id) VALUES
(31, 2, 3),
(32, 1, 31),
(33, 1, 23),
(34, 1, 3),
(35, 1, 31),
(36, 1, 23);

INSERT INTO pizzaside (id, name) VALUES
(5, 'Pepperoni Classic'),
(6, 'Pepperoni Classic');

INSERT INTO pizzaside_pizzaitem (pizzaside_id, pizzaitems_id) VALUES
(5, 31),
(5, 32),
(5, 33),
(6, 34),
(6, 35),
(6, 36);

INSERT INTO pizza (id, bakestyle_id, crust_id, cutstyle_id, size_id, left_pizzaside_id, right_pizzaside_id)
VALUES (3, 1, 1, 1, 1, 5, 6);

INSERT INTO orderitem (id, quantity, pizza_id) VALUES (3, 1, 3);
INSERT INTO orderitemtemplate (id, orderitem_id, imageFileName) VALUES (3, 3, 'pepperoni_classic.jpg');

-- White Garden
INSERT INTO pizzaitem (id, quantity, ingredient_id) VALUES
(41, 1, 20),
(42, 1, 21),
(43, 1, 15),
(44, 1, 19),
(45, 1, 31),
(46, 1, 30),
(47, 1, 20),
(48, 1, 21),
(49, 1, 15),
(50, 1, 19),
(51, 1, 31),
(52, 1, 30);

INSERT INTO pizzaside (id, name) VALUES
(7, 'White Garden'),
(8, 'White Garden');

INSERT INTO pizzaside_pizzaitem (pizzaside_id, pizzaitems_id) VALUES
(7, 41),
(7, 42),
(7, 43),
(7, 44),
(7, 45),
(7, 46),
(8, 47),
(8, 48),
(8, 49),
(8, 50),
(8, 51),
(8, 52);

INSERT INTO pizza (id, bakestyle_id, crust_id, cutstyle_id, size_id, left_pizzaside_id, right_pizzaside_id)
VALUES (4, 1, 1, 1, 1, 7, 8);

INSERT INTO orderitem (id, quantity, pizza_id) VALUES (4, 1, 4);
INSERT INTO orderitemtemplate (id, orderitem_id, imageFileName) VALUES (4, 4, 'white_garden.jpg');

-- BBQ Chicken
INSERT INTO pizzaitem (id, quantity, ingredient_id) VALUES
(61, 1, 5),
(62, 1, 9),
(63, 1, 15),
(64, 1, 35),
(65, 1, 28),
(66, 1, 30),
(67, 1, 31),
(68, 1, 5),
(69, 1, 9),
(70, 1, 15),
(71, 1, 35),
(72, 1, 28),
(73, 1, 30),
(74, 1, 31);

INSERT INTO pizzaside (id, name) VALUES
(9, 'BBQ Chicken'),
(10, 'BBQ Chicken');

INSERT INTO pizzaside_pizzaitem (pizzaside_id, pizzaitems_id) VALUES
(9, 61),
(9, 62),
(9, 63),
(9, 64),
(9, 65),
(9, 66),
(9, 67),
(10, 68),
(10, 69),
(10, 70),
(10, 71),
(10, 72),
(10, 73),
(10, 74);

INSERT INTO pizza (id, bakestyle_id, crust_id, cutstyle_id, size_id, left_pizzaside_id, right_pizzaside_id)
VALUES (5, 1, 1, 1, 1, 9, 10);

INSERT INTO orderitem (id, quantity, pizza_id) VALUES (5, 1, 5);
INSERT INTO orderitemtemplate (id, orderitem_id, imageFileName) VALUES (5, 5, 'bbq_chicken.jpg');

-- Hawaiian
INSERT INTO pizzaitem (id, quantity, ingredient_id) VALUES
(81, 1, 7),
(82, 1, 5),
(83, 1, 9),
(84, 1, 17),
(85, 2, 31),
(86, 1, 23),
(87, 1, 7),
(88, 1, 5),
(89, 1, 9),
(90, 1, 17),
(91, 2, 31),
(92, 1, 23);

INSERT INTO pizzaside (id, name) VALUES
(11, 'Hawaiian'),
(12, 'Hawaiian');

INSERT INTO pizzaside_pizzaitem (pizzaside_id, pizzaitems_id) VALUES
(11, 81),
(11, 82),
(11, 83),
(11, 84),
(11, 85),
(11, 86),
(12, 87),
(12, 88),
(12, 89),
(12, 90),
(12, 91),
(12, 92);

INSERT INTO pizza (id, bakestyle_id, crust_id, cutstyle_id, size_id, left_pizzaside_id, right_pizzaside_id)
VALUES (6, 1, 1, 1, 1, 11, 12);

INSERT INTO orderitem (id, quantity, pizza_id) VALUES (6, 1, 6);
INSERT INTO orderitemtemplate (id, orderitem_id, imageFileName) VALUES (6, 6, 'hawaiian.jpg');
