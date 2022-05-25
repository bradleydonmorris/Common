DECLARE @XML [xml]
SELECT @XML = [XML]
	FROM [SanctionList].[File]

SELECT DISTINCT
	'@' + [Investigate].[Attributes].value('local-name(.)', '[nvarchar](MAX)') AS [AttributeName]
	FROM @XML.nodes('/PFA/Description1List/Description1Name/@*') AS [Investigate]([Attributes])
SELECT DISTINCT
	[Investigate].[Attributes].value('local-name(.)', '[nvarchar](MAX)') AS [NodeName]
	FROM @XML.nodes('/PFA/Description1List/Description1Name/*') AS [Investigate]([Attributes])
SELECT
CASE
	WHEN EXISTS
		(
			SELECT 1
				FROM @XML.nodes('/PFA/Description1List/Description1Name') AS [Investigate]([Attributes])
				WHERE LEN([Investigate].[Attributes].value('.', '[nvarchar](MAX)')) > 0
		)
		THEN 1
	ELSE 0
END AS [HasText]

