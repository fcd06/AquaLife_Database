DELIMITER //

CREATE TRIGGER tgr_auditar_precio AFTER UPDATE
    ON Producto
    FOR EACH ROW BEGIN
        INSERT INTO Historial_Precios(
            IDProd,
            PrecioAnterior,
            PrecioNuevo,
            PorcentajeCambio,
            NombreUsuario
        )
        VALUES (
            NEW.IDProd,
            OLD.Precio,
            NEW.Precio,
            (NEW.Precio - OLD.Precio)/OLD.Precio * 100,
            @nombre_usuario
        );
    END //

DELIMITER ;