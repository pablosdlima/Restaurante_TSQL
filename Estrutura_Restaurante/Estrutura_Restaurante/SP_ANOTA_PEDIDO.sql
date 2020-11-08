-- PROCEDURE PARA A REALIZA��O DE PEDIDOS.


CREATE PROCEDURE SP_ANOTA_PEDIDO @PRATO NVARCHAR(50), @OBS NVARCHAR(255) = NULL, @ATENDENTE_CPF NVARCHAR(11), @N_MESA INT
AS
	BEGIN TRANSACTION
		DECLARE @FK_ATENDENTE INT
		DECLARE @FK_CARDAPIO INT
		DECLARE @FK_MESA INT
		DECLARE @FK_PEDIDO INT
		DECLARE @ERRO INT

		SET @FK_CARDAPIO = (SELECT IDCARDAPIO FROM CARDAPIO WHERE NOME_PRATO = @PRATO)
		SET @FK_ATENDENTE = (SELECT IDFUNCIONARIO FROM FUNCIONARIOS WHERE CPF = @ATENDENTE_CPF)
		SET @FK_MESA = (SELECT MIN(IDMESA) FROM MESA WHERE NUMERO = @N_MESA AND SAIDA IS NULL)

		IF (@FK_ATENDENTE IS NULL)
			BEGIN
				PRINT 'ATENDENTE MENCIONADO N�O EXISTE'
				SET @ERRO = 1
			END
		ELSE IF (@FK_CARDAPIO IS NULL)
			BEGIN
				PRINT 'ESSA OP��O N�O EXISTE NO CARD�PIO'
				SET @ERRO = 1
			END
		ELSE IF (@FK_MESA IS NULL)
			BEGIN
				PRINT 'ESSA MESA N�O EXISTE'
				SET @ERRO = 1
			END
		ELSE
			BEGIN
				INSERT INTO PEDIDOS (HORARIO,OBS,ID_MESA,ID_FUNCIONARIO,ID_CARDAPIO) 
				VALUES (GETDATE(),NULL,@FK_MESA,@FK_ATENDENTE,@FK_CARDAPIO);

				SET @FK_PEDIDO = (SELECT IDPEDIDO FROM PEDIDOS WHERE IDPEDIDO = @@IDENTITY)
				
				IF (@FK_PEDIDO IS NOT NULL)
					BEGIN
						INSERT INTO ##LISTA (ENTRADA,ID_PEDIDO)
						VALUES (GETDATE(),@FK_PEDIDO)
					END
				ELSE
					BEGIN
						SET @ERRO = 1
					END
			END
		IF @ERRO >= 0
			BEGIN
				ROLLBACK;
			END
		ELSE
			BEGIN
				COMMIT;
			END
GO

DROP PROCEDURE SP_ANOTA_PEDIDO

EXEC SP_ANOTA_PEDIDO '','','',

SELECT * FROM CARDAPIO GO
SELECT * FROM MESA GO
SELECT * FROM VW_PEDIDOS GO
SELECT * FROM PEDIDOS GO