SELECT IDTA, NombreCientifico, Categoria, Cantidad_Especimenes
    FROM (SELECT ta.IDTA, e.NombreCientifico, e.Categoria,
            COUNT(c.IDProd) as Cantidad_Especimenes
            FROM TipoAgua as ta
            RIGHT JOIN Especie as e
                ON e.IDTA = ta.IDTA
            RIGHT JOIN Contribucion as c
                ON c.IDProd = e.IDProd
            GROUP BY ta.IDTA, e.NombreCientifico, e.Categoria
            ORDER BY ta.IDTA ,COUNT(c.IDProd) DESC
        ) as table1
    WHERE (IDTA, Cantidad_Especimenes) IN (
        SELECT IDTA, MAX(Cantidad_Especimenes) as Cantidad_Especimenes
            FROM (SELECT ta.IDTA, COUNT(c.IDProd) as Cantidad_Especimenes
                FROM TipoAgua as ta
                RIGHT JOIN Especie as e
                    ON e.IDTA = ta.IDTA
                RIGHT JOIN Contribucion as c
                    ON c.IDProd = e.IDProd
                GROUP BY ta.IDTA, e.NombreCientifico, e.Categoria
                ORDER BY ta.IDTA ,COUNT(c.IDProd) DESC) as table2
            GROUP BY IDTA
    );