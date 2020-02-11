function Unprotect-Item {
    [CmdletBinding(DefaultParameterSetName='LiteralPath', PositionalBinding=$false, SupportsShouldProcess)]
    param(
        # The path of the item(s) to decrypt. Supports wildcards.
        [Parameter(ParameterSetName='Path', Mandatory, Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string[]]
        [ValidateScript({ Test-Path -Path $_ -IsValid })]
        $Path,

        # The literal path of the item(s) to decrypt.
        [Parameter(ParameterSetName='LiteralPath', Mandatory, ValueFromPipelineByPropertyName)]
        [string[]]
        [ValidateScript({ Test-Path -LiteralPath $_ -IsValid })]
        [Alias('PSPath')]
        $LiteralPath,

        [Parameter()]
        [SupportsWildcards()]
        [string]
        [ValidateScript({ Test-Path $_ -IsValid })]
        $Filter,

        [Parameter()]
        [SupportsWildcards()]
        [string[]]
        [ValidateScript({ Test-Path $_ -IsValid })]
        $Include,

        [Parameter()]
        [SupportsWildcards()]
        [string[]]
        [ValidateScript({ Test-Path $_ -IsValid })]
        $Exclude,

        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCredential]
        [Alias('PSCredential')]
        $Credential,

        # Specifies that each item (not just path) is output to the pipeline after being decrypted.
        [Parameter()]
        [switch]
        $PassThru
    )
    process {
        $splat = @{}
        foreach ($key in @('Path', 'LiteralPath', 'Filter', 'Include', 'Exclude', 'Credential', 'Force')) {
            if ($MyInvocation.BoundParameters.ContainsKey($key)) {
                $splat[$key] = $MyInvocation.BoundParameters[$key]
            }
        }

        $items = Get-Item @splat
        foreach ($item in $items) {
            try {
                if ((-bnot $item.Attributes) -band [System.IO.FileAttributes]::Encrypted) {
                    Write-Warning "$item is already decrypted."
                }
                $item.Decrypt()
                if ($PassThru) {
                    $item
                }
            }
            catch {
                Write-Error -Exception $_
                if ($PassThru -and $Force) {
                    $item
                }
                continue
            }
        }
    }
}

Set-Alias -Name 'upi' -Value 'Unprotect-Item'
