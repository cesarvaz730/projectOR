-- =============================================
-- Author:		Cesar
-- Create date: 01/07/2022
-- Description:	Process to generate orders
-- =============================================
CREATE PROCEDURE [dbo].[ProcedureOrdersv2] 
	
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @cliente NVARCHAR(MAX), @archivo NVARCHAR(MAX), @registro NVARCHAR(MAX), @campos NVARCHAR(MAX),@counter int,@idFile int,
	@existReg int,@isDuplicade int,@isDuplicadePosicion int, @rfc NVARCHAR(MAX),@almacenDestino NVARCHAR(MAX),@suministroValidRFC int,@suministroValidCCB int,@idRfc int,
	@almacenEntregaInsabi NVARCHAR(MAX),@clue NVARCHAR(MAX),@cluesCursor  NVARCHAR(MAX) , @cancelada NVARCHAR(MAX);
	declare @ordersTable table
	(
	id int,
	valor nvarchar(max)
	);
	

    DECLARE db_cursor_orders CURSOR FOR 
	SELECT A.ID_CS,A.RFC,A.ID, A.CLIENT,
    CONVERT
    (
        VARCHAR(MAX), 
        CAST('' AS XML).value('xs:base64Binary(sql:column("BASE64_COLUMN"))', 'VARBINARY(MAX)')
    ) AS RESULT
	FROM
    (
       SELECT CAST(archivo AS VARCHAR(MAX)) AS BASE64_COLUMN,CLIENT,ID,RFC,ID_CS FROM CARGA_ROBOT WHERE STATUS IS NULL
    ) A;
	OPEN db_cursor_orders  
	FETCH NEXT FROM db_cursor_orders   
	INTO @idRfc,@rfc,@idFile,@cliente, @archivo 
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
        
		--PRINT  @rfc+'-'+@cliente +'-'+   @archivo;
		PRINT  @archivo;
		set @archivo=REPLACE(@archivo,'&','&amp;')
		PRINT  @archivo;
		DECLARE registro_cursor CURSOR FOR
		Select Key_Value  from [dbo].[split](@archivo,'|')
		
		OPEN registro_cursor  
		FETCH NEXT FROM registro_cursor INTO @registro;
		--PRINT @registro ;
		FETCH NEXT FROM registro_cursor INTO @registro;
		
		WHILE @@FETCH_STATUS = 0  
		BEGIN    
         
			PRINT @registro ;
			set @registro=REPLACE(@registro,'&','&amp;');
			PRINT @registro ;
			--RECORRER CAMPOS
			DECLARE campos_cursor CURSOR FOR
				Select Key_Value  from [dbo].[split](@registro,'##')
				
				OPEN campos_cursor  
				FETCH NEXT FROM campos_cursor INTO @campos
				select @counter=1;
				WHILE @@FETCH_STATUS = 0  
				BEGIN    
         
					PRINT  @campos;
					insert into @ordersTable select   @counter , @campos;
					select @counter=@counter+1;

				FETCH NEXT FROM campos_cursor INTO @campos
			 END  
			 
			 PRINT 'El cliente es:'+@cliente;
			 
			 IF (@counter > 2 and @cliente='IMSS')
				BEGIN try
					--primero haz update
					-- Update the row if it exists.
					PRINT 'TIENE MINIMO UN REGISTRO';
					set @existReg = (select count(*) from [dbo].[CCB_CORTA_IMSS]  where [NO_ORDEN] = (select valor from @ordersTable where id=3));
					set @almacenDestino=(select valor from @ordersTable where id=10);
					if @almacenDestino='null'
					begin
					PRINT 'ALAMCEN DESTINO NULL'
					set @almacenDestino=null;
					end
					set @cancelada=(select valor from @ordersTable where id=11);
					IF @cancelada='Cancelada'
					BEGIN
						--inserta cancelada
						INSERT INTO [dbo].[Log_errores]
									   ([NO_ORDEN]
									   ,[STATUS]
									   ,[CODIGO_MENSAJE]
									   ,[FECHA_ERROR]
									   ,[HORA_ERROR]
									   ,[PROCESADO]
									   ,[MENSAJE]
									   ,[RFC]
									   ,ID_CS)
								 VALUES
									   ((select valor from @ordersTable where id=3)
									   ,'N'
									   ,null
									   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
									   ,(SELECT CONVERT(CHAR(8),GETDATE(),108))
									   ,'N'
									   ,'La orden '+(select valor from @ordersTable where id=3)+ ' Se ha cancelado'
									   ,@rfc
									   ,@idRfc);

					END
						--UPDATE [dbo].[CCB_Corta]  
						--SET NO_CONTRATO = (select valor from @ordersTable where id=1)  
						--WHERE [NO_ORDEN] = (select valor from @ordersTable where id=3)
					-- Insert the row if the UPDATE statement failed.  
					ELSE IF (@existReg <= 0 )  
						BEGIN 
							
							---Valida Clave de suministro
							set @suministroValidRFC = (select count(*) from [dbo].[CCB_Suministro]  where RFC=@rfc);
							set @suministroValidCCB=  (select count(*) from [dbo].[CCB_Suministro]  where RFC=@rfc and [CCB] = (select valor from @ordersTable where id=5)
							 and cliente=@cliente);

							 IF @suministroValidRFC=0 or(@suministroValidRFC>=1 and @suministroValidCCB>=1 )
								BEGIN
									
										 --Insertar en tabla corta PARA IMSS
										INSERT INTO [dbo].[CCB_CORTA_IMSS]
									   ([NO_CONTRATO],[NO_SOLICITUD],[NO_ORDEN],[FECHA_EMISION],[LUGAR_ENTREGA],[ESTATUS_CLIENTE],[FECHA_ENTREGA],[RFC],[FECHA_INSERCION]
									   ,[HORA_INSERCION],[ALMACEN_DESTINO],[ID_CS]
									   )
										VALUES
									   ((select valor from @ordersTable where id=1) ,
									   (select valor from @ordersTable where id=2),
									   (select valor from @ordersTable where id=3),
									   (select valor from @ordersTable where id=6),
									   (select valor from @ordersTable where id=7),
										(select valor from @ordersTable where id=11),
										(select valor from @ordersTable where id=12),
										@rfc,
										(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1)),
										(SELECT CONVERT(CHAR(8),GETDATE(),108)),
										@almacenDestino,
										@idRfc
									   ); 
						   
									   --corta POSICION
									   INSERT INTO [dbo].[CCB_CORTA_POSICION]
									   ([NO_ORDEN]
									   ,[CCB]
									   ,[CANTIDAD]
									   ,[PRECIO],[FECHA_INSERCION],[HORA_INSERCION]
									   )
										 VALUES
									   ((select valor from @ordersTable where id=3)
									   ,(select valor from @ordersTable where id=5)
									   ,(select valor from @ordersTable where id=13)
									   ,(select valor from @ordersTable where id=14)
									   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
									   , (SELECT CONVERT(CHAR(8),GETDATE(),108))
									  );
									select * from @ordersTable;
								  
								  PRINT 'SE INSERTÓ ORDEN IMSS';
								END
							 ELSE IF (@suministroValidRFC>=1 and @suministroValidCCB=0 )
								BEGIN 
									INSERT INTO [dbo].[Log_errores]
									   ([NO_ORDEN]
									   ,[STATUS]
									   ,[CODIGO_MENSAJE]
									   ,[FECHA_ERROR]
									   ,[HORA_ERROR]
									   ,[PROCESADO]
									   ,[MENSAJE]
									   ,[RFC]
									   ,ID_CS)
								 VALUES
									   ((select valor from @ordersTable where id=3)
									   ,'N'
									   ,null
									   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
									   ,(SELECT CONVERT(CHAR(8),GETDATE(),108))
									   ,'N'
									   ,'La orden '+(select valor from @ordersTable where id=3)+ ' NO Suministra MAYPO'
									   ,@rfc
									   ,@idRfc);
								END
							
						END 
					ELSE
						BEGIN
								PRINT 'ELEMENTO Ya existe:';
								PRINT @almacenDestino;
								select * from @ordersTable;
								set @isDuplicade=0;
								set @isDuplicade = (select count(*) from [dbo].[CCB_CORTA_IMSS]  where [NO_ORDEN] = (select valor from @ordersTable where id=3)
								and [NO_CONTRATO]=(select valor from @ordersTable where id=1));
								--and [NO_SOLICITUD]= (select valor from @ordersTable where id=2)); 
								/*and [FECHA_EMISION]=(select valor from @ordersTable where id=6)
								and [LUGAR_ENTREGA]=(select valor from @ordersTable where id=7));
								and [ESTATUS_CLIENTE]=(select valor from @ordersTable where id=11)
								and [FECHA_ENTREGA]=(select valor from @ordersTable where id=12)
								and RFC=@rfc);*/
								--AND [ALMACEN_DESTINO]= @almacenDestino);

								 set @isDuplicadePosicion = (select count(*) from [dbo].[CCB_CORTA_POSICION]  where [NO_ORDEN] = (select valor from @ordersTable where id=3)
								and [CCB]=(select valor from @ordersTable where id=5) and [CANTIDAD]=(select valor from @ordersTable where id=13)
								and [PRECIO]=(select valor from @ordersTable where id=14));
								PRINT @isDuplicade
								IF @isDuplicade=0 or @isDuplicadePosicion=0
									BEGIN
										PRINT 'ELEMENTO DUPLICADO MANDAR ERROR PORQUE TIENE DIFERENCIAS';
										INSERT INTO [dbo].[Log_errores]
										   ([NO_ORDEN]
										   ,[STATUS]
										   ,[CODIGO_MENSAJE]
										   ,[FECHA_ERROR]
										   ,[HORA_ERROR]
										   ,[PROCESADO]
										   ,[MENSAJE]
										   ,[RFC]
										   ,ID_CS)
									 VALUES
										   ((select valor from @ordersTable where id=3)
										   ,'N'
										   ,null
										   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
										   ,(SELECT CONVERT(CHAR(8),GETDATE(),108))
										   ,'N'
										   ,'La orden '+(select valor from @ordersTable where id=3)+ ' ya fue registrada anteriormente, sin embargo hay datos diferentes entre la orden recibida hoy y la registrada'
										   ,@rfc
										   ,@idRfc);
									END
							

						END
					
				END try
				BEGIN CATCH  
				    SELECT  
						ERROR_NUMBER() AS ErrorNumber  
						,ERROR_SEVERITY() AS ErrorSeverity  
						,ERROR_STATE() AS ErrorState  
						,ERROR_PROCEDURE() AS ErrorProcedure  
						,ERROR_MESSAGE() AS ErrorMessage; 
						print 'Entro al catch';
						print ERROR_MESSAGE();
						DECLARE @msjError NVARCHAR(MAX),@noOrderError NVARCHAR(MAX);  
						SET @msjError = ERROR_MESSAGE();  
						set @noOrderError =(select valor from @ordersTable where id=3);
						EXECUTE [dbo].[errorsAutOR] @msjError, @rfc, @noOrderError;
				END CATCH;  
			
			ELSE IF (@counter > 2 and @cliente='INSABI')
								  BEGIN
								  PRINT 'llego a insabi';
								  select * from @ordersTable;
									--VALIDATE CLUE
									--Cuando en el campo Almacen_Entrega, viene la leyenda "PARA ENTREGA A CLUES O DESTINO FINAL", 
									--se deberá tomar el campo CLUES hacer un Split por guion medio y poner ese dato en el campo CLUE
									set @almacenEntregaInsabi=(select valor from @ordersTable where id=5);
									PRINT @almacenEntregaInsabi;
									IF @almacenEntregaInsabi='PARA ENTREGA A CLUES O DESTINO FINAL.'
									BEGIN
											PRINT 'Entro en if clues';
											set @cluesCursor=(select valor from @ordersTable where id=10);
											DECLARE clue_cursor CURSOR FOR
											Select Key_Value  from [dbo].[udf-Str-Parse](@cluesCursor,'-')				
											OPEN clue_cursor 
											FETCH NEXT FROM clue_cursor   
											INTO @clue;

											CLOSE clue_cursor  
											DEALLOCATE clue_cursor 
											
											
									END
									PRINT @clue;
										 --Insertar en tabla corta PARA INSABI
										INSERT INTO [dbo].[CCB_CORTA_INSABI]
									   ([NO_CONTRATO],[NO_ORDEN],[ALMACEN_ENTREGA],[DIRECCION_ALMACEN],[CLUES],[ENTIDAD_FEDERATIVA],[PROCEDIMIENTO],
									   [FIANZA],[PARTIDA_PRESUPUESTAL],[CLUE],[RFC],[FECHA_ENTREGA],[FECHA_EMISION],ID_CS--,[FECHA_INSERCION]
									   --,[HORA_INSERCION]
									   )
										VALUES
									   ((select valor from @ordersTable where id=13) ,
									   (select valor from @ordersTable where id=1),
									   (select valor from @ordersTable where id=5),
									   (select valor from @ordersTable where id=6),
									   (select valor from @ordersTable where id=10),
										(select valor from @ordersTable where id=11),
										(select valor from @ordersTable where id=14),
										(select valor from @ordersTable where id=15),
										(select valor from @ordersTable where id=16),
										--calculaclue
										@clue,
										@rfc,
										(select valor from @ordersTable where id=4),
										(select valor from @ordersTable where id=3),
										@idRfc
										--,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1)),
										--(SELECT CONVERT(CHAR(8),GETDATE(),108))
									   ); 
						   
									   --corta POSICION
									   INSERT INTO [dbo].[CCB_CORTA_POSICION]
									   ([NO_ORDEN]
									   ,[CCB]
									   ,[CANTIDAD]
									   ,[PRECIO]
									   ,[FECHA_INSERCION],[HORA_INSERCION]
									   )
										 VALUES
									   ((select valor from @ordersTable where id=1)
									   ,(select valor from @ordersTable where id=8)
									   ,(select valor from @ordersTable where id=12)
									   ,(select valor from @ordersTable where id=16)
									   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
									   , (SELECT CONVERT(CHAR(8),GETDATE(),108))
									  );
									   PRINT 'SE INSERTÓ ORDEN INSABI';
								  END
			 --Borra la tabla temporal
			 delete  @ordersTable;
				CLOSE campos_cursor  
				DEALLOCATE campos_cursor 
			--FIN RECORRER CAMPOS



			FETCH NEXT FROM registro_cursor INTO @registro  
        END  
  
    CLOSE registro_cursor  
    DEALLOCATE registro_cursor  

	--update procesado
	update CARGA_ROBOT set status='P' where ID=@idFile;

		FETCH NEXT FROM db_cursor_orders   
		INTO @idRfc,@rfc,@idFile,@cliente, @archivo  
	END 

CLOSE db_cursor_orders  
DEALLOCATE db_cursor_orders 

	
END