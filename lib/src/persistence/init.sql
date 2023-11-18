DROP TABLE IF EXISTS agency;
CREATE TABLE agency
(
  agency_id              text UNIQUE NULL,
  agency_name            text NOT NULL,
  agency_url             text NOT NULL,
  agency_timezone        text NOT NULL,
  agency_lang            text NULL,
  agency_phone           text NULL
);

DROP TABLE IF EXISTS stops;
CREATE TABLE stops
(
  stop_id                text PRIMARY KEY,
  stop_code              text NULL,
  stop_name              text NULL CHECK (location_type >= 0 AND location_type <= 2 AND stop_name IS NOT NULL OR location_type > 2),
  stop_desc              text NULL,
  stop_lat               double precision NULL CHECK (location_type >= 0 AND location_type <= 2 AND stop_name IS NOT NULL OR location_type > 2),
  stop_lon               double precision NULL CHECK (location_type >= 0 AND location_type <= 2 AND stop_name IS NOT NULL OR location_type > 2),
  location_type          integer NULL CHECK (location_type >= 0 AND location_type <= 4),
  parent_station         text NULL CHECK (location_type IS NULL OR location_type = 0 OR location_type = 1 AND parent_station IS NULL OR location_type >= 2 AND location_type <= 4 AND parent_station IS NOT NULL),
  wheelchair_boarding    integer NULL CHECK (wheelchair_boarding >= 0 AND wheelchair_boarding <= 2 OR wheelchair_boarding IS NULL),
  platform_code          text NULL,
  zone_id                text NULL
);

DROP TABLE IF EXISTS routes;
CREATE TABLE routes
(
  route_id               text PRIMARY KEY,
  agency_id              text NULL REFERENCES agency(agency_id) ON DELETE CASCADE ON UPDATE CASCADE,
  route_short_name       text NULL,
  route_long_name        text NULL CHECK (route_short_name IS NOT NULL OR route_long_name IS NOT NULL),
  route_type             integer NOT NULL,
  route_color            text NULL CHECK (route_color REGEXP '[a-fA-F0-9]{6}' OR route_color = ''),
  route_text_color       text NULL CHECK (route_color REGEXP '[a-fA-F0-9]{6}' OR route_color = ''),
  route_desc             text NULL
);

DROP TABLE IF EXISTS trips;
CREATE TABLE trips
(
  route_id               text NOT NULL REFERENCES routes ON DELETE CASCADE ON UPDATE CASCADE,
  service_id             text NOT NULL,
  trip_id                text NOT NULL PRIMARY KEY,
  trip_headsign          text NULL,
  trip_short_name        text NULL,
  direction_id           boolean NULL,
  block_id               text NULL,
  shape_id               text NULL,
  wheelchair_accessible  integer NULL CHECK (wheelchair_accessible >= 0 AND wheelchair_accessible <= 2),
  bikes_allowed          integer NULL CHECK (bikes_allowed >= 0 AND bikes_allowed <= 2)
);

DROP TABLE IF EXISTS stop_times;
CREATE TABLE stop_times
(
  trip_id                text NOT NULL REFERENCES trips ON DELETE CASCADE ON UPDATE CASCADE,
  arrival_time           interval NULL,
  departure_time         interval NOT NULL,
  stop_id                text NOT NULL REFERENCES stops ON DELETE CASCADE ON UPDATE CASCADE,
  stop_sequence          integer NOT NULL CHECK (stop_sequence >= 0),
  pickup_type            integer NOT NULL CHECK (pickup_type >= 0 AND pickup_type <= 3),
  drop_off_type          integer NOT NULL CHECK (drop_off_type >= 0 AND drop_off_type <= 3),
  stop_headsign          text NULL
);

DROP TABLE IF EXISTS calendar;
CREATE TABLE calendar
(
  service_id             text PRIMARY KEY,
  monday                 boolean NOT NULL,
  tuesday                boolean NOT NULL,
  wednesday              boolean NOT NULL,
  thursday               boolean NOT NULL,
  friday                 boolean NOT NULL,
  saturday               boolean NOT NULL,
  sunday                 boolean NOT NULL,
  start_date             numeric(8) NOT NULL,
  end_date               numeric(8) NOT NULL
);

