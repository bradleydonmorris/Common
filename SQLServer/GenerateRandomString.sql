DECLARE @Length [tinyint] = 10
IF @Length NOT BETWEEN 1 AND 256
	RAISERROR(N'Length must be between 1 and 255', 16, 1)
DECLARE @ReturnValue [varchar](255) = ''
DECLARE @Byte [int]
DECLARE @BinaryData [varbinary](255)
DECLARE @Position [int]
WHILE LEN(@ReturnValue) < @Length
	BEGIN
		SET @BinaryData = CRYPT_GEN_RANDOM(255)
		SET @Position = 1
		WHILE @Position <= LEN(@BinaryData)
			BEGIN
				SET @Byte = SUBSTRING(@BinaryData, @Position, 1)
				IF
				(
					--2 thru 9
					@Byte BETWEEN 50 AND 57
					--A thru Z except for I and O
					OR @Byte BETWEEN 65 AND 72
					OR @Byte BETWEEN 74 AND 78
					OR @Byte BETWEEN 80 AND 90
					--a thru z except for l
					OR @Byte BETWEEN 97 AND 107
					OR @Byte BETWEEN 109 AND 122
				)
					BEGIN
						SET @ReturnValue += CHAR(@Byte)
						IF LEN(@ReturnValue) = @Length
							BREAK
					END
				SET @Position += 1
			END
	END
PRINT @ReturnValue