-- =============================================
-- Drop existing tables (in reverse FK order)
-- =============================================
IF OBJECT_ID('dbo.Fato_Vendas',        'U') IS NOT NULL DROP TABLE dbo.Fato_Vendas;
IF OBJECT_ID('dbo.Dim_Concessionaria','U') IS NOT NULL DROP TABLE dbo.Dim_Concessionaria;
IF OBJECT_ID('dbo.Dim_Modelo',        'U') IS NOT NULL DROP TABLE dbo.Dim_Modelo;
IF OBJECT_ID('dbo.Dim_Montadora',     'U') IS NOT NULL DROP TABLE dbo.Dim_Montadora;
IF OBJECT_ID('dbo.Dim_Data',          'U') IS NOT NULL DROP TABLE dbo.Dim_Data;
IF OBJECT_ID('dbo.Dim_Cidade',        'U') IS NOT NULL DROP TABLE dbo.Dim_Cidade;
IF OBJECT_ID('dbo.Dim_Estado',        'U') IS NOT NULL DROP TABLE dbo.Dim_Estado;
IF OBJECT_ID('dbo.Dim_Regiao',        'U') IS NOT NULL DROP TABLE dbo.Dim_Regiao;
GO

-- =============================================
-- Date Dimension
-- =============================================
CREATE TABLE dbo.Dim_Data
(
    ID_Data       INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Data PRIMARY KEY,
    Dia           TINYINT        NOT NULL,      -- 1..31
    Mes           TINYINT        NOT NULL,      -- 1..12
    Ano           SMALLINT       NOT NULL,      -- e.g. 2025
    Dia_Semana    VARCHAR(10)    NOT NULL,      -- e.g. 'Monday'
    Bimestre      TINYINT        NOT NULL,      -- 1..6
    Trimestre     TINYINT        NOT NULL       -- 1..4
);
GO

-- =============================================
-- Manufacturer (Montadora) Dimension
-- =============================================
CREATE TABLE dbo.Dim_Montadora
(
    ID_Montadora  INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Montadora PRIMARY KEY,
    Nome_Montadora VARCHAR(100)   NOT NULL
);
GO

-- =============================================
-- Model (Modelo) Dimension
-- =============================================
CREATE TABLE dbo.Dim_Modelo
(
    ID_Modelo     INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Modelo PRIMARY KEY,
    ID_Montadora  INT             NOT NULL
        CONSTRAINT FK_Dim_Modelo_Montadora 
            FOREIGN KEY REFERENCES dbo.Dim_Montadora(ID_Montadora),
    Nome_Modelo   VARCHAR(100)    NOT NULL
);
GO

-- =============================================
-- City, State & Region Dimensions
-- =============================================
CREATE TABLE dbo.Dim_Cidade
(
    ID_Cidade     INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Cidade PRIMARY KEY,
    Nome_Cidade   VARCHAR(100)    NOT NULL
);
GO

CREATE TABLE dbo.Dim_Estado
(
    ID_Estado     INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Estado PRIMARY KEY,
    Nome_Estado   VARCHAR(100)    NOT NULL
);
GO

CREATE TABLE dbo.Dim_Regiao
(
    ID_Regiao     INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Regiao PRIMARY KEY,
    Nome_Regiao   VARCHAR(100)    NOT NULL
);
GO

-- =============================================
-- Dealership (Concessionária) Dimension
-- =============================================
CREATE TABLE dbo.Dim_Concessionaria
(
    ID_Concessionaria  INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Concessionaria PRIMARY KEY,
    Nome_Concessionaria VARCHAR(150)   NOT NULL,
    ID_Cidade          INT             NOT NULL
        CONSTRAINT FK_Concessionaria_Cidade 
            FOREIGN KEY REFERENCES dbo.Dim_Cidade(ID_Cidade),
    ID_Estado          INT             NOT NULL
        CONSTRAINT FK_Concessionaria_Estado
            FOREIGN KEY REFERENCES dbo.Dim_Estado(ID_Estado),
    ID_Regiao          INT             NOT NULL
        CONSTRAINT FK_Concessionaria_Regiao
            FOREIGN KEY REFERENCES dbo.Dim_Regiao(ID_Regiao)
);
GO

-- =============================================
-- Fact Table: Sales
-- =============================================
CREATE TABLE dbo.Fato_Vendas
(
    ID_Venda            BIGINT          IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Fato_Vendas PRIMARY KEY,
    ID_Modelo           INT             NOT NULL
        CONSTRAINT FK_FatoVendas_Modelo
            FOREIGN KEY REFERENCES dbo.Dim_Modelo(ID_Modelo),
    ID_Data             INT             NOT NULL
        CONSTRAINT FK_FatoVendas_Data
            FOREIGN KEY REFERENCES dbo.Dim_Data(ID_Data),
    ID_Concessionaria   INT             NOT NULL
        CONSTRAINT FK_FatoVendas_Concessionaria
            FOREIGN KEY REFERENCES dbo.Dim_Concessionaria(ID_Concessionaria),
    Quantidade_Vendida  INT             NOT NULL,
    Valor_Total         DECIMAL(18,2)   NOT NULL
);
GO

-- Optional: add indexes on high‑cardinality FKs for performance
CREATE INDEX IX_FatoVendas_Data       ON dbo.Fato_Vendas(ID_Data);
CREATE INDEX IX_FatoVendas_Modelo     ON dbo.Fato_Vendas(ID_Modelo);
CREATE INDEX IX_FatoVendas_Concessionaria
                                    ON dbo.Fato_Vendas(ID_Concessionaria);
GO
