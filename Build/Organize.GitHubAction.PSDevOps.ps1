#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubAction

$PSScriptRoot | Split-Path | Push-Location

New-GitHubAction -Name "GetOrganized" -Description 'Organize anything into groups of groups' -Action OrganizeAction -Icon chevron-right -OutputPath .\action.yml

Pop-Location