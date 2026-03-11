

-- IF OBJECT_ID('ListeCR', 'U') IS NULL
-- CREATE TABLE ListeCR (
--     CodeCR                 INT PRIMARY KEY,
--     CaisseRegionale        NVARCHAR(100),
--     CodeMnemonique         NVARCHAR(20),
--     CRPool                 BIT,
--     Cooperation            NVARCHAR(100),
--     Acronyme               NVARCHAR(100),
--     PU                     NVARCHAR(4)
-- );

-- IF OBJECT_ID('ListesDiffusions', 'U') IS NULL
-- CREATE TABLE ListesDiffusions (
--     IdListe                INT PRIMARY KEY IDENTITY(1,1),
--     NomListe               NVARCHAR(200) NOT NULL,
--     Commentaire            NVARCHAR(1000)
-- );

IF OBJECT_ID('Role', 'U') IS NULL
CREATE TABLE Role ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    Nom NVARCHAR(100) NOT NULL
);

IF OBJECT_ID('Utilisateurs', 'U') IS NULL
CREATE TABLE Utilisateurs ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    IdRole INT NOT NULL,
    Nom NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    FOREIGN KEY (IdRole) REFERENCES Role(Id)
);


IF OBJECT_ID('Fabricant_Type', 'U') IS NULL
CREATE TABLE Fabricant_Type ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    FabricantType NVARCHAR(800)
);

IF OBJECT_ID('Fabricant', 'U') IS NULL
CREATE TABLE Fabricant ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    IdFabricantType INT NOT NULL, 
    FabricantNom NVARCHAR(800), 
    FabricantNomContact NVARCHAR(800), 
    FabricantMail NVARCHAR(800), 
    FOREIGN KEY (IdFabricantType) REFERENCES Fabricant_Type(Id)
);


IF OBJECT_ID('Metier_Type', 'U') IS NULL
CREATE TABLE Metier_Type ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    MetierType NVARCHAR(800)
);

IF OBJECT_ID('Metier', 'U') IS NULL
CREATE TABLE Metier ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    IdFabricantType INT NOT NULL, 
    IdMetierType INT NOT NULL, 
    MetierNom NVARCHAR(800), 
    MetierNomContact NVARCHAR(800), 
    MetierMail NVARCHAR(800), 
    FOREIGN KEY (IdMetierType) REFERENCES Metier_Type(Id)
);

IF OBJECT_ID('Application', 'U') IS NULL
CREATE TABLE Application (
    Id              INT PRIMARY KEY IDENTITY(1,1),
    NumPIC              NVARCHAR(8) NOT NULL UNIQUE,
    NumMAPS              NVARCHAR(8) NOT NULL UNIQUE,
    LibelleAppli           NVARCHAR(255) NOT NULL,
    SyntheseDuBesoinFonctionnel NVARCHAR(2000) NULL,
    VersionProd             NVARCHAR(8) NULL ,
    StatutApplication      NVARCHAR(8)  NULL , --Mettre Enums dans le code.
    -- MetierPU           NVARCHAR(255) NOT NULL,
    -- MetierPP           NVARCHAR(255) NOT NULL,

    -- SousStatutApplication  INT,
    -- DomaineMetier          INT NOT NULL,
    -- IdSousDomaineMetier    INT,
    -- DateExpressionBesoin   DATE,
    -- ARM                    NVARCHAR(60),
    -- DateFinDeVie           DATE,
    -- RaisonFinDeVie         NVARCHAR(500),
    -- Population             NVARCHAR(60),
    -- EnjeuDemande           NVARCHAR(500),
    -- Theme                  INT,
    -- MotifChoixPeri         INT,
    -- NumMaps                NVARCHAR(8),
    -- StatutCommentaire      NVARCHAR(1000),
    DateCreation           DATETIME DEFAULT CURRENT_TIMESTAMP,
    DateModification       DATETIME DEFAULT CURRENT_TIMESTAMP,

    -- CONSTRAINT FK_App_Statut
    -- FOREIGN KEY (StatutApplication) REFERENCES StatutApplication(IdStatutApplication),
    -- CONSTRAINT FK_App_SousStatut
    --     FOREIGN KEY (SousStatutApplication) REFERENCES SousStatutApplication(IdSousStatut),
    -- CONSTRAINT FK_App_Domaine
    --     FOREIGN KEY (DomaineMetier) REFERENCES DomaineMetier(IdDomaineMetier),
    -- CONSTRAINT FK_App_SousDomaine
    --     FOREIGN KEY (IdSousDomaineMetier) REFERENCES SousDomaineMetier(IdSousDomaineMetier),
    -- CONSTRAINT FK_App_Theme
    --     FOREIGN KEY (Theme) REFERENCES Theme(IdTheme),
    -- CONSTRAINT FK_App_Motif
    --     FOREIGN KEY (MotifChoixPeri) REFERENCES MotifDeChoix(IdMotifDeChoix)
);

