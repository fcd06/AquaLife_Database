SELECT pb.IDPub, Texto, pb.IDU, pb.IDV,
    COUNT(r.IDPub) as Cantidad_Reacciones,
    SUM(CASE 
        WHEN r.Tipo IN ('Me gusta', 'Me asombra', 'Me encanta', 'Me divierte')
        THEN 1 ELSE 0 
    END) as Reacciones_positivas,
    SUM(CASE
        WHEN r.Tipo IN ('Me enoja', 'Me entristece')
        THEN 1 ELSE 0
    END) as Reacciones_negativas
    FROM Publicacion as pb
    LEFT JOIN Reaccionar as r
        ON r.IDPub = pb.IDPub
    GROUP BY pb.IDPub
    HAVING
    (SUM(CASE 
        WHEN r.Tipo IN ('Me gusta', 'Me asombra', 'Me encanta', 'Me divierte')
        THEN 1 ELSE 0 
    END) > SUM(CASE
        WHEN r.Tipo IN ('Me enoja', 'Me entristece')
        THEN 1 ELSE 0
    END));