DROP TABLE IF EXISTS calendar_dates;
CREATE TABLE calendar_dates
(
  service_id             text NOT NULL,
  date                   numeric(8) NOT NULL,
  exception_type         integer NOT NULL CHECK (exception_type >= 1 AND exception_type <= 2)
);

DROP TABLE IF EXISTS shapes;
CREATE TABLE shapes
(
  shape_id               text NOT NULL,
  shape_pt_lat           double precision NOT NULL,
  shape_pt_lon           double precision NOT NULL,
  shape_pt_sequence      integer NOT NULL CHECK (shape_pt_sequence >= 0)
);

INSERT INTO agency (agency_id, agency_name, agency_url, agency_timezone, agency_lang)
VALUES (0, 'CODESA', 'www.codesa.com.uy', 'America/Montevideo', 'es-UY');

INSERT INTO stops (stop_id, stop_code, stop_name, stop_lat, stop_lon)
VALUES
  (1,1,'AG. SAN CARLOS',-54.9098665,-34.7919818),
  (2,2,'',-54.9103077,-34.7947318),
  (3,3,'',-54.9104968,-34.7976602),
  (4,4,'',-54.9131428,-34.7975412),
  (5,5,'',-54.916572,-34.7973518),
  (6,6,'',-54.9166001,-34.7955666),
  (7,7,'',-54.9164741,-34.7927736),
  (8,8,'',-34.79085,-54.91636),
  (9,9,'AV ALVARIZA',-34.7905406,-54.9206975),
  (10,10,'',-54.9221604,-34.7932362),
  (11,11,'',-54.9223401,-34.7969697),
  (13,13,'',-54.9214965,-34.7985984),
  (14,14,'',-34.80032,-54.92159),
  (15,15,'',-34.80743,-54.92715),
  (16,16,'',-34.82358,-54.94373),
  (17,17,'',-34.82675,-54.94285),
  (18,18,'',-34.83776,-54.94221),
  (19,19,'',-34.84085,-54.942),
  (20,20,'',-34.84437,-54.94191),
  (21,21,'',-34.85349,-54.94326),
  (22,22,'',-34.86006,-54.94542),
  (29,29,'AG: MALDONADO',-34.8931842,-54.9533841),
  (30,30,'FCO AGUILAR',-34.8957251,-54.9536366),
  (34,34,'RINCON',-34.9045653,-54.9554752),
  (35,35,'ITUZAINGO',-34.9071206,-54.9555646),
  (36,36,'R P DEL PUERTO',-34.9098914,-54.9555503),
  (37,37,'3 DE FEBRERO',-34.9125812,-54.9555324),
  (38,38,'SARANDI',-34.9126789,-54.9573676),
  (39,39,'A LEDESMA',-34.9139669,-54.9586144),
  (40,40,'TNAL MALDONADO',-34.916387,-54.958104),
  (41,41,'MALDONADO P20',-34.9226679,-54.9524178),
  (42,42,'Z MICHELLINI',-34.913971,-54.961455),
  (43,43,'HAITI',-34.9132026,-54.9645918),
  (44,44,'CUBA',-34.91370261,-54.96760234),
  (96,96,'P17 M GUTIERREZ',-34.9303398,-54.9583263),
  (102,102,'P23 BRASILIA',-34.9218535,-54.9686745),
  (103,103,'P24 CARACAS',-34.920282,-54.9704247),
  (104,104,'ECUADOR',-34.9178967,-54.970749),
  (108,108,'MAUTONE',-34.9142018,-54.9616536),
  (109,109,'TNAL MALDONADO',-34.916778,-54.958087),
  (110,110,'A LEDESMA',-34.9137799,-54.9594792),
  (111,111,'R P DEL PUERTO',-34.9102601,-54.9597136),
  (112,112,'ITUZAINGO',-34.9074303,-54.9597955),
  (113,113,'R BERGALLI',-34.9047031,-54.9598874),
  (114,114,'AV LAVALLEJA',-34.9020113,-54.9600143),
  (115,115,'R GUERRA',-34.9019618,-54.9568443),
  (116,116,'A TAMARO',-34.9009412,-54.953446),
  (117,117,'COCA COLA',-34.8985021,-54.9534589),
  (119,119,'AG MALDONADO',-34.8932811,-54.9530644),
  (132,132,'LOS TALAS',-34.8004672,-54.9214021),
  (134,134,'',-54.9210298,-34.7946602),
  (135,135,'',-54.9188948,-34.7937439),
  (137,137,'L OLIVERA',-34.7938806,-54.9120611),
  (138,138,'AGENCIA S.CARLOS',-34.7921371,-54.9099415),
  (140,140,'L OLIVERA',-34.7909875,-54.9117351),
  (141,141,'',-54.9162742,-34.7907593),
  (146,146,'P18 AV ROOSEVELT',-34.925856,-54.9490074),
  (148,148,'P15',-34.9284002,-54.9461741),
  (149,149,'P13',-34.931334,-54.9431644),
  (168,168,'P18 S BOLIVAR',-34.922491,-54.9522895),
  (174,174,'',-54.9251497,-34.7903429),
  (175,175,'',-54.928143,-34.7901843),
  (176,176,'',-54.9307716,-34.7900654),
  (178,178,'',-54.9293929,-34.7935633),
  (180,180,'',-54.9222583,-34.7936999),
  (181,181,'',-54.9188626,-34.7753364),
  (185,185,'',-54.9231112,-34.780289),
  (186,186,'B ARAUJO',-34.7838791,-54.9206473),
  (187,187,'EJIDO',-34.7867105,-54.9208195),
  (188,188,'C A CAL',-34.7871244,-54.9187124),
  (189,189,'M. SOLER',-34.7872513,-54.9163773),
  (190,190,'',-54.9139488,-34.7874176),
  (191,191,'',-54.9100113,-34.7876555),
  (193,193,'',-54.9238622,-34.7988011),
  (198,198,'',-54.9262507,-34.8015497),
  (201,201,'',-54.9221295,-34.7962946),
  (202,202,'',-54.9219954,-34.7937792),
  (206,206,'',-54.916234,-34.7871269),
  (207,207,'C A CAL',-34.7871244,-54.9187124),
  (209,209,'B ARAUJO',-34.7841387,-54.9203995),
  (210,210,'',-54.9203029,-34.7819632),
  (211,211,'',-54.9197048,-34.7787546),
  (218,218,'SARANDI',-34.9056037,-54.9578707),
  (295,295,'P20A DE FIGUEROA',-34.9191593,-54.9558923),
  (297,297,'',-54.9073774,-34.7912152),
  (301,301,'',-54.8676431,-34.7853822),
  (304,304,'',-54.8612809,-34.8008648),
  (307,307,'',-54.8450214,-34.812645),
  (309,309,'',-54.8300144,-34.8249013),
  (310,310,'',-54.8282763,-34.8323761),
  (311,311,'',-54.827815,-34.8356609),
  (313,313,'',-54.8227939,-34.8587386),
  (314,314,'',-54.8215762,-34.862238),
  (315,315,'',-54.8194224,-34.868618),
  (316,316,'',-54.8230755,-34.879033),
  (318,318,'',-54.8231399,-34.8884479),
  (320,320,'',-54.8147647,-34.8992069),
  (321,321,'',-54.8113918,-34.8986955),
  (322,322,'',-54.8090127,-34.8983666),
  (323,323,'',-54.8095036,-34.8991663),
  (324,324,'',-54.8115394,-34.9000484),
  (326,326,'',-54.8107964,-34.9038716),
  (327,327,'',-54.8160857,-34.9051386),
  (329,329,'',-54.8247117,-34.9057589),
  (330,330,'',-54.8285928,-34.9049054),
  (331,331,'',-54.8375621,-34.9065398),
  (333,333,'',-54.843522,-34.9111655),
  (334,334,'',-54.8468587,-34.9109807),
  (335,335,'',-54.8484305,-34.9081125),
  (336,336,'',-54.849388,-34.9146451),
  (337,337,'',-54.8525879,-34.9154457),
  (338,338,'',-54.8549794,-34.915309),
  (339,339,'',-54.857794,-34.9150916),
  (341,341,'',-54.8624825,-34.9143547),
  (343,343,'',-54.8652533,-34.9094697),
  (344,344,'',-54.8680294,-34.9088934),
  (346,346,'',-54.8729861,-34.9093179),
  (347,347,'',-54.8715028,-34.9087196),
  (348,348,'',-54.8691666,-34.9089528),
  (349,349,'',-54.8660392,-34.9098722),
  (351,351,'',-54.8613453,-34.9148562),
  (353,353,'LAS BRISAS',-34.915335,-54.8549535),
  (355,355,'',-54.849557,-34.915008),
  (358,358,'',-54.8436964,-34.9115746),
  (359,359,'',-54.8407808,-34.9093201),
  (364,364,'',-54.8226088,-34.9063638),
  (365,365,'',-54.8109707,-34.9043115),
  (367,367,'',-54.8103699,-34.9021822),
  (369,369,'',-54.8087686,-34.8991421),
  (370,370,'',-54.8087981,-34.8983963),
  (371,371,'',-54.8111907,-34.8986097),
  (374,374,'',-54.8189342,-34.8967354),
  (375,375,'',-54.8197442,-34.8950128),
  (377,377,'',-54.824084,-34.8860762),
  (380,380,'',-54.8204443,-34.8651211),
  (382,382,'',-54.8260823,-34.8446691),
  (383,383,'',-54.8269486,-34.8383864),
  (384,384,'',-54.8283273,-34.8311388),
  (386,386,'',-54.8409498,-34.8157412),
  (388,388,'',-54.8516116,-34.8087427),
  (389,389,'',-54.8580569,-34.8034263),
  (390,390,'',-54.8662457,-34.795995),
  (391,391,'',-54.8656717,-34.7902945),
  (392,392,'',-54.8680401,-34.784142),
  (393,393,'',-54.8875666,-34.7848645),
  (394,394,'',-54.8932877,-34.7870476),
  (395,395,'',-54.901911,-34.7903451),
  (422,422,'FERMENTARIO',-34.9506901,-54.9353608),
  (423,423,'J LENZINA',-34.953478,-54.9400655),
  (587,587,'',-54.9216413,-34.7876225),
  (594,594,'SCARONE',-34.8944462,-54.9495102),
  (606,606,'CIGUEÑAS',-34.9019046,-54.9652406),
  (612,612,'ÑANDUBAY',-34.9092263,-54.9633057),
  (625,625,'25 DE MAYO',-34.9094714,-54.9629605),
  (628,628,'B-9',-34.9036922,-54.9701841),
  (635,635,'SAN CARLOS',-34.9055619,-54.9546249),
  (719,719,'SAN CARLOS',-34.912629,-54.9542557),
  (720,720,'19 DE ABRIL',-34.9142784,-54.9527285),
  (721,721,'ESC CACHIMBA',-34.9142134,-54.9502866),
  (722,722,'A SANTANA',-34.911182,-54.9495066),
  (723,723,'AV AIGUA',-34.9082834,-54.9493937),
  (724,724,'MASETTI',-34.9070941,-54.94096935),
  (767,767,'',-54.9199355,-34.797158),
  (791,791,'',-54.8074329,-34.9026287),
  (826,826,'HECTOR SORIA',-34.8371577,-54.6551434),
  (850,850,'',-54.8078057,-34.9027453),
  (851,851,'',-54.8105711,-34.9040893),
  (869,869,'',-54.9312034,-34.795365),
  (876,876,'',-54.808562,-34.8998262),
  (897,897,'',-54.9289799,-34.7893693),
  (985,985,'CAMALEON',-34.9026101,-54.9946309),
  (987,987,'CNO A LA LAGUNA',-34.9082829,-54.9910118),
  (1024,1024,'',-54.9075115,-34.7878274),
  (1025,1025,'',-54.9274564,-34.7935897),
  (1029,1029,'CIGUEÑAS',-34.9019046,-54.9652406),
  (1074,1074,'',-54.8697674,-34.7835714),
  (1075,1075,'',-54.8165846,-34.8994764),
  (1076,1076,'',-54.8262084,-34.9054092),
  (1077,1077,'',-54.8350055,-34.905576),
  (1078,1078,'',-54.8457482,-34.9127777),
  (1079,1079,'',-54.8375621,-34.9068345),
  (1090,1090,'',-54.9131133,-34.7946613),
  (1091,1091,'',-54.9132272,-34.7963914),
  (1093,1093,'TNAL. MALDONADO',-34.9164294,-54.9585493),
  (1096,1096,'',-54.9306052,-34.7969311),
  (1097,1097,'',-54.9315602,-34.7935853),
  (1098,1098,'',-54.9186748,-34.7917439),
  (1101,1101,'',-54.9231327,-34.788475),
  (1102,1102,'',-54.9243021,-34.7784825),
  (1103,1103,'',-54.9258149,-34.7767993),
  (1104,1104,'',-54.9236584,-34.7758388),
  (1105,1105,'',-54.921931,-34.7790553),
  (1106,1106,'',-54.920193,-34.7811614),
  (1108,1108,'',-54.9165291,-34.7789848),
  (1109,1109,'',-54.9124467,-34.7792271),
  (1110,1110,'',-54.9095178,-34.7794254),
  (1111,1111,'',-54.9091476,-34.7817121),
  (1112,1112,'',-54.9095285,-34.7847786),
  (1113,1113,'',-54.9128813,-34.7844922),
  (1114,1114,'',-54.9162233,-34.7841089),
  (1115,1115,'',-54.9165666,-34.7870167),
  (1117,1117,'',-54.915365,-34.7916998),
  (1118,1118,'',-54.9154696,-34.7936558),
  (1119,1119,'',-54.904907,-34.7914994),
  (1157,1157,'AV. EJID',-34.7872513,-54.9163773),
  (2340,2340,'',-54.8490313,-34.9130659),
  (2341,2341,'',-54.8510537,-34.9122433),
  (2342,2342,'',-54.8553881,-34.9139127),
  (2343,2343,'',-54.8587757,-34.9136641),
  (2344,2344,'',-54.8608571,-34.9134508),
  (2345,2345,'',-54.8618415,-34.9093135),
  (2346,2346,'',-54.8643091,-34.9091991),
  (3509,3509,'',-54.8638156,-34.9133452);

INSERT into calendar
VALUES ('WEEK', TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, 20230101, 20240101);

INSERT INTO routes (route_id, agency_id, route_short_name, route_long_name, route_type)
VALUES (12, 0, '12', 'PUNTA DEL ESTE', 3);

INSERT INTO trips (route_id, service_id, trip_id, trip_headsign, trip_short_name, direction_id, shape_id)
VALUES
(12, 'WEEK', 121, 'PUNTA DEL ESTE', 'PUNTA DEL ESTE', 0, 121),
(12, 'WEEK', 122, 'MALDONADO', 'MALDONADO', 1, 122),
(12, 'WEEK', 123, 'OTRO PUNTA DEL ESTE', 'OTRO PUNTA DEL ESTE', 0, 123),
(12, 'WEEK', 124, 'OTRO MALDONADO', 'OTRO MALDONADO', 1, 124);

INSERT into stop_times(trip_id, arrival_time, departure_time, stop_id, stop_sequence, pickup_type, drop_off_type)
VALUES 
(121, '14:30:00', '14:30:00', 111, 1, 0, 0),
(121, '14:35:00', '14:35:00', 112, 2, 0, 0);

.mode box

SELECT * FROM agency;
