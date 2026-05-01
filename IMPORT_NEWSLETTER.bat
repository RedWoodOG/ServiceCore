@echo off
REM Newsletter Import Batch Script
REM This script imports the newsletter PDF into the company feed
REM
REM Usage:
REM   IMPORT_NEWSLETTER.bat
REM   IMPORT_NEWSLETTER.bat "C:\path\to\newsletter.pdf"

setlocal

REM Get PDF path from argument or use default
if "%~1"=="" (
    set PDF_PATH=C:\Users\jwhit\Downloads\2026 January Newsletter .pdf
) else (
    set PDF_PATH=%~1
)

echo Importing newsletter from: %PDF_PATH%
echo.

REM Run the Dart import script with proper argument parsing
dart run lib/scripts/import_newsletter.dart --pdf-path "%PDF_PATH%"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Import failed. Check the error messages above.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo Import completed successfully!
pause
