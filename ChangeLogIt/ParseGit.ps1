Class ConventionalCommit
{
    [String] $Type;
    [String] $Scope;
    [String] $Summary;
    [String] $BreakingChangeSummary;
    [String] $BreakingChangeDescription;
    [Collections.ArrayList] $Fixes;
}
Class Person
{
    [String] $Name;
    [String] $Email;
    [String] $Date;
}
Class Commit
{
    [Person] $Author;
    [Person] $Committer;
    [String] $SHA;
    [String] $Subject;
    [String] $Body;
    [ConventionalCommit] $ConventionalCommit;
}
Class Tag
{
    [String] $Ref;
    [Person] $Author;
    [Person] $Committer;
    [Person] $Tagger;
    [String] $SHA;
    [String] $CreatorDate;
    [String] $CommitSHA;
    [String] $Subject;
    [String] $Body;
    [Collections.ArrayList] $Commits;
}
Class Branch
{
    [String] $Name;
    [Collections.ArrayList] $Commits;
}
Class Repository
{
    [String] $Name;
    [Collections.Hashtable] $Tags;
    [Collections.Hashtable] $Commits;
}

Clear-Host;
#[String] $RepoPath = "C:\Users\bradley.morris\source\repos\BDMTestingADO\SuperAwesomeTool";
[String] $RepoPath = "C:\Users\bradley.morris\source\repos\BDMTestingADO\Trash";
[String] $RepoName = [IO.Path]::GetFileName($RepoPath);
[String] $OutputPath = [IO.Path]::ChangeExtension([IO.Path]::Combine($HOME, "source\repos\ChangeLogItOutput", $RepoName), ".json");
[String] $MarkdownPath = [IO.Path]::ChangeExtension($OutputPath, ".md");
Set-Location -Path $RepoPath

[Repository] $Repository = [Repository]::new();
$Repository.Name = $RepoName;
$Repository.Tags = [Collections.Hashtable]::new();
$Repository.Commits = [Collections.Hashtable]::new();

