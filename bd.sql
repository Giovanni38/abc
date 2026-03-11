SET NOCOUNT ON;
GO

/* =========================================
   DROP TABLES
========================================= */

IF OBJECT_ID('dbo.historique_application', 'U') IS NOT NULL DROP TABLE dbo.historique_application;
IF OBJECT_ID('dbo.version_langage', 'U') IS NOT NULL DROP TABLE dbo.version_langage;
IF OBJECT_ID('dbo.application_dependance', 'U') IS NOT NULL DROP TABLE dbo.application_dependance;
IF OBJECT_ID('dbo.version_contact', 'U') IS NOT NULL DROP TABLE dbo.version_contact;
IF OBJECT_ID('dbo.application_contact', 'U') IS NOT NULL DROP TABLE dbo.application_contact;
IF OBJECT_ID('dbo.fabricant_contact', 'U') IS NOT NULL DROP TABLE dbo.fabricant_contact;
IF OBJECT_ID('dbo.version_application', 'U') IS NOT NULL DROP TABLE dbo.version_application;
IF OBJECT_ID('dbo.application', 'U') IS NOT NULL DROP TABLE dbo.application;

IF OBJECT_ID('dbo.langage_programmation', 'U') IS NOT NULL DROP TABLE dbo.langage_programmation;
IF OBJECT_ID('dbo.type_dependance', 'U') IS NOT NULL DROP TABLE dbo.type_dependance;
IF OBJECT_ID('dbo.etape_version', 'U') IS NOT NULL DROP TABLE dbo.etape_version;
IF OBJECT_ID('dbo.statut', 'U') IS NOT NULL DROP TABLE dbo.statut;
IF OBJECT_ID('dbo.role_contact', 'U') IS NOT NULL DROP TABLE dbo.role_contact;
IF OBJECT_ID('dbo.contact', 'U') IS NOT NULL DROP TABLE dbo.contact;
IF OBJECT_ID('dbo.fabricant', 'U') IS NOT NULL DROP TABLE dbo.fabricant;
IF OBJECT_ID('dbo.fabricant_type', 'U') IS NOT NULL DROP TABLE dbo.fabricant_type;
IF OBJECT_ID('dbo.metier', 'U') IS NOT NULL DROP TABLE dbo.metier;
IF OBJECT_ID('dbo.type_metier', 'U') IS NOT NULL DROP TABLE dbo.type_metier;
IF OBJECT_ID('dbo.produit', 'U') IS NOT NULL DROP TABLE dbo.produit;
IF OBJECT_ID('dbo.groupe_support', 'U') IS NOT NULL DROP TABLE dbo.groupe_support;
IF OBJECT_ID('dbo.utilisateur_app', 'U') IS NOT NULL DROP TABLE dbo.utilisateur_app;
GO

/* =========================================
   REFERENTIELS
========================================= */

CREATE TABLE dbo.utilisateur_app (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    login_utilisateur NVARCHAR(150) NOT NULL,
    nom NVARCHAR(150) NULL,
    prenom NVARCHAR(150) NULL,
    email NVARCHAR(255) NULL,
    actif BIT NOT NULL CONSTRAINT DF_utilisateur_app_actif DEFAULT (1),
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_utilisateur_app_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_utilisateur_app_date_modification DEFAULT (SYSDATETIME())
);
GO

CREATE UNIQUE INDEX UX_utilisateur_app_login ON dbo.utilisateur_app(login_utilisateur);
GO

CREATE TABLE dbo.type_metier (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    libelle NVARCHAR(150) NOT NULL,
    actif BIT NOT NULL CONSTRAINT DF_type_metier_actif DEFAULT (1)
);
GO

CREATE UNIQUE INDEX UX_type_metier_code ON dbo.type_metier(code);
GO

CREATE TABLE dbo.metier (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    nom NVARCHAR(150) NOT NULL,
    type_metier_id BIGINT NULL,
    domaine NVARCHAR(150) NULL,
    actif BIT NOT NULL CONSTRAINT DF_metier_actif DEFAULT (1),
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_metier_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_metier_date_modification DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_metier_type_metier
        FOREIGN KEY (type_metier_id) REFERENCES dbo.type_metier(id)
);
GO

