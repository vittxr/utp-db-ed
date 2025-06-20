-- Criar a base de dados
CREATE DATABASE IF NOT EXISTS sales_data_mart;

-- Usar a base de dados criada
USE sales_data_mart;

-- Criar a tabela de dimensão: dim_model
CREATE TABLE dim_model (
    model_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL
);

-- Criar a tabela de dimensão: dim_manufacturer
CREATE TABLE dim_manufacturer (
    manufacturer_id INT AUTO_INCREMENT PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL
);

-- Criar a tabela de dimensão: dim_date
CREATE TABLE dim_date (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    bimester INT NOT NULL,
    trimester INT NOT NULL,
    year INT NOT NULL
);

-- Criar a tabela de dimensão: dim_dealership
CREATE TABLE dim_dealership (
    dealership_id INT AUTO_INCREMENT PRIMARY KEY,
    dealership_name VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

-- Criar a tabela de fatos: fact_sales
CREATE TABLE fact_sales (
    sales_id INT AUTO_INCREMENT PRIMARY KEY,
    model_id INT NOT NULL,
    manufacturer_id INT NOT NULL,
    date_id INT NOT NULL,
    dealership_id INT NOT NULL,
    sales_value DECIMAL(10, 2) NOT NULL,
    sales_quantity INT NOT NULL,
    FOREIGN KEY (model_id) REFERENCES dim_model(model_id),
    FOREIGN KEY (manufacturer_id) REFERENCES dim_manufacturer(manufacturer_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (dealership_id) REFERENCES dim_dealership(dealership_id)
);

SELECT
    dm.model_name AS Modelo,
    dman.manufacturer_name AS Montadora,
    dd.date AS Data,
    dd.day_of_week AS Dia_da_Semana,
    dd.day AS Dia,
    dd.month AS Mes,
    dd.bimester AS Bimestre,
    dd.trimester AS Trimestre,
    dd.year AS Ano,
    ddeal.dealership_name AS Concessionaria,
    ddeal.state AS Estado,
    ddeal.city AS Cidade,
    ddeal.region AS Regiao,
    SUM(fs.sales_value) AS Valor_Total_Vendas,
    SUM(fs.sales_quantity) AS Quantidade_Total_Vendas
FROM
    fact_sales fs
JOIN
    dim_model dm ON fs.model_id = dm.model_id
JOIN
    dim_manufacturer dman ON fs.manufacturer_id = dman.manufacturer_id
JOIN
    dim_date dd ON fs.date_id = dd.date_id
JOIN
    dim_dealership ddeal ON fs.dealership_id = ddeal.dealership_id
GROUP BY
    dm.model_name,
    dman.manufacturer_name,
    dd.date,
    dd.day_of_week,
    dd.day,
    dd.month,
    dd.bimester,
    dd.trimester,
    dd.year,
    ddeal.dealership_name,
    ddeal.state,
    ddeal.city,
    ddeal.region;