IF OBJECT_ID('Application_Metier', 'U') IS NULL
CREATE TABLE Application_Metier ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    IdApplication INT NOT NULL, 
    IdMetier INT NOT NULL, 
    FOREIGN KEY (IdApplication) REFERENCES Application(Id),
    FOREIGN KEY (IdMetier) REFERENCES Metier(Id)
);


IF OBJECT_ID('Version', 'U') IS NULL
CREATE TABLE Version (
    Id             INT PRIMARY KEY IDENTITY(1,1),
    IdAppli                INT NOT NULL,
    Numero                 NVARCHAR(20) NOT NULL,
    -- FabricantType          NVARCHAR(20) NOT NULL,
    -- FabricantNom           NVARCHAR(20) NOT NULL,
    -- IdFabricantType          INT NOT NULL,
    IdFabricant           INT NOT NULL,
    IdMetier           INT NOT NULL,
    StatutVersion          NVARCHAR(20) NOT NULL,
    -- FabricantNomContact    NVARCHAR(255) NOT NULL,
    ReleaseNote            NVARCHAR(2000),
    -- MetierPUNomContact    NVARCHAR(255) NOT NULL,
    -- MetierPPNomContact    NVARCHAR(255) NOT NULL,
    ExpertSSINomContact    NVARCHAR(255),
    ExpertJCNomContact     NVARCHAR(255),
    ExpertRGPDNomContact    NVARCHAR(255),
    ExpertDataNomContact    NVARCHAR(255),
    EtapeVersion          NVARCHAR(20) NOT NULL, --Etape ou phase de la version
    DateMiseADispo       DATE,
    TrajectoireFabrication          NVARCHAR(255) NOT NULL, -- Trajectoire de fabrication & informations techniques (Lien vers wiki KOSMOS)



    -- DateDebutRealisation   DATE,
    -- DateFinRealisation     DATE,
    -- ChargeEstimeeRealisation FLOAT,
    -- DateLivraisonMOEPeri   DATE,
    -- DateDebutHomologation  DATE,
    -- DateFinHomologation    DATE,
    -- PhaseVersion           INT,
    -- StatutVersion          INT,
    -- Commentaire            NVARCHAR(1000),
    DateCreation           DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT FK_Version_App
        FOREIGN KEY (IdAppli) REFERENCES Application(Id),
        -- FOREIGN KEY (IdFabricantType) REFERENCES Fabricant_Type(Id),
        FOREIGN KEY (IdFabricant) REFERENCES Fabricant(Id)

    -- CONSTRAINT FK_Version_Phase
    --     FOREIGN KEY (PhaseVersion) REFERENCES PhaseVersion(IdPhaseVersion),
    -- CONSTRAINT FK_Version_Statut
    --     FOREIGN KEY (StatutVersion) REFERENCES StatutVersion(IdStatutVersion)
);

