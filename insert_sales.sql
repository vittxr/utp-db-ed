DECLARE cursorDados CURSOR
    LOCAL SCROLL STATIC
FOR
    SELECT m.ID_Modelo, d.ID_Data, c.ID_Concessionaria
      FROM dbo.Dim_Modelo        AS m
      CROSS JOIN dbo.Dim_Data    AS d
      CROSS JOIN dbo.Dim_Concessionaria AS c;
OPEN cursorDados;

-- 2) Capture how many rows are in the cursor
FETCH NEXT FROM cursorDados;
SET @totalRows = @@CURSOR_ROWS;
/* rewind */
IF @@FETCH_STATUS = 0
   FETCH ABSOLUTE 1 FROM cursorDados;

-- 3) Loop and INSERT
WHILE @reps < @numeroVezes
BEGIN
  -- choose a random row in [1..@totalRows]
  SET @linhaCursor = FLOOR(RAND() * @totalRows) + 1;
  FETCH ABSOLUTE @linhaCursor
    FROM cursorDados
    INTO @idModelo, @idData, @idConcessionaria;

  -- random quantity 1..5
  SET @quantidade = FLOOR(RAND() * 5) + 1;

  -- random total value R$100 000 to R$300 000
  SET @valorTotal = CAST(RAND() * 200000 + 100000 AS DECIMAL(18,2));

  -- insert into fact
  INSERT INTO dbo.Fato_Vendas
    (ID_Modelo, ID_Data, ID_Concessionaria, Quantidade_Vendida, Valor_Total)
  VALUES
    (@idModelo, @idData, @idConcessionaria, @quantidade, @valorTotal);

  SET @reps += 1;
END

-- 4) Cleanup
CLOSE cursorDados;
DEALLOCATE cursorDados;