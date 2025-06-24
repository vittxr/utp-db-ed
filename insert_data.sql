-- Carga inicial - Tabelas dimensionais
INSERT INTO adm_bd_trabalho.dbo.Concessionaria (id_concessionaria, nome_fantasia)
SELECT con_id, con_nome_fantasia
FROM revenda.dbo.concessionaria;

INSERT INTO adm_bd_trabalho.dbo.Modelo (id_modelo, nome)
SELECT mod_id, mod_descricao
FROM revenda.dbo.modelo;

INSERT INTO adm_bd_trabalho.dbo.Montadora (id_montadora, nome)
SELECT DISTINCT mon_id, mon_nome
FROM revenda.dbo.montadora;

INSERT INTO adm_bd_trabalho.dbo.Cidade (id_cidade, nome)
SELECT DISTINCT cid_id, cid_nome
FROM revenda.dbo.cidade;

INSERT INTO adm_bd_trabalho.dbo.Estado (id_estado, nome, sigla)
SELECT DISTINCT est_id, est_nome, est_sigla
FROM revenda.dbo.estado;

INSERT INTO adm_bd_trabalho.dbo.Regiao (id_regiao, nome)
SELECT DISTINCT reg_id, reg_nome
FROM revenda.dbo.regiao;

INSERT INTO adm_bd_trabalho.dbo.Tempo (id_tempo, data, dia, mes, ano, dia_semana, semestre, bimestre, trimestre)
SELECT
    ROW_NUMBER() OVER (ORDER BY ven_data) AS id_tempo,
    ven_data,
    DAY(ven_data),
    MONTH(ven_data),
    YEAR(ven_data),
    DATEPART(WEEKDAY, ven_data),
    CASE WHEN MONTH(ven_data) <= 6 THEN 1 ELSE 2 END,
    CEILING(MONTH(ven_data)/2.0),
    CEILING(MONTH(ven_data)/3.0)
FROM (
    SELECT DISTINCT ven_data
    FROM revenda.dbo.venda
) AS datas;

INSERT INTO adm_bd_trabalho.dbo.Fato_Venda (
    id_tempo, id_montadora, id_modelo, id_cidade, id_estado, id_regiao, id_concessionaria, quantidade, valor
)
SELECT
    t.id_tempo,
    mo.mon_id,
    mo.mod_id,
    c.cid_id,
    e.est_id,
    r.reg_id,
    v.con_id,
    SUM(vv.vve_quantidade),
    SUM(vv.vve_quantidade * vv.vve_valor - vv.vve_desconto)
FROM revenda.dbo.venda v
JOIN revenda.dbo.vendaVeiculo vv ON v.ven_id = vv.ven_id
JOIN revenda.dbo.veiculo ve ON vv.vei_id = ve.vei_id
JOIN revenda.dbo.modelo mo ON ve.mod_id = mo.mod_id
JOIN revenda.dbo.montadora mo2 ON mo.mon_id = mo2.mon_id
JOIN revenda.dbo.concessionaria co ON v.con_id = co.con_id
JOIN revenda.dbo.cidade c ON co.cid_id = c.cid_id
JOIN revenda.dbo.estado e ON c.est_id = e.est_id
JOIN revenda.dbo.regiao r ON e.reg_id = r.reg_id
JOIN adm_bd_trabalho.dbo.Tempo t ON t.data = v.ven_data
GROUP BY
    t.id_tempo, mo.mon_id, mo.mod_id, c.cid_id, e.est_id, r.reg_id, v.con_id;

CREATE PROCEDURE adm_bd_trabalho.dbo.sp_ETL_Incremental (@DataInicio DATE)
AS
BEGIN
    SET NOCOUNT ON;

    -- Inserir datas novas na tabela Tempo
    INSERT INTO adm_bd_trabalho.dbo.Tempo (id_tempo, data, dia, mes, ano, dia_semana, semestre, bimestre, trimestre)
    SELECT
        ROW_NUMBER() OVER (ORDER BY ven_data) + (SELECT ISNULL(MAX(id_tempo), 0) FROM adm_bd_trabalho.dbo.Tempo),
        ven_data,
        DAY(ven_data),
        MONTH(ven_data),
        YEAR(ven_data),
        DATEPART(WEEKDAY, ven_data),
        CASE WHEN MONTH(ven_data) <= 6 THEN 1 ELSE 2 END,
        CEILING(MONTH(ven_data)/2.0),
        CEILING(MONTH(ven_data)/3.0)
    FROM (
        SELECT DISTINCT ven_data
        FROM revenda.dbo.venda
        WHERE ven_data >= @DataInicio
          AND ven_data NOT IN (SELECT data FROM adm_bd_trabalho.dbo.Tempo)
    ) AS novas_datas;

    -- Inserir novos dados na Fato_Venda
    INSERT INTO adm_bd_trabalho.dbo.Fato_Venda (
        id_tempo, id_montadora, id_modelo, id_cidade, id_estado, id_regiao, id_concessionaria, quantidade, valor
    )
    SELECT
        t.id_tempo,
        mo.mon_id,
        mo.mod_id,
        c.cid_id,
        e.est_id,
        r.reg_id,
        v.con_id,
        SUM(vv.vve_quantidade),
        SUM(vv.vve_quantidade * vv.vve_valor - vv.vve_desconto)
    FROM revenda.dbo.venda v
    JOIN revenda.dbo.vendaVeiculo vv ON v.ven_id = vv.ven_id
    JOIN revenda.dbo.veiculo ve ON vv.vei_id = ve.vei_id
    JOIN revenda.dbo.modelo mo ON ve.mod_id = mo.mod_id
    JOIN revenda.dbo.montadora mo2 ON mo.mon_id = mo2.mon_id
    JOIN revenda.dbo.concessionaria co ON v.con_id = co.con_id
    JOIN revenda.dbo.cidade c ON co.cid_id = c.cid_id
    JOIN revenda.dbo.estado e ON c.est_id = e.est_id
    JOIN revenda.dbo.regiao r ON e.reg_id = r.reg_id
    JOIN adm_bd_trabalho.dbo.Tempo t ON t.data = v.ven_data
    WHERE v.ven_data >= @DataInicio
    GROUP BY
        t.id_tempo, mo.mon_id, mo.mod_id, c.cid_id, e.est_id, r.reg_id, v.con_id;
END;
