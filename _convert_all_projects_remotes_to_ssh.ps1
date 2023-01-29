#!/usr/bin/env pwsh

Param(
    [Parameter(Mandatory = $false)] [string] $dir = $null
)

Import-Module .\pwsh__Io\Io.psm1 -force


function confirmAll([string] $dir) {
    $title = "Updating every remote in folder $dir"
    $question = "Do you want run all commands without confirmation?"
    $choices = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    return $decision -eq 0
}
function fatal([string] $msg, [int] $code = 1) {
    Write-Error $msg
    exit $code
}
function confirm([string] $dir, [string] $command) {
    $title = $dir
    $question = "Run: $command"
    $choices = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 0)
    return $decision -eq 0
}

$dir = if ($dir) { $dir } else { Get-FolderBrowserDialog $PWD }
$dir = if ($dir) { $dir } else { $PWD }
$dir = Resolve-Path $dir
Write-Host "Projects folder = $dir"
$globalConfirmation = confirmAll $dir

Get-ChildItem $dir -Directory | ForEach-Object {
    Push-Location $_.FullName
    Write-Output "================== Dir: $_"
    if (Test-Path '.git') {
        $remotes = "$(git remote -v)";
        Write-Output "> Current remotes: $remotes"
        if ($remotes.Contains('https://github.com')) {
            $repo = ( $remotes | Select-String -Pattern "https://.*github.com/(.*) \(push\)" | select-object -first 1 matches ).matches.groups[1].value
            $repo = if ($repo -like "*.git") { $repo.trimend(".git") } else { $repo } # strip the ending ".git" if present
            $cmd = "git remote set-url origin git@github.com:$repo.git"
            if ($globalConfirmation -or (confirm $_.Name "$cmd ; git fetch --verbose")) {
                Write-Warning "> RUNNING $cmd"
                & git remote set-url origin "git@github.com:$repo.git"
                if ($LASTEXITCODE -ne 0) { fatal "An error occurred. ERRORLEVEL: $LASTEXITCODE" }
                Write-Warning "> RUNNING git fetch --verbose"
                & git fetch --verbose
                if ($LASTEXITCODE -ne 0) { fatal "An error occurred. ERRORLEVEL: $LASTEXITCODE" }
            }
        }
        else {
            Write-Output "> Remote already ok."
        }
    } # TODO submodules??
    else {
        Write-Output "> Not a git working copy."
    }
    Pop-Location
}


Read-Host "`n`nCompleted. Press <Enter> to continue"