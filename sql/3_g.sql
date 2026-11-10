DELIMITER //

CREATE PROCEDURE
    sp_analisis_usuario(
        IN id_usuario INT,
        IN fecha_inicio DATE,
        IN fecha_fin DATE
    )
    BEGIN 
        /* Total de publicaciones realizadas en el periodo */
        SELECT COUNT(*) as total_publicaciones
            FROM Publicacion as pub 
            WHERE pub.IDU = id_usuario
                AND DATE(pub.FechaCreacion) BETWEEN fecha_inicio AND fecha_fin;

        /* Total reacciones dadas en el periodo */
        SELECT COUNT(r.IDPub) as total_reacciones_dadas
            FROM Reaccionar as r
            WHERE r.IDU = id_usuario 
                AND r.Fecha BETWEEN fecha_inicio AND fecha_fin;

        /* Total reacciones recibidas en el periodo */
        SELECT COUNT(*) as total_reacciones_recibidas
            FROM Publicacion as p
            JOIN Reaccionar as r ON r.IDPub = p.IDPub
            WHERE p.IDU = id_usuario
                AND r.Fecha BETWEEN fecha_inicio AND fecha_fin;

        /* Total comentarios realizados en el periodo */
        SELECT COUNT(*) as total_comentarios
            FROM Comentar as c
            WHERE c.IDU = id_usuario
                AND DATE(c.FechaCreacion) BETWEEN fecha_inicio AND fecha_fin;

        /* Total de compras y monto gastado en el periodo */
        SELECT COUNT(*) as total_compras,
            ROUND(SUM(Cantidad*Precio), 2) as monto_gastado
            FROM Compra as c
            WHERE IDUC = id_usuario
                AND c.Fecha BETWEEN fecha_inicio AND fecha_fin;

        /* Total de contribuciones en el periodo */
        SELECT COUNT(*) as total_contribuciones
            FROM Contribucion as c
            WHERE c.IDU = id_usuario
                AND c.Fecha BETWEEN fecha_inicio AND fecha_fin;

        /* Especie mas comprada y mas contribuida en el periodo */
        SELECT 
            (SELECT e.NombreCientifico
                FROM Contribucion as contr
                JOIN Especie as e ON e.IDProd = contr.IDProd
                WHERE contr.IDU = id_usuario
                    AND contr.Fecha BETWEEN fecha_inicio AND fecha_fin
                GROUP BY e.NombreCientifico
                ORDER BY COUNT(*) DESC
                LIMIT 1
            )  as especie_mas_contribuida,
            (SELECT e.NombreCientifico
                FROM Especie as e
                JOIN Compra as c ON e.IDProd = c.IDProd
                WHERE c.IDUC = id_usuario
                    AND c.Fecha BETWEEN fecha_inicio AND fecha_fin
                GROUP BY e.NombreCientifico
                ORDER BY SUM(c.Cantidad) DESC
                LIMIT 1
            ) as especie_mas_vendida;
    END //

DELIMITER ;