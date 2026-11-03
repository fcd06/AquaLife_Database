-- Como varian las contribuciones de acuerdo al tipo de agua
-- Por cada tipo de agua identificar la especie y la categoria mas popular
-- Es decir la especie que mas publicaciones tiene por cada tipo de agua
-- acompañando a la especie su categoria

-- Por hacer

SELECT ta.IDTA, e.NombreCientifico, e.Categoria,
    COUNT(c.IDProd) as Cantidad_Especimenes
    FROM TipoAgua as ta
    RIGHT JOIN Especie as e
        ON e.IDTA = ta.IDTA
    RIGHT JOIN Contribucion as c
        ON c.IDProd = e.IDProd
    GROUP BY ta.IDTA, e.NombreCientifico, e.Categoria
    ORDER BY ta.IDTA ,COUNT(c.IDProd) DESC;