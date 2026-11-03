CREATE TABLE Historial_Precios(
    IDHistorial INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    IDProd INT NOT NULL,
    PrecioAnterior DECIMAL(10, 2) NOT NULL,
    PrecioNuevo DECIMAL(10, 2) NOT NULL,
    FechaHora DATETIME DEFAULT CURRENT_TIMESTAMP,
    NombreUsuario VARCHAR(20),
    PorcentajeCambio DECIMAL(10, 2) ,
    FOREIGN KEY (IDProd) REFERENCES Producto(IDProd)
);