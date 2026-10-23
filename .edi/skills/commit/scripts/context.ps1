# Gather git context for the commit skill

$OutputEncoding = [Console]::OutputEncoding = [Text.Encoding]::UTF8

Write-Output "## Branch"
git branch --show-current

Write-Output ""
Write-Output "## Status"
git status --short

Write-Output ""
Write-Output "## Staged diff"
$staged = git diff --cached
if ($staged) {
    $staged
} else {
    Write-Output "(nothing staged)"
}

Write-Output ""
Write-Output "## Unstaged diff"
$unstaged = git diff
if ($unstaged) {
    $unstaged
} else {
    Write-Output "(nothing unstaged)"
}

Write-Output ""
Write-Output "## Recent commits"
git log --oneline -10
