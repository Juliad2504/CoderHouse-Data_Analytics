RetailPro – Análisis de ventas con SQL

Proyecto de Data Analytics (CoderHouse) que modela la base de ventas de RetailPro y responde preguntas de negocio con SQL: una vista única que cruza toda la información comercial, un resumen ejecutivo mensual, un ranking de productos y el análisis de clientes y artículos sin movimiento.

Objetivo
El equipo de análisis de RetailPro necesita una vista única del negocio. A partir de ella se responden tres preguntas con JOIN:

Vista base (INNER JOIN): ventas enriquecidas con cliente, ciudad, producto y categoría.
CRM: ¿qué clientes nunca compraron?
Producto: ¿qué artículos del catálogo no tienen movimiento?

Sobre la base cargada se construyeron además cuatro consultas de negocio:

Resumen ejecutivo mensual: total facturado, cantidad de pedidos y ticket promedio por mes.
Ranking de productos: top 5 de id_producto por total facturado, con unidades vendidas.
Clientes recurrentes: clientes que hayan realizado más de un pedido, mostrando la cantidad de pedidos y el total gastado. 
Productos por encima/por debajo del promedio (De los totales por producto).

Estructura del repositorio
Archivo	Contenido
ventas_tech_db.sql	Creación de la base de datos, las tablas y la carga de datos de ejemplo.
m4_consultas_negocio.sql	Consultas de negocio: resumen mensual (facturado, pedidos, ticket promedio) y ranking top 5 de productos.
m5_consultas_joins.sql	Consultas con JOINs: vista base con INNER JOIN y análisis de clientes y productos sin movimiento.
Pipeline_ETL_Dono_Julia.pbix	Archivo de Power BI del pipeline ETL del proyecto.
Modelo de datos

Esquema de tipo estrella, con ventas como tabla de hechos:

categorias ──< productos ──< ventas >── clientes

Este esquema es una forma de organizar una base de datos pensada para analizar datos (reportes, BI, dashboards) y no para registrar operaciones del día a día. Se llama “estrella” porque, dibujado, parece una: una tabla al centro y otras alrededor. Contiene dos piezas fundamentales: 

- Tabla de hechos (el centro). Guarda los eventos o transacciones del negocio, lo que se mide. Tiene dos tipos de columnas:
  Métricas numéricas que se suman o promedian: cantidad, precio_unitario.
   laves foráneas que apuntan a cada dimensión: id_cliente, id_producto.

- Tablas de dimensiones (las puntas). Describen el contexto del hecho, es decir, el quién, el qué, el dónde y el cuándo. Se usan para filtrar, agrupar y segmentar: clientes (nombre, ciudad), productos (nombre, categoría), fechas.


Herramientas utilizadas
SQL (T-SQL) como lenguaje de consulta (TOP, MONTH(), INNER JOIN, LEFT JOIN, agregaciones).
SQL Server Management Studio (SSMS) para ejecutar los scripts y revisar resultados.
Power BI Desktop para abrir el archivo .pbix del pipeline ETL.
Git y GitHub para el control de versiones.

Si usás PostgreSQL, reemplazá MONTH(fecha_venta) por EXTRACT(MONTH FROM fecha_venta) y TOP 5 por LIMIT 5.

Cómo ejecutar los scripts SQL

Requisitos
SQL Server (Express, Developer o similar) y SSMS instalados.
Permisos para crear una base de datos.

Pasos
Cloná el repositorio
bash
   git clone https://github.com/Juliad2504/CoderHouse-Data_Analytics.git
   cd CoderHouse-Data_Analytics
Abrí SSMS y conectate a tu instancia de SQL Server.
Creá y cargá la base de datos: abrí ventas_tech_db.sql y ejecutalo completo (F5). Esto crea las tablas y los datos de ejemplo.
Seleccioná la base recién creada en el desplegable de SSMS (o con USE nombre_de_la_base;).
Ejecutá las consultas en este orden:
m5_consultas_joins.sql: vista base y análisis de clientes y productos sin movimiento.
m4_consultas_negocio.sql: resumen mensual y ranking de productos.
Revisá los resultados en la pestaña Resultados y los avisos en Mensajes.

Podés ejecutar cada consulta por separado seleccionando su bloque y presionando F5.

Abrir el archivo de Power BI

Abrí Pipeline_ETL_Dono_Julia.pbix con Power BI Desktop. Si te pide credenciales, actualizá el origen de datos hacia tu instancia local de SQL Server.

Hallazgos principales
Fechas inconsistentes. Se esperaba que todas las ventas fueran de marzo de 2024, pero aparecen registros en febrero, julio y diciembre (ventas 9, 6 y 2), que rompen la secuencia diaria de carga y parecen errores. Corregidos, marzo concentraría $6.092 en 10 tickets y el ticket promedio bajaría de $829 a $609.
Valor y volumen no coinciden. El producto 1 genera cerca del 59% de la facturación con solo 3 unidades, mientras que el producto 2 lidera en unidades (14) pero aporta apenas el 6% de los ingresos.
Ingresos concentrados en pocos clientes. Los clientes 1 y 3 explican alrededor del 89% de lo facturado.

La muestra es chica (10 ventas, 4 clientes y 5 productos): sirve para detectar patrones, no para proyectar.

Mejoras sugeridas
Convertir la vista base en CREATE VIEW e incluir identificadores (id_venta, id_cliente, id_producto).
Usar LEFT JOIN hacia categorias para no perder ventas de productos sin categoría.
Agregar índices en las claves de unión y en ventas(fecha_venta).
Validar fechas en la carga con una restricción CHECK.
Renombrar total_cantidad_pedidos a unidades_vendidas, porque suma unidades y no pedidos.

Autora
Julia Doño: proyecto del módulo 4 y 5, Data Analytics en CoderHouse.
