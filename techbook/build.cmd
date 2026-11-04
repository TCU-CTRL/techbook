@echo off
setlocal
if not "%~2"=="" goto :usage
if "%~1"=="" goto :start
if /i "%~1"=="pdf" goto :start
if /i "%~1"=="clean" goto :start
goto :usage

:start
where latexmk >nul 2>nul
if errorlevel 1 (
    echo ERROR: latexmk was not found. Install TeX Live and check PATH.
    exit /b 1
)
pushd "%~dp0"
if errorlevel 1 exit /b 1
if not exist "build\" mkdir "build"
if errorlevel 1 goto :failed
if /i "%~1"=="clean" goto :clean
call latexmk -norc -r latexmkrc main.tex
if errorlevel 1 goto :failed
goto :success

:clean
call latexmk -norc -r latexmkrc -C main.tex
if errorlevel 1 goto :failed
del /f /s /q "build\*" >nul 2>nul

:success
popd
exit /b 0

:failed
echo ERROR: Build operation failed.
popd
exit /b 1

:usage
echo Usage: build.cmd [pdf^|clean]
exit /b 2
