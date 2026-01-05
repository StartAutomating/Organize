@"

# Organize

## Easy Multigrouping in PowerShell

Imagine we have a bunch of objects to organize.

They could be photos, they could be blog posts, they could be music.

In most cases, we will want to organize things into groups of groups.

Quite literally, one [Group-Object](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/group-object?wt.mc_id=MVP_321542) is not going to do the job.

In order to help us all organize more effeciently, here's a nice mini-module for multiple groups.

"@

@"

## Installing and Importing

We can get organized by installing the module from the gallery:

~~~PowerShell
Install-Module Organize
~~~

After it is installed, we can import it.

~~~PowerShell
Import-Module Organize
~~~

You can also clone this repository and import locally:

~~~PowerShell
git clone https://github.com/StartAutomating/Organize.git
cd ./Organize
Import-Module ./ -PassThru
~~~

"@


@'

## Getting Organized

Once we've imported the module we can get organized.

Let's take a simple example: grouping files.

First, let's get all of the files in the module:

~~~PowerShell
$filesToOrganize = Get-Module Organize | 
    Split-Path | 
    Get-ChildItem -Recurse -File
~~~

Now lets start simple, by organizing by directory name

~~~PowerShell
$filesToOrganize | Organize Directory.Name
~~~

Now let's try something a little more interesting.

Let's organize all of the files by LastWriteTime, in a tree of Year/Month/Day

~~~PowerShell
$filesToOrganize | Organize LastWriteTime.Year/Month/Day
~~~

Now let's try organizing into random buckets, and get each bucket by directory

~~~PowerShell
$filesToOrganize | Organize { "A","B" | Get-Random } Directory    
~~~ 

We can organize with one or more scripts from the input.

Let's organize by the extension (minus the period) and a rounded size

~~~PowerShell
$filesToOrganize | Organize { $_.Extension -replace '^\.' } { [Math]::Round($_.Length / 1kb) }
~~~ 

Hopefully, we're all getting the idea.

Because PowerShell's object pipeline can have any type of object, 
we can organize any objects any way we want.

Enjoy!
'@
