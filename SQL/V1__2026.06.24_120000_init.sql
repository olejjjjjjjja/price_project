CREATE TABLE kategoria_tovara (
    id          INTEGER PRIMARY KEY,
    naimenovanie VARCHAR(100) NOT NULL UNIQUE,
    opisanie    VARCHAR(500)
);

CREATE TABLE tovar (
    id              INTEGER PRIMARY KEY,
    artikul         VARCHAR(50),
    naimenovanie    VARCHAR(300) NOT NULL,
    ed_izmerenia    VARCHAR(20),
    kategoria_id    INTEGER REFERENCES kategoria_tovara(id)
);

CREATE TABLE postavshik (
    id               INTEGER PRIMARY KEY,
    nazvanie         VARCHAR(200) NOT NULL,
    inn              VARCHAR(20),
    kontaktnoe_litso VARCHAR(100),
    nomer_telefona   VARCHAR(20),
    email            VARCHAR(100),
    status_raboty    BOOLEAN DEFAULT TRUE
);

CREATE TABLE zagruzka (
    id              INTEGER PRIMARY KEY,
    imia_faila      VARCHAR(255),
    data_zagruzki   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cena (
    id              INTEGER PRIMARY KEY,
    postavshik_id   INTEGER NOT NULL REFERENCES postavshik(id),
    tovar_id        INTEGER NOT NULL REFERENCES tovar(id),
    zagruzka_id     INTEGER REFERENCES zagruzka(id),
    cena            DECIMAL(18,4) NOT NULL,
    valuta          VARCHAR(3) DEFAULT 'RUB',
    data            DATE NOT NULL,
    
    CHECK (cena > 0),
    UNIQUE (postavshik_id, tovar_id, data, zagruzka_id)
);

INSERT INTO kategoria_tovara (id, naimenovanie, opisanie) VALUES
(1, 'Кабельная продукция', 'Все виды кабелей и проводов'),
(2, 'Электрооборудование', 'Щиты, боксы, распределительные устройства'),
(3, 'Автоматика', 'Автоматы, УЗО, реле, контакторы'),
(4, 'Работы', 'Электромонтажные и пусконаладочные работы');

INSERT INTO tovar (id, artikul, naimenovanie, ed_izmerenia, kategoria_id) VALUES
(101, 'КВ-001', 'Кабель ВВГ 3х2,5', 'м', 1),
(102, 'КВ-002', 'Кабель ВВГ 5х4', 'м', 1),
(103, 'КВ-003', 'Кабель КГ 3х4', 'м', 1),
(104, 'Щ-001', 'Щит распределительный ШР-12', 'шт', 2),
(105, 'Щ-002', 'Щит учёта ЩУ-100', 'шт', 2),
(106, 'А-001', 'Автомат ВА47-29 16А', 'шт', 3),
(107, 'А-002', 'УЗО 25А 30мА', 'шт', 3),
(108, 'М-001', 'Монтаж кабеля', 'м', 4),
(109, 'М-002', 'Монтаж щита', 'шт', 4);

INSERT INTO postavshik (id, nazvanie, inn, kontaktnoe_litso, nomer_telefona, email, status_raboty) VALUES
(1, 'ООО "Электроснаб"', '7701234567', 'Иванов И.И.', '+7(495)123-45-67', 'info@electrosnab.ru', TRUE),
(2, 'ИП "Кабель-Сервис"', '7723456789', 'Петров П.П.', '+7(495)234-56-78', 'petrov@cable-service.ru', TRUE),
(3, 'ООО "Строй-Электро"', '7734567890', 'Сидоров С.С.', '+7(495)345-67-89', 'sidorov@stroy-electro.ru', FALSE);

INSERT INTO zagruzka (id, imia_faila, data_zagruzki) VALUES
(1, 'прайс_апрель_2026.xlsx', '2026-04-01 10:15:00'),
(2, 'новые_цены_апрель.xlsx', '2026-04-10 14:30:00'),
(3, 'прайс_май_2026.xlsx', '2026-05-01 09:00:00');

INSERT INTO cena (id, postavshik_id, tovar_id, zagruzka_id, cena, valuta, data) VALUES
(1,  1, 101, 1, 1500.00, 'RUB', '2026-04-01'),
(2,  1, 102, 1, 2300.00, 'RUB', '2026-04-01'),
(3,  1, 103, 1, 7800.00, 'RUB', '2026-04-01'),
(4,  1, 104, 1,  420.00, 'RUB', '2026-04-01'),
(5,  1, 105, 1,  450.00, 'RUB', '2026-04-01');

INSERT INTO cena (id, postavshik_id, tovar_id, zagruzka_id, cena, valuta, data) VALUES
(6,  1, 101, 2, 1550.00, 'RUB', '2026-04-10'),
(7,  1, 102, 2, 2350.00, 'RUB', '2026-04-10'),
(8,  1, 104, 2,  440.00, 'RUB', '2026-04-10');

INSERT INTO cena (id, postavshik_id, tovar_id, zagruzka_id, cena, valuta, data) VALUES
(9,  2, 101, 3, 1480.00, 'RUB', '2026-05-01'),
(10, 2, 106, 3,  320.00, 'RUB', '2026-05-01'),
(11, 2, 107, 3,  550.00, 'RUB', '2026-05-01');


SELECT 'kategoria_tovara' AS Таблица, COUNT(*) AS Количество FROM kategoria_tovara
UNION ALL
SELECT 'tovar', COUNT(*) FROM tovar
UNION ALL
SELECT 'postavshik', COUNT(*) FROM postavshik
UNION ALL
SELECT 'zagruzka', COUNT(*) FROM zagruzka
UNION ALL
SELECT 'cena', COUNT(*) FROM cena;

SELECT 
    p.nazvanie AS Поставщик,
    t.naimenovanie AS Товар,
    c.cena AS Цена,
    c.data AS Дата_цены,
    z.imia_faila AS Файл
FROM cena c
JOIN postavshik p ON p.id = c.postavshik_id
JOIN tovar t ON t.id = c.tovar_id
LEFT JOIN zagruzka z ON z.id = c.zagruzka_id
ORDER BY c.data DESC, p.nazvanie, t.naimenovanie;
