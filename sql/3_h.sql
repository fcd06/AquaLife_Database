/*

    1) puntaje de interaccion ponderado
        Me gusta=1, 
        Me encanta=2, 
        Me asombra=1,5, 
        comentarios=2
    
    Por cada usuario ver sus publicaciones y contar para todas las 
    publicaciones su puntaje ponderado es decir reacciones + cometarios
*/
SELECT u.IDU, SUM(puntaje.puntaje) as puntaje_ponderado
    FROM Usuario as u
    JOIN Publicacion as p
        ON p.IDU = u.IDU
    LEFT JOIN (
        SELECT p.IDPub, 
            puntaje_comentario.puntaje + puntaje_reaccion.puntaje as puntaje
            FROM Publicacion as p
            LEFT JOIN (SELECT p.IDPub,
                    SUM(CASE 
                            WHEN r.Tipo = 'Me gusta' THEN 1
                            WHEN r.Tipo = 'Me encanta' THEN 2
                            WHEN r.Tipo = 'Me asombra' THEN 1.5
                            ELSE 0
                    END) as puntaje
                    FROM Publicacion as p
                    JOIN Reaccionar as r
                        ON r.IDPub = p.IDPub
                    GROUP BY p.IDPub) as puntaje_reaccion
                ON puntaje_reaccion.IDPub = p.IDPub
            LEFT JOIN (SELECT p.IDPub, COUNT(c.IDComentario)*2 as puntaje
                    FROM Publicacion as p
                    LEFT JOIN Comentar as c
                        ON c.IDPub = p.IDPub
                    GROUP BY p.IDPub) as puntaje_comentario
                ON puntaje_comentario.IDPub = p.IDPub
        ) as puntaje
        ON p.IDPub = puntaje.IDPub
    GROUP BY u.IDU
    ORDER BY puntaje_ponderado DESC
    LIMIT 5;
/*
    2) de los 5 usuarios influencers sacar :
    Las especies con las que mas ha interactuado (publicaciones, contribuciones, compras);
    lo siguiente devuelve la cantidad de interacciones que ha hecho cada usuario a cada especie
*/

SELECT universo.IDU, universo.NombreCientifico,
        IFNULL(compra.interacciones, 0) + IFNULL(contr.interacciones, 0)
    FROM (
        SELECT IDUC as IDU, e.NombreCientifico
            FROM Compra as c
            JOIN Especie as e
                ON c.IDProd = e.IDProd
            GROUP BY IDUC, e.NombreCientifico
            UNION
            SELECT c.IDU, e.NombreCientifico
                FROM Contribucion as c
                JOIN Especie as e
                    ON c.IDProd = e.IDProd
                GROUP BY c.IDU, e.NombreCientifico
    ) as universo
    LEFT JOIN (
        SELECT contr.IDU, e.NombreCientifico, COUNT(*) as interacciones
            FROM Contribucion as contr
            JOIN Especie as e
                ON e.IDProd = contr.IDProd
            GROUP BY contr.IDU, e.NombreCientifico
    ) as contr
        ON  contr.IDU = universo.IDU 
        AND contr.NombreCientifico = universo.NombreCientifico
    LEFT JOIN (
        SELECT IDUC, e.NombreCientifico, COUNT(*) as interacciones
            FROM Compra as com
            JOIN Especie as e
                ON e.IDProd = com.IDProd
            GROUP BY IDUC, e.NombreCientifico
        ) as compra
        ON compra.IDUC = universo.IDU
            AND  compra.NombreCientifico = universo.NombreCientifico;