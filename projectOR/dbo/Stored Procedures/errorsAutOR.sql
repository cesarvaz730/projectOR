CREATE PROCEDURE [dbo].[errorsAutOR](
          @msj NVARCHAR(MAX),
          @rfc NVARCHAR(MAX),
		  @noOrder NVARCHAR(MAX)
        ) 
        AS
        BEGIN
          
		  DECLARE @msjErrorCustom NVARCHAR(MAX),@rfcError NVARCHAR(MAX),@id_cs int;

		  set @msjErrorCustom=@msj;
		   set @rfcError=@rfc;

		  if CHARINDEX('FK_CCB_CORTA_IMSS_INTERLOCUTORES1',@msj) > 0
			begin
				--print 'entró al if por contains'
				set @msjErrorCustom='El campo ALMACEN_DESTINO  no exista en la tabla de Interlocutores';
			end

			else if CHARINDEX('FK_CCB_CORTA_IMSS_INTERLOCUTORES',@msj) > 0
			begin
				set @msjErrorCustom='El campo LUGAR_ENTREGA no exista en la tabla de Interlocutores';
			end
			else if CHARINDEX('FK_CCB_CORTA_IMSS_Listado_SC',@msj) > 0
			begin
				set @msjErrorCustom='El Campo RFC no es valido';
				set @rfcError='RPAUSERERROR';
			end
			else if CHARINDEX('FK_CCB_CORTA_INSABI_INTERLOCUTORES_INSABI',@msj) > 0
			begin
				set @msjErrorCustom='El Clue no existe en la tabla de Interlocutores';
			end
			else
			begin
			set @rfcError='RPAUSERERROR';
			end
			--
			
			set @id_cs= (select id_cs from Listado_SC where rfc=@rfcError);

			INSERT INTO [dbo].[Log_errores]
									   ([NO_ORDEN]
									   ,[STATUS]
									   ,[CODIGO_MENSAJE]
									   ,[FECHA_ERROR]
									   ,[HORA_ERROR]
									   ,[PROCESADO]
									   ,[MENSAJE]
									   ,[RFC],ID_CS)
								 VALUES
									   (@noOrder
									   ,'N'
									   ,null
									   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
									   ,(SELECT CONVERT(CHAR(8),GETDATE(),108))
									   ,'N'
									   ,@msjErrorCustom
									   ,@rfcError
									   ,@id_cs
									   );
		
          

		  
        END