CREATE VIEW [dbo].[confirmation_insabi_view]  
AS 
SELECT no_orden,delivery, cantidad = 
    STUFF((SELECT ', ' + cantidad
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		   ,lote = 
    STUFF((SELECT ', ' + lote
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		   ,CCB = 
    STUFF((SELECT ', ' + CCB
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,fecha_cad = 
    STUFF((SELECT ', ' + fecha_cad
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,fecha_fab = 
    STUFF((SELECT ', ' + fecha_fab
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,marca = 
    STUFF((SELECT ', ' + marca
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		   ,procedencia = 
    STUFF((SELECT ', ' + procedencia
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,fecha_limite = 
    STUFF((SELECT ', ' + fecha_limite
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,codigo_barras = 
    STUFF((SELECT ', ' + cb
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,alto = 
    STUFF((SELECT ', ' + alto
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,Ancho = 
    STUFF((SELECT ', ' + Ancho
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,profundidad = 
    STUFF((SELECT ', ' + profundidad
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,unidad_envase = 
    STUFF((SELECT ', ' + un_envase
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,bultos = 
    STUFF((SELECT ', ' + bultos
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  ,a.rfc
		  ,numero_remision = 
    STUFF((SELECT ', ' + NUM_REMISI
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden 
          FOR XML PATH('')), 1, 2, '')
		  
FROM CCB_Consulta a, Listado_SC lsc
where a.ID_CS=lsc.ID_CS and lsc.CLIENTE='INSABI'
GROUP BY no_orden,delivery,a.rfc