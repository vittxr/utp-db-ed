use ABD_aula;
go
set language BRAZILIAN;

insert into concessionaria values (5, 'Carros importados cia LTDA', 'Imports car', '123456654', '419868745', 'Avenida Mario Tourinho, 10542', null, 'Barigui', 2878)
insert into montadora values (25, 'GWM');
insert into montadora values (26, 'BYD');
insert into modelo values (97, 'TANK 300', 25);
insert into modelo values (98, 'ORA 03 SKIN BEV48', 25);
insert into modelo values (99, 'ORA 03 GT BEV63', 25);
insert into modelo values (100, 'HAVAL H6 HEV2', 25);
insert into modelo values (101, 'HAVAL H6 PHEV19', 25);
insert into modelo values (102, 'HAVAL H6 PHEV34', 25);
insert into modelo values (103, 'HAVAL H6 GT', 25);
insert into modelo values (104, 'BYD SONG PRO GS', 26);
insert into modelo values (105, 'BYD DOLPHIN', 26);
insert into modelo values (106, 'BYD DOLPHIN MINI', 26);
insert into modelo values (107, 'BYD DOLPHIN PLUS', 26);
insert into modelo values (108, 'BYD HAN', 26);
insert into modelo values (109, 'BYD SEAL', 26);
insert into modelo values (110, 'BYD TA', 26);
insert into modelo values (111, 'BYD YUAN PLUS', 26);
insert into veiculo values (3001, '8A1BB8W05CL238809', 'AM04I64', 205000, 2024, 2024, 7072485, 2, 'S', 'H', 105, 5, 3, 5);
insert into veiculo values (3002, '8A2BccW05CL238809', 'ABD025X', 190000, 2025, 2025, 6952485, 2, 'S', 'H', 100, 5, 3, 5)

-- Insert venda de veículos
select getdate();
declare cursorDados cursor
local
scroll
for
	select cliente.cli_id, veiculo.vei_id, Funcionario.fun_id, veiculo.vei_valor
	from cliente
	cross join veiculo 
	cross join funcionario
	
	declare @ano int;
	declare @mes int;
	declare @dia int;
	declare @vendaId int;
	declare @veiculoId int;
	declare @clienteId int;
	declare @funcionarioId int;
	declare @dataString varchar(10);
	declare @dataVenda date;
	declare @precoVenda decimal(14,2);
	declare @desconto decimal(14,2);
	declare @anoInicial int;
	declare @anoAtual int;
	declare @mesAtual int;
	declare @quantidade int;
	declare @menor int; 
	declare @maior int;
	declare @numeroLinhasCursor int;
	declare @concessionaria int;
	declare @concessionariaMax int;
	declare @numeroVezes int;
	declare @repeticoes int;
	declare @linhaCursor int;
	declare @numero int;

	-- Busca o número de concessionárias
	set @concessionariaMax = (select max(con_id) from concessionaria);
	if @concessionariaMax is null
	begin 
		set @concessionariaMax = 0;
	end

	-- Busca o número de vendas já realizadas
	set @vendaId = (select max(ven_id) from venda);
		if @vendaId is null
	begin 
		set @vendaId = 0;
	end

	-- Seta o ano e mes atuais
	set @anoAtual = 2024;
	set @mesAtual = 12;

	-- Inicializa as variáveis
	set @anoInicial = 2024;
	set @repeticoes = 0;
	set @linhaCursor = 0;
	set @numeroVezes = 2000;

	--Abre o cursor e verifica quantas linhas tem
	open cursorDados;
	set @numeroLinhasCursor = @@CURSOR_ROWS;

	while @repeticoes < @numeroVezes
	begin
		--Gera a data da venda.
		set @ano = @anoInicial

		if @anoAtual > @anoInicial 
		begin
			set @maior = @anoAtual;
			set @menor = @anoInicial;
			set @ano = (select round(((@maior - @menor -1) * rand() + @menor), 0));
		end 

		if @ano = @anoAtual 
		begin
			set @mes = (select round(((@mesAtual - 1 -1) * rand() + 1), 0));
		end
		else
			begin
				set @mes = (select round(((12 - 1 -1) * rand() + 1), 0));
			end
		
		if @mes = 2
		begin
			set @dia = (select round(((28 - 1 -1) * rand() + 1), 0));
		end
		else
			begin 
				if  @mes in(04, 06, 09, 11) 
				begin
					set @dia = (select round(((30 - 1 -1) * rand() + 1), 0));
				end
				else
					begin
						set @dia = (select round(((31 - 1 -1) * rand() + 1), 0));
					end
			end

		--Transforma a data gerada em uma variável data.
		set @dataString = convert(varchar(04), @ano) + '/' + convert(varchar(04), @mes) + '/' + convert(varchar(04), @dia);
		set @dataVenda  = CONVERT(date, @dataString);
		
		--Gera uma quantidade aleatória entre 1 e 8
		set @maior = 5;
		set @menor = 1;
		set @quantidade = (select round(((@maior - @menor -1) * rand() + @menor), 0));

		--Verifica se a quantidade está zerada
		if @quantidade is null or @quantidade = 0
		begin 
			set @quantidade = 1;
		end

		-- Sortear linha do cursor
		set @linhaCursor = (select round(((@numeroLinhasCursor -1 -1) * rand() + 1), 0));
		
		-- Lê o cursor na linha sorteada
		fetch absolute @linhaCursor from cursorDados into @clienteId, @veiculoId, @funcionarioId, @precoVenda;

		--Gerar eventualmente um desconto.
		set @menor = 1 ---- menor número
		set @maior = 4 ---- maior número
		set @numero = (select round(((@maior - @menor -1) * rand() + @menor), 0));

		set @desconto = 0;
		if @numero = 1
		begin
			set @desconto = @precoVenda * 0.10;
		end
		if @numero = 2
		begin
			set @desconto = @precoVenda * 0.15;
		end

		-- Gera uma concessionária aleatoria
		set @menor = 1 ---- menor número
		set @maior = @concessionariaMax + 1 -- maior número
		set @concessionaria = (select round(((@maior - @menor -1) * rand() + @menor), 0));

		-- insere a venda
		set @vendaId  = @vendaId  + 1;
		insert into venda values (@vendaId, @clienteId, @funcionarioId, @dataVenda, @concessionaria);
		insert into vendaVeiculo values (@vendaId, 1, @veiculoId, @quantidade, @precoVenda, @desconto);

		set @repeticoes = @repeticoes + 1;
	end

close cursorDados;
deallocate cursorDados;

select ven_data, count(*) 
from venda 
where year(ven_data) = 2024
group by ven_data 
order by ven_data;


delete from vendaVeiculo
where ven_id in (select ven_id 
					from venda 
					where ven_data in ('2024-09-07', '2024-12-25', '2024-01-01'));

delete from venda 
where ven_data in ('2024-09-07', '2024-12-25', '2024-01-01');

