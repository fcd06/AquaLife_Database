DELIMITER //

CREATE TRIGGER tgr_auditar_precio AFTER UPDATE
    ON Producto
    FOR EACH ROW
BEGIN
    IF NEW.Precio <> OLD.Precio THEN
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
            ROUND((NEW.Precio - OLD.Precio) / OLD.Precio * 100, 2),
            @nombre_usuario
        );
    END IF;
END //

DELIMITER ;