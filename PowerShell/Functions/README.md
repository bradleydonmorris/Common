# Common \ PowerShell \ Functions

[Common](https://github.com/bradleydonmorris/Common) \ [PowerShell](https://github.com/bradleydonmorris/Common/tree/master/PowerShell) \ Functions

- RandomStringFunctions.ps1
  - Get-RandomPassword
  ```powershell
  Get-RandomPassword -PasswordLength 32 -CharacterGroups Upper,Lower,Numbers,Special -Weighting @{ "Upper"= 5; "Lower"= 5; "Numbers"= 3; Special=1; };
  Get-RandomPassword -PasswordLength 32 -CharacterGroups Upper,Lower,Numbers -Weighting @{ "Upper"= 5; "Lower"= 5; "Numbers"= 3; Special=0; };
  ```
  - Get-RandomString
  ```powershell
  Get-RandomString -CharacterCount 32 -CharacterGroups Upper,Lower,Numbers,Special;
  Get-RandomString -CharacterCount 32 -CharacterGroups Upper,Lower,Numbers 
  ```
  - Get-RandomBaseString
  ```powershell
  Get-RandomBaseString -CharacterCount 32 -Base Base16;
  Get-RandomBaseString -CharacterCount 32 -Base Base32;
  Get-RandomBaseString -CharacterCount 32 -Base Base64;
  ```

- DateTimeFunctions.ps1
  - Get-DateDouble
  ```powershell
  Get-DateDouble -DateTime $([DateTime]::UtcNow);
  ```
  - Get-TimeDouble
  ```powershell
  Get-TimeDouble -DateTime $([DateTime]::UtcNow);
  ```
  - Get-DateTimeDouble
  ```powershell
  Get-DateTimeDouble -DateTime $([DateTime]::UtcNow);
  ```
  - Get-ElapsedTime
  ```powershell
  Get-ElapsedTime -BeginTime $([DateTime]::UtcNow) -EndTime $([DateTime]::UtcNow.AddMilliseconds(998234578));
  ```