CREATE UNIQUE INDEX UX_metier_code ON dbo.metier(code);
GO

CREATE TABLE dbo.fabricant_type (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    libelle NVARCHAR(150) NOT NULL,
    actif BIT NOT NULL CONSTRAINT DF_fabricant_type_actif DEFAULT (1)
);
GO

CREATE UNIQUE INDEX UX_fabricant_type_code ON dbo.fabricant_type(code);
GO

CREATE TABLE dbo.fabricant (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    fabricant_type_id BIGINT NULL,
    code NVARCHAR(50) NULL,
    nom NVARCHAR(200) NOT NULL,
    actif BIT NOT NULL CONSTRAINT DF_fabricant_actif DEFAULT (1),
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_fabricant_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_fabricant_date_modification DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_fabricant_fabricant_type
        FOREIGN KEY (fabricant_type_id) REFERENCES dbo.fabricant_type(id)
);
GO

CREATE UNIQUE INDEX UX_fabricant_nom ON dbo.fabricant(nom);
GO

CREATE TABLE dbo.contact (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    matricule NVARCHAR(50) NULL,
    nom NVARCHAR(150) NOT NULL,
    prenom NVARCHAR(150) NULL,
    email NVARCHAR(255) NULL,
    telephone NVARCHAR(50) NULL,
    actif BIT NOT NULL CONSTRAINT DF_contact_actif DEFAULT (1),
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_contact_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_contact_date_modification DEFAULT (SYSDATETIME())
);
GO

CREATE INDEX IX_contact_nom_prenom ON dbo.contact(nom, prenom);
CREATE INDEX IX_contact_email ON dbo.contact(email);
GO

CREATE TABLE dbo.role_contact (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    libelle NVARCHAR(150) NOT NULL,
    actif BIT NOT NULL CONSTRAINT DF_role_contact_actif DEFAULT (1)
);
GO

CREATE UNIQUE INDEX UX_role_contact_code ON dbo.role_contact(code);
GO

CREATE TABLE dbo.statut (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    libelle NVARCHAR(150) NOT NULL,
    ordre_affichage INT NOT NULL CONSTRAINT DF_statut_ordre DEFAULT (0),
    actif BIT NOT NULL CONSTRAINT DF_statut_actif DEFAULT (1)
);
GO

CREATE UNIQUE INDEX UX_statut_code ON dbo.statut(code);
GO

CREATE TABLE dbo.etape_version (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    libelle NVARCHAR(150) NOT NULL,
    ordre_affichage INT NOT NULL CONSTRAINT DF_etape_version_ordre DEFAULT (0),
    actif BIT NOT NULL CONSTRAINT DF_etape_version_actif DEFAULT (1)
);
GO

CREATE UNIQUE INDEX UX_etape_version_code ON dbo.etape_version(code);
GO

CREATE TABLE dbo.type_dependance (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    libelle NVARCHAR(150) NOT NULL,
    actif BIT NOT NULL CONSTRAINT DF_type_dependance_actif DEFAULT (1)
);
GO

CREATE UNIQUE INDEX UX_type_dependance_code ON dbo.type_dependance(code);
GO

CREATE TABLE dbo.langage_programmation (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NOT NULL,
    nom NVARCHAR(150) NOT NULL,
    actif BIT NOT NULL CONSTRAINT DF_langage_programmation_actif DEFAULT (1)
);
GO

CREATE UNIQUE INDEX UX_langage_programmation_code ON dbo.langage_programmation(code);
GO

CREATE TABLE dbo.produit (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code_produit NVARCHAR(50) NULL,
    libelle NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX) NULL,
    perimetre NVARCHAR(150) NULL,
    actif BIT NOT NULL CONSTRAINT DF_produit_actif DEFAULT (1),
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_produit_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_produit_date_modification DEFAULT (SYSDATETIME())
);
GO

CREATE UNIQUE INDEX UX_produit_libelle ON dbo.produit(libelle);
GO

CREATE TABLE dbo.groupe_support (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code NVARCHAR(50) NULL,
    libelle NVARCHAR(200) NOT NULL,
    actif BIT NOT NULL CONSTRAINT DF_groupe_support_actif DEFAULT (1),
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_groupe_support_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_groupe_support_date_modification DEFAULT (SYSDATETIME())
);
GO

