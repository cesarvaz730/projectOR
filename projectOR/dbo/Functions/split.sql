CREATE FUNCTION [dbo].[split](
          @delimited NVARCHAR(MAX),
          @delimiter NVARCHAR(100)
        ) RETURNS @t TABLE (id INT IDENTITY(1,1), Key_Value NVARCHAR(MAX))
        AS
        BEGIN
          DECLARE @xml XML
          SET @xml = N'<t>' + REPLACE(@delimited,@delimiter,'</t><t>') + '</t>'

          INSERT INTO @t(Key_Value)
          SELECT  r.value('.','varchar(MAX)') as item
          FROM  @xml.nodes('/t') as records(r)
          RETURN
        END