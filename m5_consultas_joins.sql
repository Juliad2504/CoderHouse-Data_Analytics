USE Ventas_Tech_DB;

--Realizo la primera consulta con la union de las tablas y columnas solicitadas

SELECT 
    v.fecha_venta,
    c.nombre AS cliente,
    c.ciudad,                          -- Agrego una columna descriptiva, en este caso segmenta la zona
    cat.nombre_categoria AS categoria, -- Añado otra columa descriptiva, en este caso del producto, diferenciando por categoria
    p.nombre_producto,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v                       -- Se "renombra" cada una de las tablas a utilizar para facil manipulación 
INNER JOIN clientes AS c 
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p 
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat 
    ON p.id_categoria = cat.id_categoria;

--Consulta 2: LEFT JOIN. En este caso solo mostrará los clientes que no hayan hecho compras, ya que se filtra por el "WHERE" donde si no hay asociado un id de venta al cliente, resultamos en un valor NULL

SELECT 
    c.nombre AS cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

--Consulta 3: RIGHT JOIN. El mismo criterio que la consulta 2, pero con los productos que no se hayan vendido todavía.

SELECT 
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat 
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v 
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

--Consulta 4. Para esta consulta, tomé la selección por periodo (se utiliza la denominación de "canal" por lo solicitado en el ejercicio, aunque podría denominarse "periodo".
-- Esta decision se toma en base de que el planteo base es la reducción de ventas comparados por semestre. 

SELECT 
    canal, --periodo
    SUM(total) AS total_canal --total_periodo
FROM (
    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Primer Semestre' AS canal --periodo
    FROM ventas 
    WHERE MONTH(fecha_venta) BETWEEN 1 AND 6

    UNION ALL

    SELECT 
        fecha_venta, 
        (cantidad * precio_unitario) AS total, 
        'Segundo Semestre' AS canal --periodo
    FROM ventas 
    WHERE MONTH(fecha_venta) BETWEEN 7 AND 12
) AS consolidado
GROUP BY canal; --periodo

--ACLARACIÓN
-- Para evaluar las consultas 2, 3 y 4 modifiqué los datos de las tablas de la entrega M3, ya que de no hacerlo, todos los clientes compraron y todos los productos se vendieron. Además, como todas las ventas se habían realizado en marzo, por lo cual no se podían testear las consultas.