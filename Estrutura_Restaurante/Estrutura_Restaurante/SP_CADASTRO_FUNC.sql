-- Cadastro de Funcion�rio

USE RESTAURANTE GO


CREATE PROCEDURE SP_CADASTRO_FUNCIONARIO @NOME_FUNCIONARIO VARCHAR(128), @CPF NVARCHAR(11), 
@NASCIMENTO DATE, @CARGO NVARCHAR(50)

AS
	BEGIN
		DECLARE @ERRO INT

		IF (SELECT COUNT(*) FROM FUNCIONARIOS WHERE CPF = @CPF) >= 1 
			BEGIN
				PRINT 'J� EXISTE ALGU�M COM ESSE CPF.'
				SET @ERRO = 1
			END
		ELSE IF (@CARGO <> 'ATENDENTE') AND (@CARGO <> 'GAR�OM') AND (@CARGO <> 'COZINHEIRO')
			BEGIN
				PRINT 'O CARGO MENCIONADO N�O EXISTE!'
				SET @ERRO = 1
			END
		ELSE IF (SELECT COUNT(*) FROM FUNCIONARIOS WHERE CPF = @CPF) = 0 
			BEGIN
				INSERT INTO FUNCIONARIOS 
				VALUES(@NOME_FUNCIONARIO,@CPF,@NASCIMENTO,@CARGO,DEFAULT)
				PRINT 'USUARIO CADASTRADO'
			END
		ELSE
			BEGIN
				PRINT 'ERRO DESCONHECIDO.'
			END
	END
GO

EXEC SP_CADASTRO_FUNCIONARIO 'ALFREDO','10000000002','02-05-2000','GAR�OM'

SELECT * FROM FUNCIONARIOS