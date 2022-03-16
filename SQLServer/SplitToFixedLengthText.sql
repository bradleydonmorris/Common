CREATE OR ALTER FUNCTION [dbo].[SplitToFixedLengthText]
(
	@LineLength [int],
	@HangingTab [bit],
	@LineTerminator [nvarchar](5),
	@Text [nvarchar](max)
)
RETURNS [nvarchar](MAX)
AS
BEGIN
	DECLARE @ReturnValue [nvarchar](MAX) = ''
	IF LEN(@Text) > 0 AND @LineLength > 0
		BEGIN
			DECLARE @LineIndex [int] = 0
			DECLARE @Index [int] = 1
			WHILE @Index <= LEN(@Text)
				BEGIN
					SET @LineIndex += 1
					SELECT @ReturnValue +=
						CONCAT
						(
							IIF(@HangingTab = 1 AND @LineIndex > 1, CHAR(9), ''),
							SUBSTRING(@Text,@Index,@LineLength),
							@LineTerminator
						)
					SET @Index = @Index + @LineLength
				END
		END
	IF
	(
		@ReturnValue IS NOT NULL
		AND RIGHT(@ReturnValue, LEN(@LineTerminator)) = @LineTerminator
	)
		SET @ReturnValue = LEFT(@ReturnValue, LEN(@ReturnValue) - LEN(@LineTerminator))
	RETURN @ReturnValue
END
GO
DECLARE @LineLength [int] = 65
DECLARE @Text [varchar](MAX) = 'DESCRIPTION:Coordinator: Not Specified|Address: 6500 W 21st St, Tulsa, OK 74107|UTM: 14S 763896 4002735|USNG: Not Specified|Coordinates (DD): 36.1334590000,36.1334590000|Coordinates (DMS): 36° 8'' 0.4524" N,36° 8'' 0.4524" E|Google Map Link: https://www.google.com/maps/?q=36.1334590000,36.1334590000|Google Map Link: http://maps.apple.com/?sll=36.1334590000,36.1334590000&z10&t=s|(Location information is approximate. Exact location may not be known until event begin time.)'
SET @Text = REPLACE(@Text, '|', '\n')
PRINT [dbo].[SplitToFixedLengthText](@LineLength, 1, (CHAR(13) + CHAR(10)), @Text)