#[Collections.ArrayList] $Branches = [Collections.ArrayList]::new();
[Collections.ArrayList] $BranchNames = [Collections.ArrayList]::new();
[void] $BranchNames.AddRange(@("remotes/origin/main")) ;#, "remotes/origin/qa", "remotes/origin/dev"));
[String] $CommandOutput = (git branch -a --list "origin/releases*" | Out-String);
$CommandOutput = $CommandOutput.Replace("`r`n", "|");
ForEach ($Ref In $CommandOutput.Split("|"))
{
    If (![String]::IsNullOrEmpty($Ref.Trim()))
    {
        [void] $BranchNames.Add($Ref.Trim());
    }
}
ForEach ($BranchName In $BranchNames)
{
    [Boolean] $Failue = $false;
    [Boolean] $SaveBranch = $true;
    Write-Host $BranchName
    Try
    {
        [String] $Result = git checkout "$BranchName" 2>&1 | % ToString;
        If (
            (
                -not $Result.ToLower().StartsWith("head is now at") -and
                -not $Result.ToLower().StartsWith("previous head position was")
            ) -and
            (
                $LASTEXITCODE -ne 0 -or
                -not $?
            )
        )
        {
            Throw [Exception]::new("Check out failed");
        }
        $Failue = $false;
        $SaveBranch = $true;
    }
    Catch
    {
        $Failue = $true;
        if ($_.Exception.Message.StartsWith("Check out failed"))
        {
            $SaveBranch = $false;
        }
    }
    If (-not $Failue)
    {
#[Branch] $Branch = [Branch]::new();
#$Branch.Commits = [Collections.ArrayList]::new();
#$Branch.Name = $BranchName;
        $Log = (git log --pretty=format:'{\"authorName\":\"%an\", \"authorEmail\":\"%ae\", \"authorDate\":\"%aI\", \"committerName\":\"%cn\", \"committerEmail\":\"%ce\", \"committerDate\":\"%cI\", \"sha\":\"%H\", \"subject\":\"%s\", \"body\":\"%b\" },' | Out-String);
        If ($Log.EndsWith("`r`n"))
        {
            $Log = $Log.Substring(0, $Log.Length - 2);
        }
        If ($Log.EndsWith(","))
        {
            $Log = $Log.Substring(0, $Log.Length - 1);
        }
        $Log = "[" + $Log + "]"
        ForEach ($CommitEntry In (ConvertFrom-Json -InputObject $Log))
        {
            [Commit] $Commit = [Commit]::new();
            $Commit.Author = [Person]::new();
            $Commit.Committer = [Person]::new();
            $Commit.ConventionalCommit = [ConventionalCommit]::new();
            $Commit.ConventionalCommit.Fixes = [Collections.ArrayList]::new();

            If (![String]::IsNullOrEmpty($CommitEntry.authorName))
            {
                $Commit.Author.Name = $CommitEntry.authorName;
            }
            If (![String]::IsNullOrEmpty($CommitEntry.authorEmail))
            {
                $Commit.Author.Email = $CommitEntry.authorEmail.Replace("<", "").Replace(">", "");
            }
            [DateTime] $AuthorDate = [DateTime]::MinValue;
            If ([DateTime]::TryParseExact($CommitEntry.authorDate, [String[]] "yyyy-MM-ddTHH:mm:ssKKKK", $null, [System.Globalization.DateTimeStyles]::None, [ref] $AuthorDate))
            {
                $Commit.Author.Date = $AuthorDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss");
            }

            If (![String]::IsNullOrEmpty($CommitEntry.committerName))
            {
                $Commit.Committer.Name = $CommitEntry.committerName;
            }
            If (![String]::IsNullOrEmpty($CommitEntry.committerEmail))
            {
                $Commit.Committer.Email = $CommitEntry.committerEmail.Replace("<", "").Replace(">", "");
            }
            [DateTime] $CommitterDate = [DateTime]::MinValue;
            If ([DateTime]::TryParseExact($CommitEntry.committerDate, [String[]] "yyyy-MM-ddTHH:mm:ssKKKK", $null, [System.Globalization.DateTimeStyles]::None, [ref] $CommitterDate))
            {
                $Commit.Committer.Date = $CommitterDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss");
            }

            $Commit.SHA = $CommitEntry.sha;
            $Commit.Subject = $CommitEntry.subject;
            $Commit.Body = $CommitEntry.body;

            [String] $Subject = $Commit.Subject;
            [String] $CommitMessage = $Commit.Body;
            If (![String]::IsNullOrEmpty($Subject))
            {
                If ($Subject.Contains("("))
                {
                    $Commit.ConventionalCommit.Type = $Subject.Substring(0, $Subject.IndexOf("(")).Trim();
                    $Commit.ConventionalCommit.Scope = $Subject.Substring($Subject.IndexOf("(") + 1, ($Subject.IndexOf(")") - $Subject.IndexOf("(") - 1)).Trim();
                }
                ElseIf ($Subject.Contains(":"))
                {
                    $Commit.ConventionalCommit.Type = $Subject.Substring(0, $Subject.IndexOf(":")).Trim();
                    $Commit.ConventionalCommit.Scope = $null;
                }
                If ($Subject.Contains(":"))
                {
                    $Commit.ConventionalCommit.Summary = $Subject.Substring($Subject.IndexOf(":") + 1, $Subject.Length - ($Subject.IndexOf(":") + 1)).Trim();
                }
            }
            If (![String]::IsNullOrEmpty($CommitMessage))
            {
                $CommitMessage = $CommitMessage.Replace("`r", "|").Replace("`n", "|");
                While ($CommitMessage.Contains("||"))
                {
                    $CommitMessage = $CommitMessage.Replace("||", "|");
                }
                [String[]] $Lines = $CommitMessage.Split("|");
                [Int32] $BreakingChangeSummaryLine = -1;
                [Int32] $BreakingChangeDescriptionLine = -1;
                [Int32] $FixesLine = -1;
                For ([Int] $Loop = 0; $Loop -lt $Lines.Length; $Loop ++)
                {
                    If ($Lines[$Loop].StartsWith("BREAKING CHANGE:"))
                    {
                        $BreakingChangeSummaryLine = $Loop;
                        $BreakingChangeDescriptionLine = $Loop + 1;
                    }
                    If ($Lines[$Loop].StartsWith("Fixes"))
                    {
                        $FixesLine = $Loop;
                    }
                }
                If ($BreakingChangeSummaryLine -gt -1)
                {
    
                    $Commit.ConventionalCommit.BreakingChangeSummary= $Lines[$BreakingChangeSummaryLine].Substring(16).Trim();
                    $Commit.ConventionalCommit.BreakingChangeDescription = $Lines[$BreakingChangeDescriptionLine].Trim();
                }
                If ($FixesLine -gt -1)
                {
                    [String] $Fixes = $Lines[$FixesLine]
                    If ($Fixes.StartsWith("Fixes:"))
                    {
                        $Fixes = $Fixes.Substring(6).Trim();
                    }
                    If ($Fixes.StartsWith("Fixes"))
                    {
                        $Fixes = $Fixes.Substring(5).Trim();
                    }
                    ForEach ($Fix In $Fixes.Trim().Split(","))
                    {
                        [void] $Commit.ConventionalCommit.Fixes.Add($Fix.Trim());
                    }
                }
            }
            [void] $Repository.Commits.Add($Commit.SHA, $Commit);
        }
        If ($BranchName.Equals("remotes/origin/main"))
        {
            git fetch --all --tags
            $Refs = (
            git for-each-ref refs/tags --shell --format='{
                "ref": "%(refname)",
                "sha": "%(objectname)",
                "type": "%(objecttype)",
                "authorName": "%(authorname)",
                "authorEmail": "%(authoremail)",
                "authorDate": "%(authordate:iso8601)",
                "committerName": "%(committername)",
                "committerEmail": "%(committeremail)",
                "committerDate": "%(committerdate:iso8601)",
                "taggerName": "%(taggername)",
                "taggerEmail": "%(taggeremail)",
                "taggerDate": "%(taggerdate:iso8601)",
                "creatorDate": "%(creatordate:iso8601)",
                "subject":"%(contents:subject)",
                "body": "%(contents:body)"
            },' | Out-String);
            If ($Refs.EndsWith("`r`n"))
            {
                $Refs = $Refs.Substring(0, $Refs.Length - 2);
            }
            If ($Refs.EndsWith(","))
            {
                $Refs = $Refs.Substring(0, $Refs.Length - 1);
            }
            $Refs = "[" + $Refs + "]"

            [String] $PreviousTag = $null;
            [String] $CurrentTag = $null;
            ForEach ($TagEntry In (ConvertFrom-Json -InputObject $Refs))
            {
                [Tag] $Tag = [Tag]::new();
                $Tag.Author = [Person]::new();
                $Tag.Committer = [Person]::new();
                $Tag.Tagger = [Person]::new();
                $Tag.Commits = [Collections.ArrayList]::new();

                $Tag.Ref = $TagEntry.ref;
                If (![String]::IsNullOrEmpty($PreviousTag))
                {
                    [String] $CurrentTag = $TagEntry.ref;
                    [System.Diagnostics.ProcessStartInfo] $ProcessStartInfo = [System.Diagnostics.ProcessStartInfo]::new();
                    $ProcessStartInfo.WorkingDirectory = $RepoPath;
                    $ProcessStartInfo.FileName = "git";
                    $ProcessStartInfo.RedirectStandardError = $true;
                    $ProcessStartInfo.RedirectStandardOutput = $true;
                    $ProcessStartInfo.UseShellExecute = $false;
                    $ProcessStartInfo.Arguments = "log --oneline --pretty=tformat:`"%H`" `"$PreviousTag`"..`"$CurrentTag`"";
                    [System.Diagnostics.Process] $Process = [System.Diagnostics.Process]::new();
                    $Process.StartInfo = $ProcessStartInfo;
                    $Process.Start() | Out-Null;
                    $Process.WaitForExit();
                    [String] $CommandOutput = $Process.StandardOutput.ReadToEnd();
                    [void] $Process.Dispose();
                    $CommandOutput = $CommandOutput.Replace("`n", "|");
                    If ($CommandOutput.EndsWith("|"))
                    {
                        $CommandOutput = $CommandOutput.Substring(0, $CommandOutput.Length - 1);
                    }
                    [void] $Tag.Commits.AddRange($CommandOutput.Split("|"));
                    $PreviousTag = $CurrentTag;
                }
                Else
                {
                    $CurrentTag = $TagEntry.ref;
                    [String] $CurrentTag = $TagEntry.ref;
                    [System.Diagnostics.ProcessStartInfo] $ProcessStartInfo = [System.Diagnostics.ProcessStartInfo]::new();
                    $ProcessStartInfo.WorkingDirectory = $RepoPath;
                    $ProcessStartInfo.FileName = "git";
                    $ProcessStartInfo.RedirectStandardError = $true;
                    $ProcessStartInfo.RedirectStandardOutput = $true;
                    $ProcessStartInfo.UseShellExecute = $false;
                    $ProcessStartInfo.Arguments = "log --oneline --pretty=tformat:`"%H`" `"$CurrentTag`"";
                    [System.Diagnostics.Process] $Process = [System.Diagnostics.Process]::new();
                    $Process.StartInfo = $ProcessStartInfo;
                    $Process.Start() | Out-Null;
                    $Process.WaitForExit();
                    [String] $CommandOutput = $Process.StandardOutput.ReadToEnd();
                    [void] $Process.Dispose();
                    $CommandOutput = $CommandOutput.Replace("`n", "|");
                    If ($CommandOutput.EndsWith("|"))
                    {
                        $CommandOutput = $CommandOutput.Substring(0, $CommandOutput.Length - 1);
                    }
                    [void] $Tag.Commits.AddRange($CommandOutput.Split("|"));
                    $PreviousTag = $CurrentTag;
                }

                $Tag.CommitSHA = (git rev-list -n 1 $TagEntry.sha| Out-String).Trim();


                If (![String]::IsNullOrEmpty($TagEntry.authorName))
                {
                    $Tag.Author.Name = $TagEntry.authorName;
                }
                If (![String]::IsNullOrEmpty($TagEntry.authorEmail))
                {
                    $Tag.Author.Email = $TagEntry.authorEmail.Replace("<", "").Replace(">", "");
                }
                If (![String]::IsNullOrEmpty($TagEntry.authorDate))
                {
                    $TagEntry.authorDate = $TagEntry.authorDate.Insert(23, ":");
                    [DateTime] $AuthorDate = [DateTime]::MinValue;
                    If ([DateTime]::TryParseExact($TagEntry.authorDate, [String[]] "yyyy-MM-dd HH:mm:ss zzz", $null, [System.Globalization.DateTimeStyles]::None, [ref] $AuthorDate))
                    {
                        $Tag.Author.Date = $AuthorDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss");
                    }
                }

                If (![String]::IsNullOrEmpty($TagEntry.committerName))
                {
                    $Tag.Committer.Name = $TagEntry.committerName;
                }
                If (![String]::IsNullOrEmpty($TagEntry.committerEmail))
                {
                    $Tag.Committer.Email = $TagEntry.committerEmail.Replace("<", "").Replace(">", "");
                }
                If (![String]::IsNullOrEmpty($TagEntry.committerDate))
                {
                    $TagEntry.committerDate = $TagEntry.committerDate.Insert(23, ":");
                    [DateTime] $CommitterDate = [DateTime]::MinValue;
                    If ([DateTime]::TryParseExact($TagEntry.committerDate, [String[]] "yyyy-MM-dd HH:mm:ss zzz", $null, [System.Globalization.DateTimeStyles]::None, [ref] $CommitterDate))
                    {
                        $Tag.Committer.Date = $CommitterDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss");
                    }
                }

                If (![String]::IsNullOrEmpty($TagEntry.taggerName))
                {
                    $Tag.Tagger.Name = $TagEntry.taggerName;
                }
                If (![String]::IsNullOrEmpty($TagEntry.taggerEmail))
                {
                    $Tag.Tagger.Email = $TagEntry.taggerEmail.Replace("<", "").Replace(">", "");
                }
                If (![String]::IsNullOrEmpty($TagEntry.taggerDate))
                {
                    $TagEntry.taggerDate = $TagEntry.taggerDate.Insert(23, ":");
                    [DateTimeOffset] $TaggerDate = [DateTimeOffset]::MinValue;
                    If ([DateTimeOffset]::TryParseExact($TagEntry.taggerDate, [String[]] "yyyy-MM-dd HH:mm:ss zzz", $null, [System.Globalization.DateTimeStyles]::None, [ref] $TaggerDate))
                    {
                        $Tag.Tagger.Date = $TaggerDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss");
                    }
                }

                If (![String]::IsNullOrEmpty($TagEntry.creatorDate))
                {
                    $TagEntry.creatorDate = $TagEntry.creatorDate.Insert(23, ":");
                    [DateTime] $CreatorDate = [DateTime]::MinValue;
                    If ([DateTime]::TryParseExact($TagEntry.creatorDate, [String[]] "yyyy-MM-dd HH:mm:ss zzz", $null, [System.Globalization.DateTimeStyles]::None, [ref] $CreatorDate))
                    {
                        $Tag.CreatorDate = $CreatorDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss");
                    }
                }
                $Tag.SHA = $TagEntry.sha;
                If (![String]::IsNullOrEmpty($TagEntry.subject))
                {
                    $Tag.Subject = $TagEntry.subject;
                }
                If (![String]::IsNullOrEmpty($TagEntry.body))
                {
                    $Tag.Body = $TagEntry.body;
                }
                [void] $Repository.Tags.Add($Tag.Ref, $Tag);
            }
        }
    }
    If ($SaveBranch)
    {
#        [void] $Repository.Branches.Add($Branch);
    }
}
[String] $Json = ConvertTo-Json -InputObject $Repository -Depth 100;
Set-Content -Path $OutputPath -Value $Json;


