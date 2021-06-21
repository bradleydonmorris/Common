
<#
    Author: Bradley Don Morris
    Web Site: http://bradleydonmorris.me
Usage:
    Get-RandomPassword -PasswordLength 32 -CharacterGroups Upper,Lower,Numbers,Special -Weighting @{"Upper"= 5;"Lower"= 5;"Numbers"= 3;Special=1;} -ErrorAction Ignore
    Get-RandomPassword -PasswordLength 32 -CharacterGroups Upper,Lower,Numbers -Weighting @{"Upper"= 5;"Lower"= 5;"Numbers"= 3;Special=0;} -ErrorAction Ignore
#>

Function Get-RandomPassword()
{
    Param
    (
        [Parameter(Mandatory=$false)]
        [System.Int32] $PasswordLength = 8,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Upper", "Lower", "Numbers", "Special")]
        [String[]]$CharacterGroups,

        [Parameter(Mandatory=$false)]
        [System.Collections.Hashtable] $Weighting
    )
    [System.String] $ReturnValue = [System.String]::Empty;

    #Set the default if $CharacterGroups is not provided.
    If ($CharacterGroups -eq $null)
    {
        $CharacterGroups = "Upper","Lower","Numbers","Special";
    }
    If ($Weighting -eq $null)
    {
        $Weighting = @{};
    }

    [System.Array] $ASCIICodes = @();
    ForEach ($Group In @("Upper","Lower","Numbers","Special"))
    {
        [System.Int32] $Weight = 0;
        [System.Array] $ASCIICode = @();
        switch ($Group)
        {
            "Upper" { $ASCIICode = (65..90) }
            "Lower" { $ASCIICode = (97..122) }
            "Numbers" { $ASCIICode = (48..57) }
            "Special" { $ASCIICode = (33..47)+(58..64)+(91..96)+(123..126) }
        }
        #If in $CharacterGroups but not in $Weighting, need to include as if weighted to 1
        If ($Weighting.ContainsKey($Group))
        {
            $Weight = $Weighting[$Group];
        }
        If ( $CharacterGroups.Contains($Group) -and (!$Weighting.ContainsKey($Group)) )
        {
            $Weight = 1;
        }

        #Add current ASCIICode set to ASCIICodes used for password.
        # Add it for as many times as $Weight
        If ($Weight -gt 0)
        {
            For ($Loop = 1; $Loop -le $Weight; $Loop ++)
            {
               $ASCIICodes += $ASCIICode 
            }
        }
    }

    [System.Int32] $UpperBounds = ($ASCIICodes.Count-1)
    For ($Loop = 1; $Loop -le $PasswordLength; $Loop ++)
    {
        $ReturnValue += [Char]$ASCIICodes[$(Get-Random -Minimum 0 -Maximum $UpperBounds)];
    }
    Return $ReturnValue
}

Function Get-RandomString()
{
    Param
    (
        [Parameter(Mandatory=$false)]
        [System.Int32] $CharacterCount = 8,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Upper", "Lower", "Numbers", "Special")]
        [String[]]$CharacterGroups
    )
    [System.String] $ReturnValue = [System.String]::Empty;

    #Set the default if $CharacterGroups is not provided.
    If ($CharacterGroups -eq $null)
    {
        $CharacterGroups = "Upper","Lower","Numbers","Special";
    }
    [System.Array] $ASCIICodes = @();
    ForEach ($Group In $CharacterGroups)
    {
        [System.Array] $ASCIICode = @();
        switch ($Group)
        {
            "Upper" { $ASCIICode = (65..90) }
            "Lower" { $ASCIICode = (97..122) }
            "Numbers" { $ASCIICode = (48..57) }
            "Special" { $ASCIICode = (33..47)+(58..64)+(91..96)+(123..126) }
        }

        #Add current ASCIICode set to ASCIICodes used for password.
        $ASCIICodes += $ASCIICode 
    }
    [System.Int32] $UpperBounds = ($ASCIICodes.Count-1)
    For ($Loop = 1; $Loop -le $CharacterCount; $Loop ++)
    {
        $ReturnValue += [Char]$ASCIICodes[$(Get-Random -Minimum 0 -Maximum $UpperBounds)];
    }
    Return $ReturnValue
}

Function Get-RandomBase32String()
{
    #Cf: https://en.wikipedia.org/wiki/Base32
    Param
    (
        [Parameter(Mandatory=$false)]
        [System.Int32] $CharacterCount = 8,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Upper", "Lower", "Numbers", "Special")]
        [String[]]$CharacterGroups
    )
    [System.String] $ReturnValue = [System.String]::Empty;

    #Set the default if $CharacterGroups is not provided.
    If ($CharacterGroups -eq $null)
    {
        $CharacterGroups = "Upper","Lower","Numbers","Special";
    }
    [System.Array] $ASCIICodes = @();
    ForEach ($Group In $CharacterGroups)
    {
        [System.Array] $ASCIICode = @();
        switch ($Group)
        {
            "Upper" { $ASCIICode = (65..90) }
            "Lower" { $ASCIICode = (97..122) }
            "Numbers" { $ASCIICode = (48..57) }
            "Special" { $ASCIICode = (33..47)+(58..64)+(91..96)+(123..126) }
        }

        #Add current ASCIICode set to ASCIICodes used for password.
        $ASCIICodes += $ASCIICode 
    }
    [System.Int32] $UpperBounds = ($ASCIICodes.Count-1)
    For ($Loop = 1; $Loop -le $CharacterCount; $Loop ++)
    {
        $ReturnValue += [Char]$ASCIICodes[$(Get-Random -Minimum 0 -Maximum $UpperBounds)];
    }
    Return $ReturnValue
}
