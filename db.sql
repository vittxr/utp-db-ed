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
