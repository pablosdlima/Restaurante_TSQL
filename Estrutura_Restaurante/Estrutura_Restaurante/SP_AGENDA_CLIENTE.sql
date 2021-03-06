CREATE PROC SP_AGENDA_CLIENTE
@REGISTRO CHAR(3), @ATENDENTE_CPF NVARCHAR(11), @CPF_CLIENTE NVARCHAR(11),
@NOME VARCHAR(128) = NULL,@EMAIL NVARCHAR(128) = NULL, @CELULAR NVARCHAR(11) = NULL,
@TELEFONE NVARCHAR(10) = NULL,@HORARIO DATETIME,@LUGAR INT = NULL 

AS
BEGIN
	DECLARE @FK_CLIENTE INT
	DECLARE @FK_FUNCIONARIO INT
	DECLARE @QUERY NVARCHAR(128)
	DECLARE @ERRO INT
	DECLARE @VERIFICA_HORARIO INT

	SET @QUERY = 'INSERT INTO AGENDA(HORARIO,LUGARES,ID_FUNCIONARIO,ID_CLIENTE)
	VALUES(' + CONVERT(VARCHAR,@HORARIO) + ',' + CONVERT(VARCHAR,@LUGAR) + ',' + CONVERT(VARCHAR,@FK_FUNCIONARIO) + ',' + CONVERT(VARCHAR,@FK_CLIENTE) + ')'
	SET @FK_FUNCIONARIO = (SELECT IDFUNCIONARIO FROM FUNCIONARIOS WHERE CPF = @ATENDENTE_CPF);
END
------FIM BLOCO PADR�O.
BEGIN TRANSACTION
	SET @VERIFICA_HORARIO =
	(SELECT COUNT(HORARIO) FROM AGENDA WHERE TOLERANCIA BETWEEN @HORARIO AND DATEADD(MINUTE,15,@HORARIO))

	IF @VERIFICA_HORARIO > 0
		BEGIN
			PRINT 'ESSE HOR�RIO J� FOI RESERVADO OU N�O EST� DISPONIVEL. POR FAVOR ESCOLHA OUTRO';
			SET @ERRO = 1;
		END
	IF @HORARIO < GETDATE()
		BEGIN
			PRINT 'N�O � POSSIVEL AGENDAR. A DATA ESCOLHIDA J� PASSOU';
			SET @ERRO = 1;
		END
	ELSE
		BEGIN
			PRINT 'VERIFICA��O DE HOR�RIO OK'
		END
--------FIM IF VERIFICA HOR�RIO
	IF @REGISTRO LIKE ('S%')
		BEGIN
			SET @FK_CLIENTE = (SELECT IDCLIENTE FROM CLIENTE WHERE CPF = @CPF_CLIENTE);
			IF	@FK_CLIENTE IS NULL
				BEGIN
					PRINT 'S | NENHUMA FK ENCONTRADA'
					SET @ERRO = 1;
				END
			--FIM VERIFICA FK | S
			INSERT INTO AGENDA(HORARIO,LUGARES,ID_FUNCIONARIO,ID_CLIENTE)
			VALUES(@HORARIO,@LUGAR,@FK_FUNCIONARIO,@FK_CLIENTE);

			IF (SELECT COUNT(IDAGENDA) FROM AGENDA WHERE IDAGENDA = @@IDENTITY) <= 0
				BEGIN
					PRINT 'S | AGENDAMENTO N�O FOI REALIZADO.'
					SET @ERRO = 1;
				END
		END
	ELSE IF @REGISTRO LIKE ('N%')
		BEGIN
			INSERT INTO CLIENTE (NOME_CLIENTE,CPF) VALUES(@NOME,@CPF_CLIENTE);
			SET @FK_CLIENTE = @@IDENTITY;
			IF	@FK_CLIENTE IS NULL
				BEGIN
					PRINT 'N | NENHUMA FK ENCONTRADA'
					SET @ERRO = 1;
				END
			---FIM VERIFICA FK | N
			IF (SELECT COUNT(IDCLIENTE) FROM CLIENTE WHERE IDCLIENTE = @@IDENTITY) <= 0
				BEGIN
					PRINT 'N | CADASTRO CLIENTE N�O FOI REALIZADO.'
					SET @ERRO = 1;
				END
			----FIM CLIENTE
			INSERT INTO CONTATOS (EMAIL,CELULAR,TELEFONE,ID_CLIENTE) VALUES (@EMAIL,@CELULAR,@TELEFONE,@FK_CLIENTE);
			
			IF (SELECT COUNT(IDCONTATO) FROM CONTATOS WHERE IDCONTATO = @@IDENTITY) <= 0
				BEGIN
					PRINT 'N | CADASTRO CONTATOS N�O FOI REALIZADO.'
					SET @ERRO = 1;
				END
			----FIM CONTATOS
			INSERT INTO AGENDA(HORARIO,LUGARES,ID_FUNCIONARIO,ID_CLIENTE)
			VALUES(@HORARIO,@LUGAR,@FK_FUNCIONARIO,@FK_CLIENTE);
			
			IF (SELECT COUNT(IDAGENDA) FROM AGENDA WHERE IDAGENDA = @@IDENTITY) <= 0
				BEGIN
					PRINT 'N | AGENDAMENTO N�O FOI REALIZADO.'
					SET @ERRO = 1;
				END
		END
	ELSE
		BEGIN
			SELECT 'TEXTO INV�LIDO!!!'
			SET @ERRO = 1;
		END
--------FIM VERIFICA SE EXISTE CADASTRO
IF @ERRO > 0
	BEGIN
		ROLLBACK
	END
ELSE
	BEGIN
		SELECT * FROM AGENDA WHERE IDAGENDA = @@IDENTITY;
		PRINT ('AGENDAMENTO CONFIRMADO na data: ' + CONVERT(VARCHAR,@HORARIO));
		COMMIT
	END
GO
