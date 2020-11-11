-- ORDEM DE EXECUÇÃO

--CADASTRANDO FUNCIONÁRIOS --INICIO
EXEC SP_CADASTRO_FUNCIONARIO 'ALFREDO','10000000002','02-05-2000','GARÇOM'

SELECT * FROM FUNCIONARIOS GO
--CADASTRANDO FUNCIONÁRIOS --FIM


-- AGENDANDO CLIENTES ---INICIO--------------------------------------------------------------------------

SELECT * FROM VW_CLIENTES
GO
SELECT * FROM VW_AGENDAMENTO
GO

EXEC SP_AGENDA_CLIENTE 'N','10000000002','0000000001','BARRY ALEN','BERRY@EMAIL.COM','11900001001',NULL,'10-11-2020 22:00',2;
--COM CLIENTE CADASTRANDO.
GO

EXEC SP_AGENDA_CLIENTE 'S','10000000002','0000000001',NULL,NULL,NULL,NULL,'10-11-2020 22:21',1;
--COM CLIENTE CADASTRANDO 2.
GO

SELECT * FROM VW_AGENDAMENTO

SELECT * FROM VW_CLIENTES

-- AGENDANDO CLIENTES ---FIM-----------------------------------------------------------------------------

-- DIRECIONANDO AGENDA ---INICIO--------------------------------------------------------------------------

SELECT * FROM VW_AGENDAMENTO GO

EXEC SP_DIRECIONA_AGENDA 'N','0000000001','BARRY ALEN';
--DIRECIONANDO AGENDAMENTO PARA MESA
GO

EXEC SP_DIRECIONA_AGENDA 'N','00000000030','BRUCE WAYNE';
--DIRECIONANDO AGENDAMENTO PARA FILA
GO

SELECT * FROM VW_AGENDAMENTO 
WHERE (GETDATE() BETWEEN HORARIO AND TOLERANCIA)
ORDER BY HORARIO

SELECT * FROM ##FILA GO

SELECT *FROM VW_MESA GO

-- DIRECIONANDO AGENDA ---FIM--------------------------------------------------------------------------

-- GERENCIA FILA ---INICIO-----------------------------------------------------------------------------
SELECT * FROM ##FILA GO

EXEC SP_GERENCIA_FILA 4
-- GERENCIANDO A FILA
GO

SELECT * FROM ##FILA GO
SELECT * FROM VW_MESA GO
-- GERENCIA FILA ---FIM-----------------------------------------------------------------------------

-- ANOTA PEDIDO ---INICIO---------------------------------------------------------------------------
EXEC SP_ANOTA_PEDIDO 'Virada Paulista','SEM CEBOLA','10000000002', 1
GO

SELECT * FROM VW_PEDIDOS
go

-- ANOTA PEDIDO ---FIM------------------------------------------------------------------------------

--ENTREGA PEDIDO --INICIO---------------------------------------------------------------------------
SELECT * FROM ##LISTA GO

EXEC SP_ENTREGA_PEDIDO 1

SELECT * FROM VW_PEDIDOS GO
SELECT * FROM ##LISTA GO

--ENTREGA PEDIDO --FIM---------------------------------------------------------------------------


SELECT * FROM FUNCIONARIOS
SELECT * FROM MESA
SELECT * FROM CARDAPIO




