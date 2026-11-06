/*
Procedimiento almancenado para revisa el perfil de actividad de un usuario
Parametros IDU, fecha inicio y fecha fianl del periodo evaluado

Total de publicaciones realizadas en el perıodo
Total de reacciones dadas y recibidas
Total de comentarios realizados
Total de compras y monto gastado
Total de contribuciones (bitacoras de mantenimiento) realizadas
Especie mias comprada y especie mas contribuida

*/

DELIMITER //

CREATE PROCEDURE sp_analisis_usuario(
        IN id_usuario INT,
        IN fecha_inicio DATE,
        IN fecha_fin DATE
    )
    BEGIN 
        /* 
        Total de publicaiones Realizadas - historico
        Posibles modificaciones para hacerlo en el intervalo de fecha dado
        con futuras modificaciones a la base de datos
        */
        SELECT COUNT(*) as total_publicaciones
            FROM Publicacion as pub 
            WHERE pub.IDU = id_usuario;

        /* Total reacciones dadas*/
        
        SELECT COUNT(r.IDPub) as total_reacciones_dadas
            FROM Reaccionar as r
            WHERE r.IDU = id_usuario 
                AND r.Fecha BETWEEN fecha_inicio AND fecha_fin;

        /* Total reacciones recibidas */

        SELECT COUNT(*) as total_reacciones_recibidas
            FROM Publicacion as p
            JOIN Reaccionar as r
                ON r.IDPub = p.IDPub
            WHERE p.IDU = id_usuario;
        /* 
        Total de comentarios realizados
        A revision mas adelante con futuros cambios en la base de datos
        por ahora se daran los comentarios totales sin periodo de tiempo 
        */
        SELECT COUNT(*) as total_comentarios
            FROM Comentar as c
            WHERE c.IDU = id_usuario;

        /* Total de compras y monto gastado */

        SELECT COUNT(*) as total_compras,
            ROUND(SUM(Cantidad*Precio), 2) as monto_gastado
            FROM Compra as c
            WHERE IDUC = id_usuario
                AND c.Fecha BETWEEN fecha_inicio AND fecha_fin;

        /* Total de contribuciones*/

        SELECT COUNT(*) as total_contribuciones
            FROM Contribucion as c
            WHERE c.IDU = id_usuario
                AND c.Fecha BETWEEN fecha_inicio AND fecha_fin;

        /* Especie mas compra y mas contribuida*/

        SELECT 
            (SELECT e.NombreCientifico
                FROM Contribucion as contr
                JOIN Especie as e
                    ON e.IDProd = contr.IDProd
                WHERE contr.IDU = id_usuario
                    AND contr.Fecha BETWEEN fecha_inicio AND fecha_fin
                GROUP BY e.NombreCientifico
                ORDER BY COUNT(*) DESC
                LIMIT 1
            )  as especie_mas_contribuida,
            (SELECT e.NombreCientifico
                FROM Especie as e
                JOIN Compra as c
                    ON e.IDProd = c.IDProd
                WHERE c.IDUC = id_usuario
                    AND c.Fecha BETWEEN fecha_inicio AND fecha_fin
                GROUP BY e.NombreCientifico
                ORDER BY SUM(c.Cantidad) DESC
                LIMIT 1
            ) as especie_mas_vendida;
    END //

DELIMITER ;