IF OBJECT_ID('Version_Metier', 'U') IS NULL
CREATE TABLE Version_Metier ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    IdMetier INT NOT NULL, 
    IdVersion INT NOT NULL, 
    FOREIGN KEY (IdVersion) REFERENCES Version(Id),
    FOREIGN KEY (IdMetier) REFERENCES Metier(Id)
);


IF OBJECT_ID('Version_Fabricant', 'U') IS NULL
CREATE TABLE Version_Fabricant ( 
    Id INT PRIMARY KEY IDENTITY(1,1), 
    IdFabricant INT NOT NULL, 
    IdVersion INT NOT NULL, 
    FOREIGN KEY (IdVersion) REFERENCES Version(Id),
    FOREIGN KEY (IdFabricant) REFERENCES Fabricant(Id)
);


-- IF OBJECT_ID('Version', 'U') IS NULL
-- CREATE TABLE Version (
--     Id             INT PRIMARY KEY IDENTITY(1,1),
--     IdAppli                INT NOT NULL,
--     Numero                 NVARCHAR(20) NOT NULL,
--     FabricantType          NVARCHAR(20) NOT NULL,
--     FabricantNom           NVARCHAR(20) NOT NULL,
--     StatutVersion          NVARCHAR(20) NOT NULL,
--     FabricantNomContact    NVARCHAR(255) NOT NULL,
--     ReleaseNote            NVARCHAR(2000),
--     MetierPUNomContact    NVARCHAR(255) NOT NULL,
--     MetierPPNomContact    NVARCHAR(255) NOT NULL,
--     ExpertSSINomContact    NVARCHAR(255),
--     ExpertJCNomContact     NVARCHAR(255),
--     ExpertRGPDNomContact    NVARCHAR(255),
--     ExpertDataNomContact    NVARCHAR(255),
--     EtapeVersion          NVARCHAR(20) NOT NULL, --Etape ou phase de la version
--     DateMiseADispo       DATE,
--     TrajectoireFaabrication          NVARCHAR(255) NOT NULL, -- Trajectoire de fabrication & informations techniques (Lien vers wiki KOSMOS)



--     -- DateDebutRealisation   DATE,
--     -- DateFinRealisation     DATE,
--     -- ChargeEstimeeRealisation FLOAT,
--     -- DateLivraisonMOEPeri   DATE,
--     -- DateDebutHomologation  DATE,
--     -- DateFinHomologation    DATE,
--     -- PhaseVersion           INT,
--     -- StatutVersion          INT,
--     -- Commentaire            NVARCHAR(1000),
--     DateCreation           DATETIME DEFAULT CURRENT_TIMESTAMP,

--     CONSTRAINT FK_Version_App
--         FOREIGN KEY (IdAppli) REFERENCES Application(Id),
--     -- CONSTRAINT FK_Version_Phase
--     --     FOREIGN KEY (PhaseVersion) REFERENCES PhaseVersion(IdPhaseVersion),
--     -- CONSTRAINT FK_Version_Statut
--     --     FOREIGN KEY (StatutVersion) REFERENCES StatutVersion(IdStatutVersion)
-- );



CREATE TABLE LangageProgrammation ( 
    IdLangage INT PRIMARY KEY, 
    NomLangage NVARCHAR(100) NOT NULL 
);

CREATE TABLE VersionApplication_LangageProgrammation ( 
    IdVersion INT NOT NULL, 
    IdLangage INT NOT NULL, 
    PRIMARY KEY (IdVersion, IdLangage), 
    FOREIGN KEY (IdVersion) REFERENCES Version(Id), 
    FOREIGN KEY (IdLangage) REFERENCES LangageProgrammation(IdLangage) 
);



-- IF OBJECT_ID('Application_Technologie', 'U') IS NULL
-- CREATE TABLE Application_Technologie (
--     IdAppli        INT NOT NULL,
--     IdTechnologie  INT NOT NULL,
--     PRIMARY KEY (IdAppli, IdTechnologie),
--     CONSTRAINT FK_AppTech_App
--         FOREIGN KEY (IdAppli) REFERENCES Application(IdAppli),
--     CONSTRAINT FK_AppTech_Tech
--         FOREIGN KEY (IdTechnologie) REFERENCES Technologie(IdTechnologie)
-- );




