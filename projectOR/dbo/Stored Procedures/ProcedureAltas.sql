-- =============================================
-- Author:		Cesar
-- Create date: 01/07/2022
-- Description:	Process to generate altas
-- =============================================
CREATE PROCEDURE [dbo].[ProcedureAltas] 
	
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @cliente NVARCHAR(MAX), @archivo NVARCHAR(MAX), @registro NVARCHAR(MAX), @campos NVARCHAR(MAX),@counter int,@idFile int,
	@existReg int,@isDuplicade int,@isDuplicadePosicion int, @rfc NVARCHAR(MAX),@almacenDestino NVARCHAR(MAX),@suministroValidRFC int,@suministroValidCCB int,@idRfc int,
	@almacenEntregaInsabi NVARCHAR(MAX),@clue NVARCHAR(MAX),@cluesCursor  NVARCHAR(MAX) , @cancelada NVARCHAR(MAX),@pedidoSap NVARCHAR(MAX),@laboratorio NVARCHAR(MAX);
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
       SELECT CAST(archivo AS VARCHAR(MAX)) AS BASE64_COLUMN,CLIENT,ID,RFC,ID_CS FROM alta_carga_robot WHERE STATUS IS NULL
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
			
							select * from @ordersTable;
							set @pedidoSap=(select pedido_sap from CCB_Consulta where [NO_ORDEN]=(select valor from @ordersTable where id=4));
							if @pedidoSap is null
							begin
								set @laboratorio= (select nombre_sc from listado_sc where id_cs=@idRfc);
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
										   ((select valor from @ordersTable where id=4)
										   ,'N'
										   ,null
										   ,(SELECT CONVERT(VARCHAR(10),SYSDATETIME() ,1))
										   ,(SELECT CONVERT(CHAR(8),GETDATE(),108))
										   ,'N'
										   ,'El número de ALTA'+  (select valor from @ordersTable where id=1)+' que corresponde al número de orden '+(select valor from @ordersTable where id=4)+
										   ' del laboratorio '+ @laboratorio +' no tiene un documento de venta en SAP.'
										   ,@rfc
										   ,@idRfc);
								 PRINT 'Error no existe pedido sap';
							end

							else
							begin
								

									   INSERT INTO [dbo].[ALTAS]
									   ([ALTA]
									   ,[FECHA]
									   ,[NO_CONTRATO]
									   ,[NO_ORDEN]
									   ,[CCB]
									   ,[CANTIDAD]
									   ,[IMPORTE]
									   ,[FPP]
									   ,[UN_REC]
									   ,[DES_UNIDAD]
									   ,[RFC]
									   ,[clasPtalDist]
									   ,[descDist]
									   ,[totalItems]
									   ,[resguardo],
									   PROCESADO,PEDIDO_SAP,ID_CS)
								 VALUES
									   ((select valor from @ordersTable where id=1) ,
									   (select valor from @ordersTable where id=2) ,
									   (select valor from @ordersTable where id=3) ,
									   (select valor from @ordersTable where id=4) ,
									   (select valor from @ordersTable where id=5) ,
									   (select valor from @ordersTable where id=6) ,
									   (select valor from @ordersTable where id=7) ,
									   (select valor from @ordersTable where id=8) ,
									   (select valor from @ordersTable where id=9) ,
									   (select valor from @ordersTable where id=10) ,
									  @rfc ,
									   (select valor from @ordersTable where id=11) ,
									   (select valor from @ordersTable where id=12) ,
									   (select valor from @ordersTable where id=13) ,
									   (select valor from @ordersTable where id=14),
									   'N',@pedidoSap,@idRfc);
						  	  
								  PRINT 'SE INSERTÓ ALTA IMSS';
								end

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
						--EXECUTE [dbo].[errorsAutOR] @msjError, @rfc, @noOrderError;
				END CATCH;
		
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
	update alta_carga_robot set status='P' where ID=@idFile;

		FETCH NEXT FROM db_cursor_orders   
		INTO @idRfc,@rfc,@idFile,@cliente, @archivo  
	END 

CLOSE db_cursor_orders  
DEALLOCATE db_cursor_orders 

	
END