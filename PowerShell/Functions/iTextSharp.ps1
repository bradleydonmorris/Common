Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions", "iTextSharp.dll"));


Function Merge-PDFs()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [String] $MergedFilePath,

        [Parameter(Mandatory=$true)]
        [String[]] $FilePaths
    )
    [iTextSharp.text.Document] $Document = [iTextSharp.text.Document]::new();
    [System.IO.MemoryStream] $MemoryStream = [System.IO.MemoryStream]::new();
    [iTextSharp.text.pdf.PdfCopy] $PdfCopy = [iTextSharp.text.pdf.PdfCopy]::new($Document, $MemoryStream);
    [void] $Document.Open();
    ForEach ($FilePath In $FilePaths)
    {
	    [iTextSharp.text.pdf.PdfReader] $PdfReader = [iTextSharp.text.pdf.PdfReader]::new($FilePath);
	    [void] $PdfReader.ConsolidateNamedDestinations();
        For ($Loop = 1; $Loop -le $PdfReader.NumberOfPages; $Loop ++)
	    {
		    [void] $PdfCopy.AddPage($PdfCopy.GetImportedPage($PdfReader, $Loop));
	    }
	    [void] $PdfReader.Close();
        [void] $PdfReader.Dispose();
    }
    [void] $PdfCopy.Close();
    [void] $Document.Close();

    [void] $PdfCopy.Dispose();
    [void] $Document.Dispose();

    [Byte[]] $ByteArray = $MemoryStream.ToArray();
    
    If ([System.IO.File]::Exists($MergedFilePath))
    {
        [void] [System.IO.File]::Delete($MergedFilePath);
    }
    [void] [System.IO.File]::WriteAllBytes($MergedFilePath, $ByteArray)
    [void] $MemoryStream.Close();
    [void] $MemoryStream.Dispose();
}

Function Split-PDF()
{
    Param
    (
        [Parameter(Mandatory=$true)]
        [String] $MergedFilePath,

        [Parameter(Mandatory=$true)]
        [String[]] $FolderPath
    )
    If (![IO.Directory]::Exists($FolderPath))
    {
        [void] [IO.Directory]::CreateDirectory($FolderPath);
    }
    [iTextSharp.text.pdf.PdfReader] $PdfReader = [iTextSharp.text.pdf.PdfReader]::new($MergedFilePath);
	[Int32] $PadCount = $PdfReader.NumberOfPages.ToString().Length;
    [String] $SplitFilePathTemplate = [IO.Path]::Combine($FolderPath, "{@PageNumber}.pdf");
	For ($PageNumber = 1; $PageNumber -le $PdfReader.NumberOfPages; $PageNumber ++)
	{
        [String] $SplitFilePath = $SplitFilePathTemplate.Replace("{@PageNumber}", $PageNumber.ToString().PadLeft($PadCount, "0"));
        [iTextSharp.text.Document] $Document = [iTextSharp.text.Document]::new($PdfReader.GetPageSizeWithRotation(1));
        [iTextSharp.text.pdf.PdfCopy] $PdfCopy = [iTextSharp.text.pdf.PdfCopy]::new($Document, [IO.FileStream]::new($SplitFilePath, [IO.FileMode]::Create));
        [void] $Document.Open();
        [void] $PdfCopy.AddPage($PdfCopy.GetImportedPage($PdfReader, $PageNumber));
		[void] $Document.Close();
    }
}
