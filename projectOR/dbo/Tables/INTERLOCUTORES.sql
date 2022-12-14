CREATE TABLE [dbo].[INTERLOCUTORES](
	[LUGAR_ENTREGA] [nvarchar](15) NOT NULL,
	[CLIENTE_DESTINO] [nvarchar](10) NULL,
 CONSTRAINT [PK_INTERLOCUTORES] PRIMARY KEY CLUSTERED 
(
	[LUGAR_ENTREGA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]