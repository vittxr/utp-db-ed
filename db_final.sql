-- Criação do banco de dados
CREATE DATABASE adm_bd_trabalho;
USE adm_bd_trabalho;

-- Tabela Tempo
CREATE TABLE Tempo (
    id_tempo INT PRIMARY KEY,
    data DATE,
    dia INT,
    mes INT,
    ano INT,
    dia_semana INT,
    semestre INT,
    bimestre INT,
    trimestre INT
);

-- Tabela Montadora
CREATE TABLE Montadora (
    id_montadora INT PRIMARY KEY,
    nome VARCHAR(200)
);

-- Tabela Modelo
CREATE TABLE Modelo (
    id_modelo INT PRIMARY KEY,
    nome VARCHAR(200)
);

-- Tabela Cidade
CREATE TABLE Cidade (
    id_cidade INT PRIMARY KEY,
    nome VARCHAR(200)
);

-- Tabela Estado
CREATE TABLE Estado (
    id_estado INT PRIMARY KEY,
    nome VARCHAR(100),
    sigla CHAR(2)
);

-- Tabela Região
CREATE TABLE Regiao (
    id_regiao INT PRIMARY KEY,
    nome VARCHAR(100)
);

-- Tabela Concessionária
CREATE TABLE Concessionaria (
    id_concessionaria INT PRIMARY KEY,
    nome_fantasia VARCHAR(200)
);

-- Tabela Fato - Vendas
CREATE TABLE Fato_Venda (
    id_tempo INT,
    id_montadora INT,
    id_modelo INT,
    id_cidade INT,
    id_estado INT,
    id_regiao INT,
    id_concessionaria INT,
    quantidade INT,
    valor DECIMAL(15,2),
    FOREIGN KEY (id_tempo) REFERENCES Tempo(id_tempo),
    FOREIGN KEY (id_montadora) REFERENCES Montadora(id_montadora),
    FOREIGN KEY (id_modelo) REFERENCES Modelo(id_modelo),
    FOREIGN KEY (id_cidade) REFERENCES Cidade(id_cidade),
    FOREIGN KEY (id_estado) REFERENCES Estado(id_estado),
    FOREIGN KEY (id_regiao) REFERENCES Regiao(id_regiao),
    FOREIGN KEY (id_concessionaria) REFERENCES Concessionaria(id_concessionaria)
);
