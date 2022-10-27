﻿CREATE TABLE [dbo].[ALTA_CARGA_ROBOT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ARCHIVO] [varbinary](max) NULL,
	[STATUS] [nvarchar](1) NULL,
	[CLIENT] [nvarchar](255) NULL,
	[RFC] [nvarchar](15) NULL,
	[FECHA_CREACION] [nvarchar](255) NULL,
	[HORA_CREACION] [nvarchar](255) NULL,
	[ID_CS] [int] NULL,
 CONSTRAINT [PK_ALTA_CARGA_ROBOT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]