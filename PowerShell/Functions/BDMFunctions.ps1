Function BDM-Harvest()
{
    [String] $CurrentPath = $PWD;
    [String] $DefaultRepoDirectoryPath = "C:\Users\" + $env:USERNAME + "\source\repos";
    ForEach ($Directory In (Get-ChildItem -Path $DefaultRepoDirectoryPath -Directory -Filter ".git" -Recurse -Hidden))
    {
        [String] $RepoDirectory = [IO.Path]::GetDirectoryName($Directory.FullName);
        Set-Location -Path $RepoDirectory;
        [String] $GITOutput = git remote -v | Out-String;
        If ($GITOutput.Contains("harvest"))
        {
            Write-Host -Object ("Harvesting: " + $RepoDirectory);
            git push harvest -q *>$null
        }
    }
    Set-Location -Path $CurrentPath;
}

Function BDM-RepoStat()
{
    Param
    (
        [Parameter(Mandatory=$false)]
        [String] $Output
    )
    [String] $CurrentPath = $PWD;
    [String] $DefaultRepoDirectoryPath = "C:\Users\" + $env:USERNAME + "\source\repos";
    If ($Output -eq $null -or [String]::IsNullOrWhiteSpace($Output))
    {
        $Output = [System.IO.Path]::Combine($DefaultRepoDirectoryPath, "repo-stat.txt");
    }
    [Collections.ArrayList] $Repos = [Collections.ArrayList]::new();
    ForEach ($Directory In (Get-ChildItem -Path $DefaultRepoDirectoryPath -Directory -Filter ".git" -Recurse -Hidden))
    {
        [String] $RepoDirectory = [IO.Path]::GetDirectoryName($Directory.FullName);
        [String] $RelativeDirectoryPath = $RepoDirectory.Substring($DefaultRepoDirectoryPath.Length);
        Set-Location -Path $RepoDirectory;
        [String] $GITOutput = git status --porcelain=v1 | Out-String;
        If ($GITOutput.Length -gt 0)
        {
            [Collections.Hashtable] $StateCounts = [Collections.Hashtable]::new();
            [void] $StateCounts.Add(" M", 0);
            [void] $StateCounts.Add(" A", 0);
            [void] $StateCounts.Add(" D", 0);
            [void] $StateCounts.Add(" R", 0);
            [void] $StateCounts.Add(" C", 0);
            [void] $StateCounts.Add(" U", 0);
            [void] $StateCounts.Add("??", 0);
            [void] $StateCounts.Add("!!", 0);
            ForEach ($Line In ($GITOutput -split "\r?\n|\r"))
            {
                If (![String]::IsNullOrWhiteSpace($Line))
                {
                    [String] $Marker = $Line.Substring(0, 2);
                    If (!$StateCounts.ContainsKey($Marker))
                    {
                        $StateCounts.Add($Marker, 1);
                    }
                    Else
                    {
                        $StateCounts[$Marker] ++;
                    }
                }
            }
            [String] $BranchName = git rev-parse --abbrev-ref HEAD | Out-String;
            $BranchName = $BranchName.Replace("`n", "").Replace("`r", "")
            [void] $Repos.Add(@{
              "Directory" = $RelativeDirectoryPath;
              "Branch" = $BranchName;
              "StateCounts" = $StateCounts;
            });
        }
    }
    [Int32] $PathLength = 0
    [Int32] $BranchLength = 0
    ForEach ($Repo In $Repos)
    {
        If ($Repo.Directory.Length -gt $PathLength)
        {
            $PathLength = $Repo.Directory.Length
        }
        If ($Repo.Branch.Length -gt $BranchLength)
        {
            $BranchLength = $Repo.Branch.Length
        }
    }
    Set-Content -Path $Output -Value ("Root Repo Directory: " + $DefaultRepoDirectoryPath);
    Add-Content -Path $Output -Value "";
    Add-Content -Path $Output -Value ("Relative Directory".PadRight($PathLength, " ") + "  " + "Branch".PadRight($BranchLength, " ") + "  ( M)  ( A)  ( D)  ( R)  ( C)  ( U)  (??)  (!!)  Total");
    Add-Content -Path $Output -Value ("".PadLeft($PathLength, "-") + "  " + "".PadLeft($BranchLength, "-") + "  ----  ----  ----  ----  ----  ----  ----  ----  -----");
    [Int32] $RowLength = 0;
    ForEach ($Repo In $Repos)
    {
        [Int32] $Total = (
            $Repo.StateCounts[" M"] +
            $Repo.StateCounts[" A"] +
            $Repo.StateCounts[" D"] +
            $Repo.StateCounts[" R"] +
            $Repo.StateCounts[" C"] +
            $Repo.StateCounts[" U"] +
            $Repo.StateCounts["??"] +
            $Repo.StateCounts["!!"]
        );

        [String] $Row = "{@Directory}  {@Branch}  {@ M}  {@ A}  {@ D}  {@ R}  {@ C}  {@ U}  {@??}  {@!!}  {@Total}"
        $Row = $Row.Replace("{@Directory}", $Repo.Directory.PadRight($PathLength, " "));
        $Row = $Row.Replace("{@Branch}", $Repo.Branch.PadRight($BranchLength, " "));
        $Row = $Row.Replace("{@ M}", $Repo.StateCounts[" M"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@ A}", $Repo.StateCounts[" A"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@ D}", $Repo.StateCounts[" D"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@ R}", $Repo.StateCounts[" R"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@ C}", $Repo.StateCounts[" C"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@ U}", $Repo.StateCounts[" U"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@??}", $Repo.StateCounts["??"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@!!}", $Repo.StateCounts["!!"].ToString().PadLeft(4, " "));
        $Row = $Row.Replace("{@Total}", $Total.ToString().PadLeft(5, " "));
        $RowLength = $Row.Length;
        Add-Content -Path $Output -Value $Row;
    }
    Add-Content -Path $Output -Value "( M) Modified    ( A) Added      ( D) Deleted      ( R) Renamed".PadLeft($RowLength, " ");
    Add-Content -Path $Output -Value "( C) Copied      ( U) Updated    (??) Untracked    (!!) Ignored".PadLeft($RowLength, " ");
    Set-Location -Path $CurrentPath;
}
