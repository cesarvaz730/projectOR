CREATE PROCEDURE [dbo].[validateFields](
          @rfc NVARCHAR(MAX),
		  @NO_ORDEN NVARCHAR(MAX),
		  @NO_CONTRATO NVARCHAR(MAX),
		  @NO_SOLICITUD NVARCHAR(MAX),
		  @FECHA_EMISION NVARCHAR(MAX),
		  @LUGAR_ENTREGA NVARCHAR(MAX),
		  @CCB NVARCHAR(MAX),
		  @CANTIDAD NVARCHAR(MAX),
		  @FECHA_ENTREGA NVARCHAR(MAX),
		  @PRECIO NVARCHAR(MAX)
        ) 
        AS
		 DECLARE @msjErrorCustom  NVARCHAR(MAX), @rfcError NVARCHAR(MAX);
        BEGIN
          /*
		  o	NO_ORDEN
o	NO_CONTRATO
o	NO_SOLICITUD
o	FECHA_EMISION
o	LUGAR_ENTREGA
o	CCB
o	CANTIDAD
o	FECHA_ENTREGA
o	RFC
o	PRECIO

		  */
		 

		  
		  set @rfcError=@rfc;

		  if @rfc='' or @rfc is  null
			begin
				--print 'entró al if por contains'
				set @msjErrorCustom='El rfc no puede ir vacío';
				set @rfcError='RPAUSERERROR';
			end

		  else if @NO_ORDEN='' or @NO_ORDEN is  null
			begin
				--print 'entró al if por contains'
				set @msjErrorCustom='El número de orden no puede ir vacío';
			end
			else if @NO_CONTRATO='' or @NO_CONTRATO is  null
			begin
				set @msjErrorCustom='El número de contrato no puede ir vacío';
			end
			else if @NO_SOLICITUD='' or @NO_SOLICITUD is  null
			begin
				set @msjErrorCustom='El número de solicitud no puede ir vacío';
				
			end
			else if @FECHA_EMISION='' or @FECHA_EMISION is  null
			begin
				set @msjErrorCustom='La fecha emisión no puede ir vacío';
			end
			else if @LUGAR_ENTREGA='' or @LUGAR_ENTREGA is  null
			begin
				set @msjErrorCustom='El lugar entrega no puede ir vacío';
			end
			else if @CCB='' or @CCB is  null
			begin
				set @msjErrorCustom='El CCB no puede ir vacío';
			end
			else if @CANTIDAD='' or @CANTIDAD is  null
			begin
				set @msjErrorCustom='La cantidad no puede ir vacío';
			end
			else if @FECHA_ENTREGA='' or @FECHA_ENTREGA is  null
			begin
				set @msjErrorCustom='La fecha entrega no puede ir vacío';
			end
			else if @PRECIO='' or @PRECIO is  null
			begin
				set @msjErrorCustom='El precio no puede ir vacío';
			end
			
			if @msjErrorCustom is not null
			begin

			INSERT INTO [dbo].[Log_errores]
									   ([NO_ORDEN]
									   ,[STATUS]
									   ,[CODIGO_MENSAJE]
									   ,[FECHA_ERROR]
									   ,[HORA_ERROR]
									   ,[PROCESADO]
									   ,[MENSAJE]
									   ,[RFC])
								 VALUES
									   (@NO_ORDEN
									   ,'N'
									   ,null
									   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
									   ,(SELECT CONVERT(CHAR(8),GETDATE(),108))
									   ,'N'
									   ,@msjErrorCustom
									   ,@rfcError
									   );

									   end
		
          

		  
        END