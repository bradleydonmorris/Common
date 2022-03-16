CREATE OR ALTER FUNCTION [dbo].[SplitToFixedLength]
(
	@LineLength [int],
	@HangingTab [bit],
	@Text [nvarchar](max)
)
RETURNS @Line TABLE
(
	[LineNumber] [int] IDENTITY(1, 1) NOT NULL,
	[Text] [nvarchar](MAX)
)
AS
BEGIN
	IF LEN(@Text) > 0 AND @LineLength > 0
		BEGIN
			DECLARE @LineIndex [int] = 0
			DECLARE @Index [int] = 1
			WHILE @Index <= LEN(@Text)
				BEGIN
					SET @LineIndex += 1
					INSERT INTO @Line
						SELECT
							CASE
								WHEN @HangingTab = 1
									THEN
										CONCAT
										(
											IIF(@LineIndex > 1, CHAR(9), ''),
											SUBSTRING(@Text,@Index,@LineLength)
										)
								ELSE SUBSTRING(@Text,@Index,@LineLength)
							END
					SET @Index = @Index + @LineLength
				END
		END
	RETURN
END
GO
