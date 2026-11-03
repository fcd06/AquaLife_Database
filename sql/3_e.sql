SELECT IDUV, SUM(Cantidad) AS Productos_Vendidos,
    ROUND(AVG(Puntuacion),2) AS Puntuacion_Promedio,
    Nombre, Email, DireccionParticular
    FROM Compra 
    JOIN Usuario as U
        ON U.IDU = IDUV
    GROUP BY IDUV 
    ORDER BY Puntuacion_Promedio DESC, Productos_Vendidos DESC
    LIMIT 5;