-- ENTREGA PEDIDO

CREATE PROCEDURE SP_ENTREGA_PEDIDO @IDPEDIDO INT
AS
	BEGIN
		UPDATE PEDIDOS SET HORA_ENTREGA = GETDATE() WHERE IDPEDIDO = @IDPEDIDO;
		DELETE FROM ##LISTA WHERE ID_PEDIDO = @IDPEDIDO;
	END	
GO
