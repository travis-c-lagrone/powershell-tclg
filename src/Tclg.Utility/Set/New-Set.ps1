function New-Set {
    [CmdletBinding(PositionalBinding=$false, DefaultParameterSetName='empty')]
    [OutputType([System.Collections.Generic.ISet[object]])]
    param(
        [Parameter(ParameterSetName='Collection', Mandatory, Position=0)]
        [System.Collections.IEnumerable]
        $Collection,

        [Parameter(ParameterSetName='Size', Mandatory)]
        [ValidateRange('NonNegative')]
        [int]
        $Size
    )

    if ($PSBoundParameters.Contains('Collection')) {
        [System.Collections.Generic.HashSet[object]]::new($Collection)
    }
    elseif ($PSBoundParameters.Contains('Size')) {
        [System.Collections.Generic.HashSet[object]]::new($Size)
    }
    else {
        [System.Collections.Generic.HashSet[object]]::new()
    }
}

Set-Alias -Name 'nset' -Value 'New-Set' -ErrorAction SilentlyContinue
