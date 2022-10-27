CREATE TABLE [dbo].[CCB_Consulta](
	[NO_ORDEN] [nvarchar](40) NOT NULL,
	[PEDIDO_SAP] [nvarchar](10) NOT NULL,
	[CLIENTE_FACTURA] [nvarchar](30) NULL,
	[FECHA_INSERCION] [nvarchar](10) NULL,
	[HORA_CREACION] [nvarchar](10) NULL,
	[DELIVERY] [nvarchar](10) NULL,
	[FECHA_DELIVERY] [nvarchar](10) NULL,
	[HORA_DELIVERY] [nvarchar](10) NULL,
	[STATUS] [nvarchar](20) NULL,
	[RFC] [nvarchar](16) NULL,
	[PROCESADO] [nvarchar](1) NULL,
	[ID] [uniqueidentifier] NOT NULL,
	[CLIENTE_DESTINO] [nvarchar](10) NULL,
	[DESCRIPCION_DESTINO] [nvarchar](160) NULL,
	[ENTIDAD_FEDERATIVA] [nvarchar](20) NULL,
	[DESCRIPCION_MATERIAL] [nvarchar](40) NULL,
	[ID_CS] [int] NULL,
 CONSTRAINT [PK_CCB_Consulta] PRIMARY KEY CLUSTERED 
(
	[NO_ORDEN] ASC,
	[PEDIDO_SAP] ASC,
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CCB_Consulta] ADD  CONSTRAINT [DF_CCB_Consulta_ID]  DEFAULT (newid()) FOR [ID]
GO
CREATE TRIGGER [dbo].[triggerIDCS]
ON [dbo].[CCB_Consulta]
AFTER INSERT   
AS 
Begin

DECLARE @orden nvarchar(max);

            SELECT @orden=i.no_orden FROM inserted i; 
EXECUTE [dbo].[updateIDCSAutOR] @orden ; 

end
GO

ALTER TABLE [dbo].[CCB_Consulta] ENABLE TRIGGER [triggerIDCS]