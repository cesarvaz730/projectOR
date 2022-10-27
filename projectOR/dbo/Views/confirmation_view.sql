CREATE VIEW [dbo].[confirmation_view]  
AS 
SELECT a.no_orden,cp.delivery, cantidad = 
    STUFF((SELECT ', ' + cantidad
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden and LOTE is not null
          FOR XML PATH('')), 1, 2, '')
		   ,lote = 
    STUFF((SELECT ', ' + lote
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden and LOTE is not null
          FOR XML PATH('')), 1, 2, '')
		  ,fecha_cad = 
    STUFF((SELECT ', ' + fecha_cad
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden and LOTE is not null
          FOR XML PATH('')), 1, 2, '')
		  ,fecha_fab = 
    STUFF((SELECT ', ' + fecha_fab
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden and LOTE is not null
          FOR XML PATH('')), 1, 2, '')
		  ,marca = 
    STUFF((SELECT ', ' + marca
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden and LOTE is not null
          FOR XML PATH('')), 1, 2, '')
		  ,fecha_limite = 
    STUFF((SELECT ', ' + fecha_limite
           FROM CONSULTA_POS b 
           WHERE b.no_orden = a.no_orden and LOTE is not null
          FOR XML PATH('')), 1, 2, '')
		  ,a.rfc
FROM CCB_Consulta   a,CONSULTA_POS cp, Listado_SC lsc
where a.NO_ORDEN=cp.NO_ORDEN and a.ID_CS=lsc.ID_CS and lsc.CLIENTE='IMSS'
and a.DELIVERY is not null
GROUP BY a.no_orden,cp.delivery,a.rfc