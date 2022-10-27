CREATE PROCEDURE [dbo].[updateIDCSAutOR](       
		  @noOrder NVARCHAR(MAX)
        ) 
        AS
        BEGIN

		DECLARE @idCs int;

		
		 
		set @idCs= (select  TOP 1 ID_CS  from CCB_CORTA_IMSS where NO_ORDEN=@noOrder);
		
		if @idCs is not null
		begin
		update CCB_Consulta set ID_CS=@idCs where NO_ORDEN=@noOrder;   
		end


		set @idCs= (select  TOP 1 ID_CS  from CCB_CORTA_INSABI where NO_ORDEN=@noOrder);

		if @idCs is not null
		begin

		update CCB_Consulta set ID_CS=@idCs where NO_ORDEN=@noOrder;  
		end


		  
        END