[Collections.Hashtable] $Versions = [Collections.Hashtable]::new();
ForEach ($TagKey In $Repository.Tags.Keys)
{
    [Tag] $Tag = $Repository.Tags[$TagKey];
    $Versions.Add($TagKey, [Collections.Hashtable]::new());
    #[Collections.Hashtable] $Scopes = [Collections.Hashtable]::new();
    ForEach ($CommitSHA In $Tag.Commits)
    {
        [Commit] $Commit = $Repository.Commits[$CommitSHA];
        If (
            $Commit.ConventionalCommit -ne $null -and
            ![String]::IsNullOrEmpty($Commit.ConventionalCommit.Type)
        )
        {
            [String] $Scope = $Commit.ConventionalCommit.Scope;
            If ([String]::IsNullOrEmpty($Scope))
            {
                $Scope = "Unscoped";
            }
            If ($Versions[$TagKey].ContainsKey($Commit.ConventionalCommit.Scope))
            {
                [void] $Versions[$TagKey][$Commit.ConventionalCommit.Scope].Add($Commit);
            }
            Else
            {
                [void] $Versions[$TagKey].Add($Commit.ConventionalCommit.Scope, [Collections.ArrayList]::new());
            }
        }
    }

}


Set-Content -Path $MarkdownPath -Value ("# " + $Repository.Name + "`r`n");


ForEach ($VersionKey In $Versions.Keys)
{
    Add-Content -Path $MarkdownPath -Value ("## " + $VersionKey.Replace("refs/tags/", "") + "`r`n");
    ForEach ($ScopeKey In $Versions[$VersionKey].Keys)
    {
        Add-Content -Path $MarkdownPath -Value ("### " + $ScopeKey + "`r`n");




#https://dev.azure.com/BDMTestingADO/Trash/_git/Trash/commit/33d7aacbaa1cb01cebb2782b3e56a0a71398ec3f
    }
}

$Versions