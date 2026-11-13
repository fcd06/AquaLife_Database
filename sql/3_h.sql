WITH influencers as (
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
        LIMIT 5),
especies as (
    SELECT IDU, 
            NombreCientifico,
            interacciones,
            puntaje_ponderado
        FROM (
            SELECT 
                IDU,
                NombreCientifico,
                interacciones,
                puntaje_ponderado,
                ROW_NUMBER() OVER (
                    PARTITION BY IDU
                    ORDER BY interacciones DESC, NombreCientifico
                ) as rn
            FROM(
                SELECT 
                    universo.IDU, 
                    universo.NombreCientifico,
                    IFNULL(contr.interacciones,0) + IFNULL(compra.interacciones,0) as interacciones,
                    i.puntaje_ponderado
                FROM (
                    SELECT IDUC as IDU, e.NombreCientifico
                        FROM Compra as c
                        JOIN Especie as e ON c.IDProd = e.IDProd
                        JOIN influencers as i ON i.IDU = IDUC
                        GROUP BY IDUC, e.NombreCientifico
                    UNION
                    SELECT c.IDU, e.NombreCientifico
                        FROM Contribucion as c
                        JOIN Especie as e ON c.IDProd = e.IDProd
                        JOIN influencers as i ON i.IDU = c.IDU
                        GROUP BY c.IDU, e.NombreCientifico
                ) as universo
                LEFT JOIN (
                    SELECT contr.IDU, e.NombreCientifico, COUNT(*) as interacciones
                        FROM Contribucion as contr
                        JOIN Especie as e ON e.IDProd = contr.IDProd
                        JOIN influencers as i ON i.IDU = contr.IDU
                        GROUP BY contr.IDU, e.NombreCientifico
                ) as contr
                    ON  contr.IDU = universo.IDU 
                    AND contr.NombreCientifico = universo.NombreCientifico
                LEFT JOIN (
                    SELECT IDUC, e.NombreCientifico, COUNT(*) as interacciones
                        FROM Compra as com
                        JOIN Especie as e ON e.IDProd = com.IDProd
                        JOIN influencers as i ON i.IDU = IDUC
                        GROUP BY IDUC, e.NombreCientifico
                    ) as compra
                    ON compra.IDUC = universo.IDU
                        AND  compra.NombreCientifico = universo.NombreCientifico
                JOIN influencers as i ON i.IDU = universo.IDU
                ) as table1
            ) as table2
        WHERE rn <= 3
), 
eventos as (
    SELECT IDU, DATE(Fecha) as Fecha
    FROM (
        SELECT p.IDU, p.FechaCreacion as Fecha
            FROM Publicacion as p
            JOIN influencers as i ON i.IDU = p.IDU
        UNION
        SELECT c.IDU, Fecha
            FROM Contribucion as c
            JOIN influencers as i ON i.IDU = c.IDU
    ) as universo 
),
ventas as (
    SELECT e.NombreCientifico, c.Fecha, SUM(c.Cantidad) as cantidad_ventas
        FROM Especie as e
        JOIN Compra as c ON c.IDProd = e.IDProd
        WHERE e.NombreCientifico IN (SELECT NombreCientifico FROM especies)
        GROUP BY e.NombreCientifico, c.Fecha
),
ventas_evento as (
    SELECT ev.IDU,
        es.NombreCientifico,
        ev.Fecha,
        IFNULL(SUM(
            CASE WHEN v.Fecha BETWEEN ev.Fecha - INTERVAL 14 DAY 
                AND ev.Fecha - INTERVAL 1 DAY 
                THEN v.cantidad_ventas ELSE 0
            END), 0) as ventas_antes,
        IFNULL(SUM(
            CASE WHEN v.Fecha BETWEEN ev.Fecha + INTERVAL 1 DAY 
                AND  ev.Fecha + INTERVAL 14 DAY
                THEN v.cantidad_ventas ELSE 0
            END), 0) as ventas_despues
        FROM eventos as ev
        JOIN especies as es ON ev.IDU = es.IDU
        LEFT JOIN ventas as v
            ON v.Fecha BETWEEN ev.Fecha - INTERVAL 14 DAY
                AND ev.Fecha + INTERVAL 14 DAY
            AND v.NombreCientifico = es.NombreCientifico
        GROUP BY ev.IDU, es.NombreCientifico, ev.Fecha
),
incremento as (
    SELECT ve.IDU, ve.NombreCientifico,
        AVG(CASE WHEN ve.ventas_antes > 0
                THEN (ve.ventas_despues - ve.ventas_antes)/(ve.ventas_antes) * 100
            END) as incremento_porcentual
        FROM ventas_evento as ve 
        GROUP BY ve.IDU, ve.NombreCientifico
),
usuario_reacciona as (
    SELECT DISTINCT u.IDU, i.IDU as IDUI, DATE(r.Fecha) as Fecha
        FROM Usuario as u
        JOIN Reaccionar as r ON r.IDU = u.IDU
        JOIN Publicacion as p ON p.IDPub = r.IDPub
        JOIN influencers as i ON i.IDU = p.IDU
),
usuario_compra as (
    SELECT DISTINCT u.IDU, esp.IDU as IDUI, DATE(c.Fecha) as Fecha
        FROM Usuario as u
        JOIN Compra as c ON c.IDUC = u.IDU
        JOIN Especie as e ON c.IDProd = e.IDProd
        JOIN especies as esp ON esp.NombreCientifico = e.NombreCientifico
),
porcentaje_conversion as (
    SELECT ur.IDUI,
        COUNT(DISTINCT CASE WHEN uc.IDU IS NOT NULL THEN ur.IDU END) * 100.0 
        / COUNT(DISTINCT ur.IDU) as porcentaje_conversos
    FROM usuario_reacciona as ur
    LEFT JOIN usuario_compra as uc
        ON uc.IDU = ur.IDU
        AND uc.IDUI = ur.IDUI 
        AND uc.Fecha BETWEEN ur.Fecha AND ur.Fecha + INTERVAL 14 DAY
    GROUP BY ur.IDUI
)
SELECT i.IDU, 
    i.puntaje_ponderado, 
    e.NombreCientifico, 
    e.interacciones,
    ROUND(inc.incremento_porcentual, 2) as incremento_porcentual, 
    ROUND(pc.porcentaje_conversos, 2) as porcentaje_conversos
    FROM influencers as i
    JOIN especies as e
        ON e.IDU = i.IDU
    LEFT JOIN incremento as inc
        ON inc.IDU = i.IDU 
        AND inc.NombreCientifico = e.NombreCientifico
    LEFT JOIN porcentaje_conversion as pc
        ON pc.IDUI = i.IDU
    ORDER BY i.IDU, e.interacciones DESC;