CREATE UNIQUE INDEX UX_groupe_support_libelle ON dbo.groupe_support(libelle);
GO

/* =========================================
   COEUR METIER
========================================= */

CREATE TABLE dbo.application (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    code_pic NVARCHAR(50) NOT NULL,
    code_maps NVARCHAR(50) NULL,
    code_solution NVARCHAR(50) NULL,
    libelle NVARCHAR(255) NOT NULL,
    description_fonctionnelle NVARCHAR(MAX) NULL,
    statut_id BIGINT NOT NULL,
    version_production_id BIGINT NULL,
    date_premiere_mep DATE NULL,
    date_derniere_mep DATE NULL,
    date_decommissionnement DATE NULL,
    api_reference_id NVARCHAR(100) NULL,
    produit_id BIGINT NULL,
    pu_metier_id BIGINT NULL,
    pp_metier_id BIGINT NULL,
    groupe_support_id BIGINT NULL,
    est_active BIT NOT NULL CONSTRAINT DF_application_est_active DEFAULT (1),
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_application_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_application_date_modification DEFAULT (SYSDATETIME()),
    cree_par BIGINT NULL,
    modifie_par BIGINT NULL,
    CONSTRAINT FK_application_statut
        FOREIGN KEY (statut_id) REFERENCES dbo.statut(id),
    CONSTRAINT FK_application_produit
        FOREIGN KEY (produit_id) REFERENCES dbo.produit(id),
    CONSTRAINT FK_application_pu_metier
        FOREIGN KEY (pu_metier_id) REFERENCES dbo.metier(id),
    CONSTRAINT FK_application_pp_metier
        FOREIGN KEY (pp_metier_id) REFERENCES dbo.metier(id),
    CONSTRAINT FK_application_groupe_support
        FOREIGN KEY (groupe_support_id) REFERENCES dbo.groupe_support(id),
    CONSTRAINT FK_application_cree_par
        FOREIGN KEY (cree_par) REFERENCES dbo.utilisateur_app(id),
    CONSTRAINT FK_application_modifie_par
        FOREIGN KEY (modifie_par) REFERENCES dbo.utilisateur_app(id)
);
GO

CREATE UNIQUE INDEX UX_application_code_pic ON dbo.application(code_pic);
CREATE INDEX IX_application_libelle ON dbo.application(libelle);
CREATE INDEX IX_application_statut ON dbo.application(statut_id);
GO

CREATE TABLE dbo.version_application (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    application_id BIGINT NOT NULL,
    numero_version NVARCHAR(100) NOT NULL,
    release_note NVARCHAR(MAX) NULL,
    statut_id BIGINT NOT NULL,
    etape_version_id BIGINT NULL,
    date_mise_a_disposition DATE NULL,
    date_livraison DATE NULL,
    date_mise_en_production DATE NULL,
    date_decommissionnement DATE NULL,
    trajectoire_fabrication NVARCHAR(MAX) NULL,
    fabricant_id BIGINT NULL,
    commentaire_technique NVARCHAR(MAX) NULL,
    api_reference_id NVARCHAR(100) NULL,
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_version_application_date_creation DEFAULT (SYSDATETIME()),
    date_modification DATETIME2(0) NOT NULL CONSTRAINT DF_version_application_date_modification DEFAULT (SYSDATETIME()),
    cree_par BIGINT NULL,
    modifie_par BIGINT NULL,
    CONSTRAINT FK_version_application_application
        FOREIGN KEY (application_id) REFERENCES dbo.application(id),
    CONSTRAINT FK_version_application_statut
        FOREIGN KEY (statut_id) REFERENCES dbo.statut(id),
    CONSTRAINT FK_version_application_etape_version
        FOREIGN KEY (etape_version_id) REFERENCES dbo.etape_version(id),
    CONSTRAINT FK_version_application_fabricant
        FOREIGN KEY (fabricant_id) REFERENCES dbo.fabricant(id),
    CONSTRAINT FK_version_application_cree_par
        FOREIGN KEY (cree_par) REFERENCES dbo.utilisateur_app(id),
    CONSTRAINT FK_version_application_modifie_par
        FOREIGN KEY (modifie_par) REFERENCES dbo.utilisateur_app(id)
);
GO

