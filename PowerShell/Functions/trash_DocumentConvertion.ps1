<#
[String] $CurrentDir = $PWD;
Set-Location -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs"));

nuget install Markdig
nuget install BouncyCastle
nuget install itext7
nuget install itext.layout
nuget install itext7.pdfhtml
nuget install Common.Logging.Core
nuget install Common.Logging


Set-Location -Path $CurrentDir

Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\Markdig.0.26.0\lib\net452\Markdig.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\Common.Logging.Core.3.4.1\lib\net40\Common.Logging.Core.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\Common.Logging.3.4.1\lib\net40\Common.Logging.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\itext7.commons.7.2.0\lib\net461\itext.commons.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\itext7.7.2.0\lib\net461\itext.layout.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\itext7.7.2.0\lib\net461\itext.io.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\itext7.7.2.0\lib\net461\itext.kernel.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\itext7.pdfhtml.4.0.0\lib\net461\itext.html2pdf.dll"));
Add-Type -Path ([IO.Path]::Combine($HOME, "source\repos\bradleydonmorris\Common\PowerShell\Functions\libs\BouncyCastle.1.8.9\lib\BouncyCastle.Crypto.dll"));


$source = [System.IO.FileInfo]::new("C:\Users\bmorris\source\repos\bradleydonmorris\LifeBook\Conversions\html\Fox Rent A Car\2021-11-29 - 2021-12-05 (Week 1).html");
$dest = [System.IO.FileInfo]::new("C:\Users\bmorris\source\repos\bradleydonmorris\Common\PowerShell\Functions\temp.pdf");
[iText.Html2Pdf.HtmlConverter]::ConvertToPdf($source, $dest);


$HTMLPath = [System.IO.FileInfo]::new("C:\Users\bmorris\source\repos\bradleydonmorris\LifeBook\Conversions\html\Fox Rent A Car\2021-11-29 - 2021-12-05 (Week 1).html");
$PDFPath = [System.IO.FileInfo]::new("C:\Users\bmorris\source\repos\bradleydonmorris\Common\PowerShell\Functions\temp.pdf");
pandoc "$HTMLPath" -V geometry:margin=0.75in --pdf-engine=xelatex -s -o "$PDFPath";

wkhtmltopdf, weasyprint, prince, pdflatex, lualatex, xelatex, latexmk, tectonic, pdfroff, context
pandoc "$HTMLPath" -V geometry:margin=0.75in --pdf-engine=wkhtmltopdf -s -o "$PDFPath" --metadata title="$Title";

[String] $HTMLPath = "C:\Users\bmorris\source\repos\bradleydonmorris\LifeBook\Conversions\html\Fox Rent A Car\2021-11-29 - 2021-12-05 (Week 1).html";
[String] $Title = [System.IO.Path]::GetFileNameWithoutExtension($HTMLPath);
[String] $PDFPath = "C:\Users\bmorris\source\repos\bradleydonmorris\Common\PowerShell\Functions\temp.pdf";
wkhtmltopdf --page-size Letter "$HTMLPath" "$PDFPath"


[String] $MDPath = "C:\Users\bmorris\source\repos\bradleydonmorris\LifeBook\Fox Rent A Car\2021-11-29 - 2021-12-05 (Week 1).md";
[String] $PDFPath = "C:\Users\bmorris\source\repos\bradleydonmorris\Common\PowerShell\Functions\temp.pdf";
ConvertMD-ToPDF -Path $MDPath -OutputPath $PDFPath;
#>
