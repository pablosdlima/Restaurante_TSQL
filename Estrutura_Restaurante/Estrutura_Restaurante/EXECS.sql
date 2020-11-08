-- ORDEM DE EXECUÇÃO

-- AGENDANDO CLIENTES ---INICIO--------------------------------------------------------------------------

SELECT * FROM VW_CLIENTES
GO
SELECT * FROM VW_AGENDAMENTO
GO

EXEC SP_AGENDA_CLIENTE 'S','10000000001','00000000020','BERRY ALEN','BERRY@EMAIL.COM','11900001001',NULL,'08-11-2020 18:49',2;
--COM CLIENTE JÁ CADASTRADO.
GO

SELECT * FROM VW_AGENDAMENTO GO

-- AGENDANDO CLIENTES ---FIM-----------------------------------------------------------------------------

-- DIRECIONANDO AGENDA ---INICIO--------------------------------------------------------------------------

SELECT * FROM VW_AGENDAMENTO GO

EXEC SP_DIRECIONA_AGENDA 'S','0000000020','BERRY ALEN';
--DIRECIONANDO AGENDAMENTO PARA MESA OU FILA
GO

SELECT * FROM ##FILA GO
SELECT *FROM VW_MESA GO

-- DIRECIONANDO AGENDA ---FIM--------------------------------------------------------------------------

-- GERENCIA FILA ---INICIO-----------------------------------------------------------------------------
SELECT * FROM ##FILA GO

EXEC SP_GERENCIA_FILA 1
-- GERENCIANDO A FILA
GO

SELECT * FROM VW_MESA GO
-- GERENCIA FILA ---FIM-----------------------------------------------------------------------------

-- ANOTA PEDIDO ---INICIO---------------------------------------------------------------------------
EXEC SP_ANOTA_PEDIDO 'Virada Paulista','SEM CEBOLA','10000000001', 1
GO

SELECT * FROM VW_PEDIDOS


-- ANOTA PEDIDO ---FIM------------------------------------------------------------------------------

SELECT * FROM FUNCIONARIOS
SELECT * FROM MESA
SELECT * FROM PEDIDOS





