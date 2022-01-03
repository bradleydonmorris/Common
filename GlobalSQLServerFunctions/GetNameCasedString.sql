IF EXISTS
(
	SELECT 1, *
		FROM [sys].[objects]
			INNER JOIN [sys].[schemas]
				ON [objects].[schema_id] = [schemas].[schema_id]
		WHERE
			[objects].[object_id] = OBJECT_ID(N'[Global].[GetNameCasedString]')
			AND [schemas].[name] = N'Global'
			AND [objects].[name] = N'GetNameCasedString'
			AND [objects].[type] = 'FN'
)
	BEGIN
		DROP FUNCTION [Global].[GetNameCasedString]
	END
GO
CREATE FUNCTION [Global].[GetNameCasedString]
(
	@Input [nvarchar](100)
)
RETURNS [nvarchar](100)
AS
BEGIN
	SET @Input = LTRIM(RTRIM(@Input))
	DECLARE @ReturnValue [nvarchar](100)
	DECLARE @InputLength [tinyint] = LEN(@Input)
	DECLARE @Index [tinyint] = 1
	DECLARE @Character [nchar](1) = SUBSTRING(@Input, @Index, 1)
	IF (@Character LIKE '[a-zA-Z]')
		BEGIN
			SET @ReturnValue = UPPER(@Character)
		END
	ELSE
		BEGIN
			SET @ReturnValue = @Character
		END
	SET @Index += 1
	WHILE @Index <= @InputLength
		BEGIN
			SET @Character = SUBSTRING(@Input, @Index, 1)
			IF (@Character LIKE '[a-zA-Z]')
				BEGIN
					SET @ReturnValue += @Character
					SET @Index += 1
				END
			ELSE IF @Character IN (N' ', N'''', N'-')
				BEGIN
					SET @ReturnValue += @Character
					SET @Index += 1
					SET @Character = SUBSTRING(@Input, @Index, 1)
					SET @ReturnValue += UPPER(@Character)
					SET @Index += 1
				END
			ELSE
				BEGIN
					SET @ReturnValue += @Character
					SET @Index += 1
				END
		END
	RETURN @ReturnValue
END
GO
PRINT [Global].[GetNameCasedString](N'twer asdf asdf o''neil Broj-Blah')