CREATE UNIQUE INDEX UX_version_application_app_version
ON dbo.version_application(application_id, numero_version);

CREATE INDEX IX_version_application_statut
ON dbo.version_application(statut_id);
GO

ALTER TABLE dbo.application
ADD CONSTRAINT FK_application_version_production
FOREIGN KEY (version_production_id) REFERENCES dbo.version_application(id);
GO

/* =========================================
   LIAISONS CONTACTS
========================================= */

CREATE TABLE dbo.fabricant_contact (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    fabricant_id BIGINT NOT NULL,
    contact_id BIGINT NOT NULL,
    role_contact_id BIGINT NOT NULL,
    est_principal BIT NOT NULL CONSTRAINT DF_fabricant_contact_est_principal DEFAULT (0),
    date_debut DATE NULL,
    date_fin DATE NULL,
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_fabricant_contact_date_creation DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_fabricant_contact_fabricant
        FOREIGN KEY (fabricant_id) REFERENCES dbo.fabricant(id),
    CONSTRAINT FK_fabricant_contact_contact
        FOREIGN KEY (contact_id) REFERENCES dbo.contact(id),
    CONSTRAINT FK_fabricant_contact_role_contact
        FOREIGN KEY (role_contact_id) REFERENCES dbo.role_contact(id)
);
GO

CREATE UNIQUE INDEX UX_fabricant_contact_unique
ON dbo.fabricant_contact(fabricant_id, contact_id, role_contact_id);
GO

CREATE TABLE dbo.application_contact (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    application_id BIGINT NOT NULL,
    contact_id BIGINT NOT NULL,
    role_contact_id BIGINT NOT NULL,
    est_principal BIT NOT NULL CONSTRAINT DF_application_contact_est_principal DEFAULT (0),
    date_debut DATE NULL,
    date_fin DATE NULL,
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_application_contact_date_creation DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_application_contact_application
        FOREIGN KEY (application_id) REFERENCES dbo.application(id),
    CONSTRAINT FK_application_contact_contact
        FOREIGN KEY (contact_id) REFERENCES dbo.contact(id),
    CONSTRAINT FK_application_contact_role_contact
        FOREIGN KEY (role_contact_id) REFERENCES dbo.role_contact(id)
);
GO

CREATE UNIQUE INDEX UX_application_contact_unique
ON dbo.application_contact(application_id, contact_id, role_contact_id);
GO

CREATE TABLE dbo.version_contact (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    version_id BIGINT NOT NULL,
    contact_id BIGINT NOT NULL,
    role_contact_id BIGINT NOT NULL,
    est_principal BIT NOT NULL CONSTRAINT DF_version_contact_est_principal DEFAULT (0),
    date_debut DATE NULL,
    date_fin DATE NULL,
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_version_contact_date_creation DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_version_contact_version
        FOREIGN KEY (version_id) REFERENCES dbo.version_application(id),
        CONSTRAINT FK_version_contact_contact
        FOREIGN KEY (contact_id) REFERENCES dbo.contact(id),
    CONSTRAINT FK_version_contact_role_contact
        FOREIGN KEY (role_contact_id) REFERENCES dbo.role_contact(id)
);
GO

CREATE UNIQUE INDEX UX_version_contact_unique
ON dbo.version_contact(version_id, contact_id, role_contact_id);
GO

/* =========================================
   LIAISONS FONCTIONNELLES
========================================= */

CREATE TABLE dbo.application_dependance (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    application_source_id BIGINT NOT NULL,
    application_cible_id BIGINT NOT NULL,
    type_dependance_id BIGINT NOT NULL,
    commentaire NVARCHAR(1000) NULL,
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_application_dependance_date_creation DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_application_dependance_source
        FOREIGN KEY (application_source_id) REFERENCES dbo.application(id),
    CONSTRAINT FK_application_dependance_cible
        FOREIGN KEY (application_cible_id) REFERENCES dbo.application(id),
    CONSTRAINT FK_application_dependance_type
        FOREIGN KEY (type_dependance_id) REFERENCES dbo.type_dependance(id),
    CONSTRAINT CK_application_dependance_source_cible
        CHECK (application_source_id <> application_cible_id)
);
GO

