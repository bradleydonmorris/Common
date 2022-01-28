IF EXISTS
(
	SELECT 1
		FROM [sys].[objects]
			INNER JOIN [sys].[schemas]
				ON [objects].[schema_id] = [schemas].[schema_id]
		WHERE
			[objects].[object_id] = OBJECT_ID(N'[dbo].[GetNameCasedString]')
			AND [schemas].[name] = N'dbo'
			AND [objects].[name] = N'GetAlphaCharactersOnly'
			AND [objects].[type] = 'FN'
)
	BEGIN
		DROP FUNCTION [dbo].[GetAlphaCharactersOnly]
	END
GO
CREATE FUNCTION [dbo].[GetAlphaCharactersOnly]
(
	@Input [nvarchar](MAX)
)
RETURNS [nvarchar](MAX)
AS
BEGIN
	DECLARE @ReturnValue [nvarchar](100) = LTRIM(RTRIM(@Input))
	DECLARE @AlphaCharactersMatch [nvarchar](100) = '%[^a-zA-Z]%'
    WHILE PATINDEX(@AlphaCharactersMatch, @ReturnValue) > 0
        SET @ReturnValue = STUFF(@ReturnValue, PATINDEX(@AlphaCharactersMatch, @ReturnValue), 1, '')
	RETURN LTRIM(RTRIM(@ReturnValue))
END
GO
PRINT [dbo].[GetAlphaCharactersOnly](N'twer asdf2321434 sd 2 asdf o''neil Broj-Blah')