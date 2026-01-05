function Get-Organized {
    <#
    .SYNOPSIS
        Get Organized
    .DESCRIPTION
        Organize organizes input into multiple groups.
                        
        Group objects by any number of subproperties and expressions.

        This is a freeform function.

        Any pipelined input will be processed and grouped by the arguments.
    .NOTES
        This functions is built for speed.

        All it does is collect the input and options into an Organizer.

        The Organizer will cache the Organized form of the Input, given the options.

        If any of these change, the object should be reorganized upon the next call.

        Organization will occur with one pass over the input data.

        Any number of groupings are allowed.

        When organizing, 
        this should have the performance characteristic of O(n<input>*n<args>)  
    .EXAMPLE
        Get-ChildItem -Recurse | Organize Directory Extension
    .EXAMPLE
        Get-ChildItem -Recurse | Organize Directory.Name Extension
    .EXAMPLE
        Get-ChildItem -Recurse | Organize LastWriteTime.Year/Month/Day/
    #>
    [Alias(
        'Organize',
        'Organized',
        'Organizer',
        
        'Get-Organize',
        'Get-Organizer',

        'Group-Organize',
        'Group-Organized',
        'Group-Organizer',

        'Organise',
        'Organised',
        'Organiser',

        'Get-Organise',
        'Get-Organised',
        'Get-Organiser',

        'Group-Organise',
        'Group-Organised',
        'Group-Organised'
    )]    
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # Any number of arguments.  These are used to organize the input.
    [Parameter(ValueFromRemainingArguments)]
    [Alias('ArgumentList','Args','OrderBy','GroupBy','SortBy')]
    [PSObject[]]
    $By,

    # Any input object.
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Alias('Input', 'In')]
    [PSObject]
    $InputObject,

    # If set, will create a flat organization.
    # This will join all keys into a single value
    [switch]
    $Flat,

    # The value used to join keys in a flat organization.
    # If this value is provided, it implies -Flat.
    [string]
    $Join
    )
    
    
    $null = $PSBoundParameters.Remove('InputObject')    
    return [PSCustomObject]([Ordered]@{
        PSTypeName='Organizer';Input=@($input)
    } + $PSBoundParameters)
}