CREATE UNIQUE INDEX UX_application_dependance_unique
ON dbo.application_dependance(application_source_id, application_cible_id, type_dependance_id);
GO

CREATE TABLE dbo.version_langage (
    version_id BIGINT NOT NULL,
    langage_id BIGINT NOT NULL,
    date_creation DATETIME2(0) NOT NULL CONSTRAINT DF_version_langage_date_creation DEFAULT (SYSDATETIME()),
    CONSTRAINT PK_version_langage PRIMARY KEY (version_id, langage_id),
    CONSTRAINT FK_version_langage_version
        FOREIGN KEY (version_id) REFERENCES dbo.version_application(id),
    CONSTRAINT FK_version_langage_langage
        FOREIGN KEY (langage_id) REFERENCES dbo.langage_programmation(id)
);
GO

/* =========================================
   HISTORIQUE
========================================= */

CREATE TABLE dbo.historique_application (
    id BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    application_id BIGINT NOT NULL,
    type_evenement NVARCHAR(100) NOT NULL,
    ancienne_valeur NVARCHAR(MAX) NULL,
    nouvelle_valeur NVARCHAR(MAX) NULL,
    commentaire NVARCHAR(MAX) NULL,
    utilisateur_id BIGINT NULL,
    date_evenement DATETIME2(0) NOT NULL CONSTRAINT DF_historique_application_date_evenement DEFAULT (SYSDATETIME()),
    CONSTRAINT FK_historique_application_application
        FOREIGN KEY (application_id) REFERENCES dbo.application(id),
    CONSTRAINT FK_historique_application_utilisateur
        FOREIGN KEY (utilisateur_id) REFERENCES dbo.utilisateur_app(id)
);
GO

CREATE INDEX IX_historique_application_app_date
ON dbo.historique_application(application_id, date_evenement DESC);
GO

/* =========================================
   DONNEES DE REFERENCE MINIMALES
========================================= */

INSERT INTO dbo.role_contact (code, libelle) VALUES
('FABRICANT', 'Contact fabricant'),
('PU_METIER', 'PU métier'),
('PP_METIER', 'PP métier'),
('EXPERT_SSI', 'Expert SSI'),
('EXPERT_JEC', 'Expert J&C'),
('EXPERT_RGPD', 'Expert RGPD'),
('EXPERT_DATA', 'Expert DATA'),
('SUPPORT', 'Support'),
('REFERENT', 'Référent');
GO

INSERT INTO dbo.statut (code, libelle, ordre_affichage) VALUES
('EN_DEV', 'En Développement', 1),
('EN_PROD', 'En production', 2),
('DECOM', 'Décommissionné', 3);
GO

INSERT INTO dbo.etape_version (code, libelle, ordre_affichage) VALUES
('ETUDE', 'Étude', 1),
('DEV', 'Développement', 2),
('TEST', 'Test', 3),
('RECETTE', 'Recette', 4),
('MEP', 'Mise en production', 5),
('DECOM', 'Décommissionnement', 6);
GO

INSERT INTO dbo.type_dependance (code, libelle) VALUES
('DEPEND_DE', 'Dépend de'),
('CONSOMME', 'Consomme'),
('EXPOSE_A', 'Expose à'),
('INTERFACEE_AVEC', 'Interfacée avec');
GO

INSERT INTO dbo.fabricant_type (code, libelle) VALUES
('INTERNE', 'Interne'),
('EDITEUR', 'Éditeur'),
('PRESTATAIRE', 'Prestataire'),
('OPEN_SOURCE', 'Open source');
GO

INSERT INTO dbo.langage_programmation (code, nom) VALUES
('JAVA', 'Java'),
('CSHARP', 'C#'),
('PYTHON', 'Python'),
('JS', 'JavaScript'),
('TS', 'TypeScript'),
('SQL', 'SQL'),
('PHP', 'PHP'),
('COBOL', 'Cobol');
GO
