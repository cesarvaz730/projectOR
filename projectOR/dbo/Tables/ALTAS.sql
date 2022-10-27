﻿CREATE TABLE [dbo].[ALTAS](
	[ALTA] [nvarchar](18) NULL,
	[FECHA] [nvarchar](10) NULL,
	[NO_CONTRATO] [nvarchar](40) NULL,
	[NO_ORDEN] [nvarchar](40) NULL,
	[PEDIDO_SAP] [nvarchar](10) NULL,
	[CCB] [nvarchar](35) NULL,
	[CANTIDAD] [nvarchar](17) NULL,
	[IMPORTE] [nvarchar](17) NULL,
	[FPP] [nvarchar](10) NULL,
	[UN_REC] [nvarchar](15) NULL,
	[DES_UNIDAD] [nvarchar](255) NULL,
	[RFC] [nvarchar](16) NULL,
	[clasPtalDist] [nvarchar](15) NULL,
	[descDist] [nvarchar](40) NULL,
	[totalItems] [int] NULL,
	[resguardo] [nvarchar](100) NULL,
	[STATUS] [nvarchar](20) NULL,
	[PROCESADO] [nvarchar](1) NULL,
	[ID_CS] [int] NULL
) ON [PRIMARY]