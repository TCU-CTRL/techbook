[CmdletBinding()]
param(
    [ValidateSet('pdf', 'clean')]
    [string]$Target = 'pdf'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
    throw 'latexmk was not found. Install TeX Live and add its bin directory to PATH.'
}

Push-Location $PSScriptRoot
try {
    New-Item -ItemType Directory -Path 'build' -Force | Out-Null
    if ($Target -eq 'clean') {
        & latexmk -norc -r latexmkrc -C main.tex
    } else {
        & latexmk -norc -r latexmkrc main.tex
    }
    if ($LASTEXITCODE -ne 0) {
        throw "latexmk failed with exit code $LASTEXITCODE."
    }
    if ($Target -eq 'clean') {
        Get-ChildItem -LiteralPath 'build' -File -Recurse -Force |
            Remove-Item -Force
    }
} finally {
    Pop-Location
}
