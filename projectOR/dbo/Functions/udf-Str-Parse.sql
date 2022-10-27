CREATE FUNCTION [dbo].[udf-Str-Parse] (@String varchar(max),@delimeter varchar(10))
--Usage: Select * from [dbo].[udf-Str-Parse]('Dog,Cat,House,Car',',')
--       Select * from [dbo].[udf-Str-Parse]('John Cappelletti was here',' ')
--       Select * from [dbo].[udf-Str-Parse]('id26,id46|id658,id967','|')

Returns @ReturnTable Table (Key_PS int IDENTITY(1,1) NOT NULL , Key_Value varchar(max))

As

Begin
   Declare @intPos int,@SubStr varchar(max)
   Set @IntPos = CharIndex(@delimeter, @String)
   Set @String = Replace(@String,@delimeter+@delimeter,@delimeter)
   While @IntPos > 0
      Begin
         Set @SubStr = Substring(@String, 0, @IntPos)
		
         Insert into @ReturnTable (Key_Value) values (@SubStr)
         Set @String = Replace(@String, @SubStr + @delimeter, '')
		
         Set @IntPos = CharIndex(@delimeter, @String)
      End
   Insert into @ReturnTable (Key_Value) values (@String)
   Return 
End