IF OBJECT_ID('HistoriqueTrace', 'U') IS NULL
CREATE TABLE HistoriqueTrace (
    IdTrace        INT PRIMARY KEY IDENTITY(1,1),
    IdAppli        INT NOT NULL,
    IdVersion      INT NULL,
    LibelleAppli   NVARCHAR(800),
    CaisseRegionale CHAR(2),
    Environnement  NVARCHAR(16),
    DerniereConnexion DATETIME,
    Commentaire    NVARCHAR(1000),
    CONSTRAINT FK_Trace_App
        FOREIGN KEY (IdAppli) REFERENCES Application(Id), 
    CONSTRAINT FK_Trace_Ver
        FOREIGN KEY (IdVersion) REFERENCES Version(Id)
);

-- 1. Supprimer la contrainte unique sur NumMAPS (remplace le nom si besoin)
ALTER TABLE Application DROP CONSTRAINT IF EXISTS UQ__Applicat__4A7C0676216F868E;


ALTER TABLE Application
DROP CONSTRAINT IF EXISTS UQ__Application__NumMAPS; -- supprime la contrainte unique sur NumMAPS si elle existe

ALTER TABLE Application
DROP COLUMN NumMAPS;

ALTER TABLE Application
ADD NumMAPS NVARCHAR(8) NULL;

-- Rendre tous les champs sauf Id et NumPIC NULLABLE
ALTER TABLE Application
ALTER COLUMN NumPIC NVARCHAR(8) NOT NULL;

ALTER TABLE Application
ALTER COLUMN LibelleAppli NVARCHAR(255) NULL;
ALTER TABLE Application
ALTER COLUMN SyntheseDuBesoinFonctionnel NVARCHAR(2000) NULL;
ALTER TABLE Application
ALTER COLUMN VersionProd NVARCHAR(8) NULL;
ALTER TABLE Application
ALTER COLUMN StatutApplication NVARCHAR(8) NULL;
ALTER TABLE Application
ALTER COLUMN MetierPU NVARCHAR(255) NULL;
ALTER TABLE Application
ALTER COLUMN MetierPP NVARCHAR(255) NULL;
ALTER TABLE Application
ALTER COLUMN DateCreation DATETIME NULL;
ALTER TABLE Application
ALTER COLUMN DateModification DATETIME NULL;

-- Ajoute la contrainte unique sur NumPIC uniquement
-- ALTER TABLE Application
-- ADD CONSTRAINT UQ_Application_NumPIC UNIQUE (NumPIC);


-- Rendre tous les champs sauf Id NULLABLE
-- ALTER TABLE Version ALTER COLUMN IdAppli INT NULL;
-- ALTER TABLE Version ALTER COLUMN Numero NVARCHAR(20) NULL;
-- ALTER TABLE Version ALTER COLUMN IdFabricantType INT NULL;
-- ALTER TABLE Version ALTER COLUMN IdFabricantNom INT NULL;
-- ALTER TABLE Version ALTER COLUMN StatutVersion NVARCHAR(20) NULL;
-- ALTER TABLE Version ALTER COLUMN FabricantNomContact NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN ReleaseNote NVARCHAR(2000) NULL;
-- ALTER TABLE Version ALTER COLUMN MetierPUNomContact NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN MetierPPNomContact NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN ExpertSSINomContact NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN ExpertJCNomContact NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN ExpertRGPDNomContact NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN ExpertDataNomContact NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN EtapeVersion NVARCHAR(20) NULL;
-- ALTER TABLE Version ALTER COLUMN DateMiseADispo DATE NULL;
-- ALTER TABLE Version ALTER COLUMN TrajectoireFaabrication NVARCHAR(255) NULL;
-- ALTER TABLE Version ALTER COLUMN DateCreation DATETIME NULL;
