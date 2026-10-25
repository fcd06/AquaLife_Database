SELECT pb.IDPub, Texto, pb.IDU, IDV,
    COUNT(r.IDPub) as Cantidad_Reacciones,
    u.Nombre, u.Email,
    u.DireccionParticular, u.FechaDeNacimiento,
    u.ConfiguracionDePrivacidad
    FROM Publicacion as pb
    LEFT JOIN Reaccionar as r
        ON r.IDPub = pb.IDPub
    LEFT JOIN Usuario AS u
        ON pb.IDU = u.IDU
    GROUP BY pb.IDPub;
