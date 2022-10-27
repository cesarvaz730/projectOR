﻿CREATE TABLE [dbo].[CCB_CORTA_INSABI](
	[NO_ORDEN] [nvarchar](40) NOT NULL,
	[NO_CONTRATO] [nvarchar](40) NULL,
	[ALMACEN_ENTREGA] [varchar](150) NULL,
	[DIRECCION_ALMACEN] [varchar](150) NULL,
	[CLUES] [nvarchar](150) NULL,
	[ENTIDAD_FEDERATIVA] [nvarchar](20) NULL,
	[PROCEDIMIENTO] [nvarchar](25) NULL,
	[FIANZA] [nvarchar](25) NULL,
	[PARTIDA_PRESUPUESTAL] [nvarchar](7) NULL,
	[CLUE] [nvarchar](60) NULL,
	[PROCESADO] [nvarchar](2) NULL,
	[RFC] [nvarchar](16) NULL,
	[FECHA_ENTREGA] [nvarchar](10) NULL,
	[FECHA_EMISION] [nvarchar](10) NULL,
	[CLIENTE] [nvarchar](255) NULL,
	[ID_CS] [int] NULL,
 CONSTRAINT [PK_OR_CCB_CORTA_INSABI] PRIMARY KEY CLUSTERED 
(
	[NO_ORDEN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CCB_CORTA_INSABI]  WITH CHECK ADD  CONSTRAINT [FK_CCB_CORTA_INSABI_INTERLOCUTORES_INSABI] FOREIGN KEY([CLUE])
REFERENCES [dbo].[INTERLOCUTORES_INSABI] ([CLUE])
GO

ALTER TABLE [dbo].[CCB_CORTA_INSABI] CHECK CONSTRAINT [FK_CCB_CORTA_INSABI_INTERLOCUTORES_INSABI]
GO
ALTER TABLE [dbo].[CCB_CORTA_INSABI] ADD  CONSTRAINT [DF_CCB_CORTA_INSABI_PROCESADO]  DEFAULT ('N') FOR [PROCESADO]