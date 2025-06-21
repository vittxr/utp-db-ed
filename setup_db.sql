-- CRIAR TABELAS:
IF OBJECT_ID('dbo.Fato_Vendas',        'U') IS NOT NULL DROP TABLE dbo.Fato_Vendas;
IF OBJECT_ID('dbo.Dim_Concessionaria','U') IS NOT NULL DROP TABLE dbo.Dim_Concessionaria;
IF OBJECT_ID('dbo.Dim_Modelo',        'U') IS NOT NULL DROP TABLE dbo.Dim_Modelo;
IF OBJECT_ID('dbo.Dim_Montadora',     'U') IS NOT NULL DROP TABLE dbo.Dim_Montadora;
IF OBJECT_ID('dbo.Dim_Data',          'U') IS NOT NULL DROP TABLE dbo.Dim_Data;
IF OBJECT_ID('dbo.Dim_Cidade',        'U') IS NOT NULL DROP TABLE dbo.Dim_Cidade;
IF OBJECT_ID('dbo.Dim_Estado',        'U') IS NOT NULL DROP TABLE dbo.Dim_Estado;
IF OBJECT_ID('dbo.Dim_Regiao',        'U') IS NOT NULL DROP TABLE dbo.Dim_Regiao;
GO

CREATE TABLE dbo.Dim_Data
(
    ID_Data       INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Data PRIMARY KEY,
    Dia           TINYINT        NOT NULL,   
    Mes           TINYINT        NOT NULL,     
    Ano           SMALLINT       NOT NULL,  
    Dia_Semana    VARCHAR(10)    NOT NULL,     
    Bimestre      TINYINT        NOT NULL,      
    Trimestre     TINYINT        NOT NULL  
);
GO

CREATE TABLE dbo.Dim_Montadora
(
    ID_Montadora  INT             IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Dim_Montadora PRIMARY KEY,
    Nome_Montadora VARCHAR(100)   NOT NULL
);
GO

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

-- POPULAR TABELAS:
SET IDENTITY_INSERT dbo.Dim_Regiao ON;
INSERT INTO dbo.Dim_Regiao (ID_Regiao, Nome_Regiao) VALUES
  (1, 'Sul'),
  (2, 'Sudeste'),
  (3, 'Centro-Oeste'),
  (4, 'Nordeste'),
  (5, 'Norte');
SET IDENTITY_INSERT dbo.Dim_Regiao OFF;

SET IDENTITY_INSERT dbo.Dim_Estado ON;
INSERT INTO dbo.Dim_Estado (ID_Estado, Nome_Estado) VALUES
  (1, 'Paraná'),
  (2, 'São Paulo'),
  (3, 'Rio de Janeiro');
SET IDENTITY_INSERT dbo.Dim_Estado OFF;

SET IDENTITY_INSERT dbo.Dim_Cidade ON;
INSERT INTO dbo.Dim_Cidade (ID_Cidade, Nome_Cidade) VALUES
  (1, 'Curitiba'),
  (2, 'Campinas'),
  (3, 'Rio de Janeiro');
SET IDENTITY_INSERT dbo.Dim_Cidade OFF;
GO

-- INSERIR DIM_CONCESSIONARIA
SET IDENTITY_INSERT dbo.Dim_Concessionaria ON;
INSERT INTO dbo.Dim_Concessionaria
  (ID_Concessionaria, Nome_Concessionaria, ID_Cidade, ID_Estado, ID_Regiao)
VALUES
  (5, 'Carros importados cia LTDA', 1, 1, 1);
SET IDENTITY_INSERT dbo.Dim_Concessionaria OFF;
GO

-- INSERIR DIM_MONTADORA E DIM_MODELO
SET IDENTITY_INSERT dbo.Dim_Montadora ON;
INSERT INTO dbo.Dim_Montadora (ID_Montadora, Nome_Montadora) VALUES
  (25, 'GWM'),
  (26, 'BYD');
SET IDENTITY_INSERT dbo.Dim_Montadora OFF;

SET IDENTITY_INSERT dbo.Dim_Modelo ON;
INSERT INTO dbo.Dim_Modelo (ID_Modelo, ID_Montadora, Nome_Modelo) VALUES
  (97,  25, 'TANK 300'),
  (98,  25, 'ORA 03 SKIN BEV48'),
  (99,  25, 'ORA 03 GT BEV63'),
  (100, 25, 'HAVAL H6 HEV2'),
  (101, 25, 'HAVAL H6 PHEV19'),
  (102, 25, 'HAVAL H6 PHEV34'),
  (103, 25, 'HAVAL H6 GT'),
  (104, 26, 'BYD SONG PRO GS'),
  (105, 26, 'BYD DOLPHIN'),
  (106, 26, 'BYD DOLPHIN MINI'),
  (107, 26, 'BYD DOLPHIN PLUS'),
  (108, 26, 'BYD HAN'),
  (109, 26, 'BYD SEAL'),
  (110, 26, 'BYD TA'),
  (111, 26, 'BYD YUAN PLUS');
SET IDENTITY_INSERT dbo.Dim_Modelo OFF;
GO

-- INSERIR DIM_DATA
WITH Calendar AS
(
  SELECT CAST('2024-01-01' AS date) AS dt
  UNION ALL
  SELECT DATEADD(day,1,dt)
    FROM Calendar
   WHERE dt < '2024-12-31'
)
INSERT INTO dbo.Dim_Data (Dia, Mes, Ano, Dia_Semana, Bimestre, Trimestre)
SELECT
  DATEPART(day, dt),
  DATEPART(month, dt),
  DATEPART(year, dt),
  DATENAME(weekday, dt),
  CEILING(DATEPART(month, dt)/2.0),
  CEILING(DATEPART(month, dt)/3.0)
FROM Calendar
OPTION (MAXRECURSION 366);
GO

-- INSERIR VENDAS
DECLARE
    @idModelo           INT,
    @idData             INT,
    @idConcessionaria   INT,
    @quantidade         INT,
    @valorTotal         DECIMAL(18,2),
    @reps               INT         = 0,
    @numeroVezes        INT         = 5000,     
    @linhaCursor        INT,
    @totalRows          INT;

DECLARE cursorDados CURSOR
    LOCAL SCROLL STATIC
FOR
    SELECT m.ID_Modelo, d.ID_Data, c.ID_Concessionaria
      FROM dbo.Dim_Modelo        AS m
      CROSS JOIN dbo.Dim_Data    AS d
      CROSS JOIN dbo.Dim_Concessionaria AS c;
OPEN cursorDados;

FETCH NEXT FROM cursorDados;
SET @totalRows = @@CURSOR_ROWS;

IF @@FETCH_STATUS = 0
   FETCH ABSOLUTE 1 FROM cursorDados;

WHILE @reps < @numeroVezes
BEGIN
  SET @linhaCursor = FLOOR(RAND() * @totalRows) + 1;
  FETCH ABSOLUTE @linhaCursor
    FROM cursorDados
    INTO @idModelo, @idData, @idConcessionaria;

  SET @quantidade = FLOOR(RAND() * 5) + 1;


  SET @valorTotal = CAST(RAND() * 200000 + 100000 AS DECIMAL(18,2));

  INSERT INTO dbo.Fato_Vendas
    (ID_Modelo, ID_Data, ID_Concessionaria, Quantidade_Vendida, Valor_Total)
  VALUES
    (@idModelo, @idData, @idConcessionaria, @quantidade, @valorTotal);

  SET @reps += 1;
END

CLOSE cursorDados;
DEALLOCATE cursorDados;
