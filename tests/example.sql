PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE accounttype (
	id INTEGER NOT NULL, 
	name TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO accounttype VALUES(0,'Compte bancaire');
INSERT INTO accounttype VALUES(1,'Compte de caisse');
INSERT INTO accounttype VALUES(2,'Compte de passif');
INSERT INTO accounttype VALUES(3,'Compte d''actif');
CREATE TABLE bank (
	id INTEGER NOT NULL, 
	name TEXT, 
	code INTEGER, 
	bic TEXT, 
	address TEXT, 
	tel TEXT, 
	mail TEXT, 
	web TEXT, 
	contact_name TEXT, 
	contact_fax TEXT, 
	contact_tel TEXT, 
	contact_mail TEXT, 
	notes TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO bank VALUES(1,'Banque Route',98765,NULL,'Rue Hiné  12345  Morzy-les-Gracieuses','01 69 31 01 01','banqueroute@arnaque.com','www.arnaque.com','Luc Ratif','01 69 31 01 99','01 69 31 01 02','luc.ratif@arnaque.com','Absent le mercredi');
INSERT INTO bank VALUES(2,'Crédit Bitoire',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO bank VALUES(3,'Banque Ize',99887766,NULL,'Rue de la Patinoire 99999 Saquaille',NULL,NULL,NULL,'O.Léonce Laipelle',NULL,NULL,NULL,NULL);
INSERT INTO bank VALUES(4,'Banque Haite',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO bank VALUES(5,'Compte CB DD',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
CREATE TABLE categorytype (
	id INTEGER NOT NULL, 
	name TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO categorytype VALUES(0,'Credit');
INSERT INTO categorytype VALUES(1,'Debit');
CREATE TABLE currency (
	id INTEGER NOT NULL, 
	name TEXT, 
	nickname TEXT, 
	code TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO currency VALUES(1,'Euro','EUR','€');
INSERT INTO currency VALUES(2,'Dinar tunisien','TND',NULL);
CREATE TABLE party (
	id INTEGER NOT NULL, 
	name TEXT, 
	"desc" TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO party VALUES(1,'Huguette Lefacteur',NULL);
INSERT INTO party VALUES(2,'Editions Nialley',NULL);
INSERT INTO party VALUES(3,'Raquel Merdiestruck',NULL);
INSERT INTO party VALUES(4,'Tchang Padmain - Tchang Savieng',NULL);
INSERT INTO party VALUES(5,'Djemal Ozizi',NULL);
INSERT INTO party VALUES(6,'Juan Mortaïm',NULL);
INSERT INTO party VALUES(7,'Henri Ponsat-Vautré et Honoré Dutans',NULL);
INSERT INTO party VALUES(8,'Abderramane Tafrez',NULL);
INSERT INTO party VALUES(9,'Henriette Dumant',NULL);
INSERT INTO party VALUES(10,'DAB Orlay Caupains',NULL);
INSERT INTO party VALUES(11,'Jean-Philippe Herbien',NULL);
INSERT INTO party VALUES(12,'Ahmed Donsaha-Saplass',NULL);
INSERT INTO party VALUES(13,'Elvire Sacuty',NULL);
INSERT INTO party VALUES(14,'Lepain Sylvestre',NULL);
INSERT INTO party VALUES(15,'Sebastienne Tousseul',NULL);
INSERT INTO party VALUES(16,'Toto',NULL);
INSERT INTO party VALUES(17,'Liquidités',NULL);
INSERT INTO party VALUES(18,'Chevalier Tarauld',NULL);
INSERT INTO party VALUES(19,'DAB Orlay-Caupains',NULL);
INSERT INTO party VALUES(20,'Alimentation du compte sur livret',NULL);
INSERT INTO party VALUES(21,'Crédit Bitoire',NULL);
INSERT INTO party VALUES(22,'Essai',NULL);
INSERT INTO party VALUES(23,'Moktar Ritto',NULL);
INSERT INTO party VALUES(24,'Solde d''ouverture',NULL);
INSERT INTO party VALUES(25,'GRISBI RAZ CB DD','Remise à zéro automatique du solde du Compte CB DD');
INSERT INTO party VALUES(26,'GRISBI DÉBIT COMPTE PRINCIPAL','Débit automatique du montant du solde du Compte CB DD à partir du compte principal (= Compte Madame)');
CREATE TABLE paymenttype (
	id INTEGER NOT NULL, 
	name TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO paymenttype VALUES(0,'Neutral');
INSERT INTO paymenttype VALUES(1,'Debit');
INSERT INTO paymenttype VALUES(2,'Credit');
CREATE TABLE user (
	id INTEGER NOT NULL, 
	login TEXT, 
	firstname TEXT, 
	lastname TEXT, 
	password TEXT, 
	active INTEGER, 
	scopes_str TEXT, 
	notes TEXT, 
	PRIMARY KEY (id)
);
INSERT INTO user VALUES(1,'gsb2qdb','tool','gsb2qdb',NULL,NULL,NULL,'gsb2qdb tool');
CREATE TABLE account (
	id INTEGER NOT NULL, 
	name TEXT, 
	bank_id INTEGER, 
	bank_branch TEXT, 
	bank_account TEXT, 
	bank_account_key TEXT, 
	"bank_IBAN" TEXT, 
	currency_id INTEGER, 
	open_date DATETIME, 
	close_date DATETIME, 
	type_id INTEGER, 
	initial_balance FLOAT, 
	mini_balance_wanted FLOAT, 
	mini_balance_auth FLOAT, 
	holder_name TEXT, 
	holder_address TEXT, 
	notes TEXT, 
	PRIMARY KEY (id), 
	FOREIGN KEY(bank_id) REFERENCES bank (id), 
	FOREIGN KEY(currency_id) REFERENCES currency (id), 
	FOREIGN KEY(type_id) REFERENCES accounttype (id)
);
INSERT INTO account VALUES(1,'Compte Monsieur',-1,'Près de chez moi','1122334455',NULL,NULL,1,'1970-01-01 01:00:00.000000',NULL,0,0.0,0.0,0.0,'G.L. Inuit','10 Rue du Groenland&#xA;99999 Saquaille',NULL);
INSERT INTO account VALUES(2,'Emprunt voiture',2,NULL,NULL,NULL,NULL,1,'1970-01-01 01:00:00.000000',NULL,2,-20000.0,0.0,0.0,NULL,NULL,NULL);
INSERT INTO account VALUES(3,'Actif',1,NULL,NULL,NULL,NULL,1,'1970-01-01 01:00:00.000000',NULL,3,0.0,0.0,0.0,NULL,NULL,NULL);
INSERT INTO account VALUES(4,'Porte monnaie',1,NULL,NULL,NULL,NULL,1,'1970-01-01 01:00:00.000000',NULL,1,0.0,0.0,0.0,NULL,NULL,NULL);
INSERT INTO account VALUES(5,'Compte Madame',1,NULL,NULL,NULL,NULL,1,'1970-01-01 01:00:00.000000',NULL,0,1000.0,0.0,0.0,'Capucine De Jardin',NULL,NULL);
INSERT INTO account VALUES(6,'Livret',1,NULL,NULL,NULL,NULL,1,'1970-01-01 01:00:00.000000',NULL,0,0.0,0.0,0.0,NULL,NULL,NULL);
INSERT INTO account VALUES(7,'Compte CB DD',1,NULL,NULL,NULL,NULL,1,'1970-01-01 01:00:00.000000',NULL,2,0.0,-1799.9999999999999999,-2000.0,NULL,NULL,NULL);
CREATE TABLE auditlog (
	id INTEGER NOT NULL, 
	user_id INTEGER, 
	date DATETIME, 
	notes TEXT, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES user (id)
);
INSERT INTO auditlog VALUES(1,1,'2022-10-10 14:30:19.096844','automatic import by gsb2qdb tool');
INSERT INTO auditlog VALUES(2,1,'2022-10-10 17:08:32.194934','automatic import by gsb2qdb tool');
INSERT INTO auditlog VALUES(3,1,'2022-10-10 17:16:14.828864','automatic import by gsb2qdb tool');
CREATE TABLE category (
	id INTEGER NOT NULL, 
	name TEXT, 
	type_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(type_id) REFERENCES categorytype (id)
);
INSERT INTO category VALUES(23,'Loisirs',1);
INSERT INTO category VALUES(24,'Santé',1);
INSERT INTO category VALUES(25,'Revenus',0);
INSERT INTO category VALUES(26,'Alimentation',1);
INSERT INTO category VALUES(27,'Logement',1);
INSERT INTO category VALUES(28,'Frais divers',1);
INSERT INTO category VALUES(29,'Frais financiers',1);
INSERT INTO category VALUES(30,'Animaux domestiques',1);
INSERT INTO category VALUES(31,'Soins',1);
INSERT INTO category VALUES(32,'Raz CB DD',0);
INSERT INTO category VALUES(33,'Débit CB DD',1);
CREATE TABLE subcategory (
	id INTEGER NOT NULL, 
	category_id INTEGER NOT NULL, 
	name TEXT, 
	PRIMARY KEY (id, category_id), 
	FOREIGN KEY(category_id) REFERENCES category (id)
);
INSERT INTO subcategory VALUES(1,23,'Bar');
INSERT INTO subcategory VALUES(2,23,'Lecture');
INSERT INTO subcategory VALUES(3,23,'Voile');
INSERT INTO subcategory VALUES(4,23,'Spectacles');
INSERT INTO subcategory VALUES(1,24,'Kinésithérapeute');
INSERT INTO subcategory VALUES(2,24,'Dentiste');
INSERT INTO subcategory VALUES(1,25,'Salaire traduction');
INSERT INTO subcategory VALUES(2,25,'Divers');
INSERT INTO subcategory VALUES(1,26,'Boissons');
INSERT INTO subcategory VALUES(2,26,'Epicerie');
INSERT INTO subcategory VALUES(3,26,'Boulangerie');
INSERT INTO subcategory VALUES(1,27,'Produits d''entretien');
INSERT INTO subcategory VALUES(2,27,'Jardin');
INSERT INTO subcategory VALUES(3,27,'Salarié à domicile');
INSERT INTO subcategory VALUES(1,28,'Cadeaux');
INSERT INTO subcategory VALUES(1,29,'Divers');
INSERT INTO subcategory VALUES(1,30,'Toilettage');
INSERT INTO subcategory VALUES(1,31,'Habillement');
CREATE TABLE currencylink (
	id INTEGER NOT NULL, 
	cur1_id INTEGER, 
	cur2_id INTEGER, 
	rate FLOAT, 
	date DATETIME, 
	log_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(cur1_id) REFERENCES currency (id), 
	FOREIGN KEY(cur2_id) REFERENCES currency (id), 
	FOREIGN KEY(log_id) REFERENCES auditlog (id)
);
INSERT INTO currencylink VALUES(1,1,2,1.9499999999999999555,'2011-10-26 00:00:00.000000',1);
CREATE TABLE payment (
	id INTEGER NOT NULL, 
	name TEXT, 
	account_id INTEGER, 
	current INTEGER, 
	type_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(account_id) REFERENCES account (id), 
	FOREIGN KEY(type_id) REFERENCES paymenttype (id)
);
INSERT INTO payment VALUES(1,'Virement',1,NULL,0);
INSERT INTO payment VALUES(2,'Dépôt',1,NULL,2);
INSERT INTO payment VALUES(3,'Carte de crédit',1,NULL,1);
INSERT INTO payment VALUES(4,'Prélèvement',1,NULL,1);
INSERT INTO payment VALUES(5,'Chèque',1,5000000,1);
INSERT INTO payment VALUES(6,'Virement',2,NULL,0);
INSERT INTO payment VALUES(7,'Virement',5,NULL,0);
INSERT INTO payment VALUES(8,'Dépôt',5,NULL,2);
INSERT INTO payment VALUES(9,'Carte de crédit',5,NULL,1);
INSERT INTO payment VALUES(10,'Prélèvement',5,NULL,1);
INSERT INTO payment VALUES(11,'Chèque',5,1234567,1);
INSERT INTO payment VALUES(12,'Virement',6,NULL,0);
INSERT INTO payment VALUES(13,'Dépôt',6,NULL,2);
INSERT INTO payment VALUES(14,'Carte de crédit',6,NULL,1);
INSERT INTO payment VALUES(15,'Prélèvement',6,NULL,1);
INSERT INTO payment VALUES(16,'Chèque',6,NULL,1);
INSERT INTO payment VALUES(17,'Virement',7,NULL,0);
INSERT INTO payment VALUES(18,'CB',7,NULL,1);
CREATE TABLE reconcile (
	id INTEGER NOT NULL, 
	name TEXT, 
	account_id INTEGER, 
	start_date DATETIME, 
	end_date DATETIME, 
	start_balance FLOAT, 
	end_balance FLOAT, 
	log_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(account_id) REFERENCES account (id), 
	FOREIGN KEY(log_id) REFERENCES auditlog (id)
);
INSERT INTO reconcile VALUES(1,'Monsieur1',1,NULL,'2011-09-30 00:00:00.000000',0.0,1500.0,1);
INSERT INTO reconcile VALUES(2,'Monsieur2',1,'2011-09-30 00:00:00.000000','2011-10-06 00:00:00.000000',1500.0,4008.0000000000000001,1);
INSERT INTO reconcile VALUES(3,'Monsieur3',1,'2011-10-06 00:00:00.000000','2011-10-30 00:00:00.000000',4008.0000000000000001,2841.3299999999999272,1);
CREATE TABLE scheduled (
	id INTEGER NOT NULL, 
	account_id INTEGER, 
	start_date DATETIME, 
	limit_date DATETIME, 
	frequency INTEGER, 
	automatic INTEGER, 
	party_id INTEGER, 
	category_id INTEGER, 
	sub_category_id INTEGER, 
	notes TEXT, 
	amount FLOAT, 
	currency_id INTEGER, 
	payment_id INTEGER, 
	splitted INTEGER, 
	master_id INTEGER, 
	log_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(account_id) REFERENCES account (id), 
	FOREIGN KEY(party_id) REFERENCES party (id), 
	FOREIGN KEY(category_id) REFERENCES category (id), 
	FOREIGN KEY(sub_category_id) REFERENCES subcategory (id), 
	FOREIGN KEY(currency_id) REFERENCES currency (id), 
	FOREIGN KEY(payment_id) REFERENCES payment (id), 
	FOREIGN KEY(master_id) REFERENCES scheduled (id), 
	FOREIGN KEY(log_id) REFERENCES auditlog (id)
);
INSERT INTO scheduled VALUES(2,1,'2013-04-10 00:00:00.000000','2015-10-10 00:00:00.000000',2,1,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,4,NULL,0,1);
INSERT INTO scheduled VALUES(3,5,'2011-10-21 00:00:00.000000',NULL,1,0,12,27,3,'Rangement de la maison',-25.0,1,7,NULL,0,1);
CREATE TABLE transact (
	id INTEGER NOT NULL, 
	account_id INTEGER, 
	transaction_date DATETIME, 
	value_date DATETIME, 
	party_id INTEGER, 
	category_id INTEGER, 
	sub_category_id INTEGER, 
	notes TEXT, 
	amount FLOAT, 
	currency_id INTEGER, 
	exchange_rate FLOAT, 
	exchange_fees FLOAT, 
	payment_id INTEGER, 
	master_id INTEGER, 
	reconcile_id INTEGER, 
	log_id INTEGER, 
	PRIMARY KEY (id), 
	FOREIGN KEY(account_id) REFERENCES account (id), 
	FOREIGN KEY(party_id) REFERENCES party (id), 
	FOREIGN KEY(category_id) REFERENCES category (id), 
	FOREIGN KEY(sub_category_id) REFERENCES subcategory (id), 
	FOREIGN KEY(currency_id) REFERENCES currency (id), 
	FOREIGN KEY(payment_id) REFERENCES payment (id), 
	FOREIGN KEY(master_id) REFERENCES transact (id), 
	FOREIGN KEY(reconcile_id) REFERENCES reconcile (id), 
	FOREIGN KEY(log_id) REFERENCES auditlog (id)
);
INSERT INTO transact VALUES(1,1,'2011-10-06 00:00:00.000000',NULL,17,0,0,'Argent du ménage',-500.0,1,0.0,0.0,3,0,2,1);
INSERT INTO transact VALUES(2,4,'2011-10-06 00:00:00.000000',NULL,17,0,0,'Argent du ménage',500.0,1,0.0,0.0,3,0,0,1);
INSERT INTO transact VALUES(3,1,'2011-10-05 00:00:00.000000',NULL,4,24,1,'Massage chinois',-22.0,1,0.0,0.0,3,0,2,1);
INSERT INTO transact VALUES(4,1,'2011-10-06 00:00:00.000000',NULL,5,23,3,'Rénovation de la bite d''amarrage',-270.0,1,0.0,0.0,5,0,2,1);
INSERT INTO transact VALUES(5,5,'2011-10-06 00:00:00.000000',NULL,6,27,2,'Deuxième tonte de la pelouse',-80.0,1,0.0,0.0,11,0,0,1);
INSERT INTO transact VALUES(6,1,'2011-10-06 00:00:00.000000',NULL,7,29,1,'Frais de Notaire',-200.0,1,0.0,0.0,5,0,2,1);
INSERT INTO transact VALUES(7,1,'2011-10-07 00:00:00.000000',NULL,8,24,2,'Couronne de lauriers',-750.0,1,0.0,0.0,5,0,3,1);
INSERT INTO transact VALUES(12,5,'2011-10-07 00:00:00.000000',NULL,4,24,1,'Massage chinois',-22.0,1,0.0,0.0,11,0,0,1);
INSERT INTO transact VALUES(14,5,'2011-10-07 00:00:00.000000',NULL,11,28,1,'Virement Swift',-359.99999999999999999,1,0.0,0.0,7,0,0,1);
INSERT INTO transact VALUES(15,1,'2011-10-06 00:00:00.000000',NULL,2,25,1,NULL,3500.0,1,0.0,0.0,2,0,2,1);
INSERT INTO transact VALUES(16,4,'2011-10-07 00:00:00.000000',NULL,19,23,1,NULL,-50.0,1,0.0,0.0,0,0,0,1);
INSERT INTO transact VALUES(17,4,'2011-10-12 00:00:00.000000',NULL,13,23,3,'Remarquage à la rame',-15.699999999999999289,1,0.0,0.0,0,0,0,1);
INSERT INTO transact VALUES(18,4,'2011-10-12 00:00:00.000000',NULL,14,26,3,'Grosse miche',-3.5899999999999998578,1,0.0,0.0,0,0,0,1);
INSERT INTO transact VALUES(19,4,'2011-10-12 00:00:00.000000',NULL,15,31,1,'Collants pour ....',-12.839999999999999857,1,0.0,0.0,0,0,0,1);
INSERT INTO transact VALUES(21,5,'2011-10-01 00:00:00.000000',NULL,1,25,2,'Anniversaire du poisson rouget',15.0,1,0.0,0.0,8,0,0,1);
INSERT INTO transact VALUES(22,5,'2011-10-06 00:00:00.000000',NULL,3,30,1,'Toilettage de la chatte',-13.849999999999999644,1,0.0,0.0,9,0,0,1);
INSERT INTO transact VALUES(23,5,'2011-10-07 00:00:00.000000',NULL,20,0,0,NULL,-110.0,1,0.0,0.0,7,0,0,1);
INSERT INTO transact VALUES(24,6,'2011-10-07 00:00:00.000000',NULL,20,0,0,NULL,110.0,1,0.0,0.0,13,0,0,1);
INSERT INTO transact VALUES(25,1,'2011-10-10 00:00:00.000000',NULL,21,0,0,NULL,-416.67000000000001592,1,0.0,0.0,4,0,3,1);
INSERT INTO transact VALUES(26,2,'2011-10-10 00:00:00.000000',NULL,21,0,0,NULL,416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(27,5,'2011-10-07 00:00:00.000000',NULL,12,27,3,'Rangement de la maison',-25.0,1,0.0,0.0,7,0,0,1);
INSERT INTO transact VALUES(28,5,'2011-10-14 00:00:00.000000',NULL,12,27,3,'Rangement de la maison',-25.0,1,0.0,0.0,7,0,0,1);
INSERT INTO transact VALUES(29,5,'2011-10-15 00:00:00.000000',NULL,23,23,4,NULL,-128.99999999999999999,2,1.9499999999999999555,0.0,9,0,0,1);
INSERT INTO transact VALUES(30,1,'2011-09-30 00:00:00.000000',NULL,24,25,2,NULL,1500.0,1,1.9499999999999999555,0.0,2,0,1,1);
INSERT INTO transact VALUES(31,5,'2011-10-05 00:00:00.000000',NULL,9,0,0,'Bazar des Unes aux Diers',-147.24999999999999999,1,0.0,0.0,9,0,0,1);
INSERT INTO transact VALUES(32,5,'2011-10-05 00:00:00.000000',NULL,9,26,2,NULL,-83.489999999999994885,1,0.0,0.0,9,31,0,1);
INSERT INTO transact VALUES(33,5,'2011-10-05 00:00:00.000000',NULL,9,26,1,NULL,-20.0,1,0.0,0.0,9,31,0,1);
INSERT INTO transact VALUES(34,5,'2011-10-05 00:00:00.000000',NULL,9,27,1,NULL,-13.759999999999999786,1,0.0,0.0,9,31,0,1);
INSERT INTO transact VALUES(35,5,'2011-10-05 00:00:00.000000',NULL,9,23,2,NULL,-30.0,1,0.0,0.0,9,31,0,1);
INSERT INTO transact VALUES(36,1,'2011-11-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(37,2,'2011-11-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(38,1,'2011-12-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(39,2,'2011-12-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(40,5,'2011-12-10 00:00:00.000000',NULL,9,0,0,NULL,-147.24999999999999999,1,0.0,0.0,0,0,0,1);
INSERT INTO transact VALUES(41,5,'2011-12-10 00:00:00.000000',NULL,9,26,2,NULL,-83.489999999999994885,1,0.0,0.0,9,40,0,1);
INSERT INTO transact VALUES(42,5,'2011-12-10 00:00:00.000000',NULL,9,26,1,NULL,-20.0,1,0.0,0.0,9,40,0,1);
INSERT INTO transact VALUES(43,5,'2011-12-10 00:00:00.000000',NULL,9,27,1,NULL,-13.759999999999999786,1,0.0,0.0,9,40,0,1);
INSERT INTO transact VALUES(44,5,'2011-12-10 00:00:00.000000',NULL,9,23,2,NULL,-30.0,1,0.0,0.0,9,40,0,1);
INSERT INTO transact VALUES(45,5,'2011-12-10 00:00:00.000000',NULL,16,26,3,NULL,10.0,1,0.0,0.0,0,0,0,1);
INSERT INTO transact VALUES(46,1,'2012-01-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(47,2,'2012-01-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(48,1,'2012-02-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(49,2,'2012-02-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(50,4,'2012-02-25 00:00:00.000000',NULL,2,23,2,NULL,-10.0,1,0.0,0.0,0,0,0,1);
INSERT INTO transact VALUES(51,1,'2012-03-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(52,2,'2012-03-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(53,1,'2012-04-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(54,2,'2012-04-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(55,1,'2012-05-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(56,2,'2012-05-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(57,1,'2012-06-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(58,2,'2012-06-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(59,1,'2012-07-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(60,2,'2012-07-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(61,1,'2012-08-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(62,2,'2012-08-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(63,1,'2012-09-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(64,2,'2012-09-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(65,1,'2012-10-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(66,2,'2012-10-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(67,1,'2012-11-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(68,2,'2012-11-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(69,1,'2012-12-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(70,2,'2012-12-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(71,1,'2013-01-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(72,2,'2013-01-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(73,7,'2013-01-10 00:00:00.000000',NULL,2,23,2,NULL,-51.999999999999999998,1,0.0,0.0,18,0,0,1);
INSERT INTO transact VALUES(74,1,'2013-02-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(75,2,'2013-02-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
INSERT INTO transact VALUES(76,7,'2013-01-25 00:00:00.000000',NULL,26,32,0,NULL,51.999999999999999998,1,0.0,0.0,18,0,0,1);
INSERT INTO transact VALUES(77,1,'2013-03-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',-416.67000000000001592,1,0.0,0.0,4,0,0,1);
INSERT INTO transact VALUES(78,2,'2013-03-10 00:00:00.000000',NULL,21,0,0,'Echéance de remboursement emprunt pour la voiture',416.67000000000001592,1,0.0,0.0,6,0,0,1);
COMMIT;
