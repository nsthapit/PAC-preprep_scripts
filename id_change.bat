@echo off
setlocal

rem Display help if no arguments are provided or if the first argument is /? or -h
if "%1"=="" (
    goto :help
) else if /I "%1"=="/?" (
    goto :help
) else if /I "%1"=="-h" (
    goto :help
)

set action=%1
if /i "%action%"=="rename"  (
    set /p newname=New Machine Name: 
)

if /i "%action%"=="all"  (
    set /p newname=New Machine Name: 
)

if /i "%action%"=="rename"  (
    if not "%newname%"=="" (
        echo "Renaming Computer to %newname%."
        REM You can uncomment the following lines to actually perform the renaming

        powershell -Command Rename-Computer -NewName %newname%
        shutdown /r /t 0
    ) else (
        echo "Error: New machine name is not provided."
    )
) else if /i "%action%"=="ncentral" (
    echo "Resetting Ncentral IDs"
    REM You can uncomment the following line to actually reset Ncentral IDs

    .\NcentralAssetTool.exe -t
) else if /i "%action%"=="all" (
    
    if not "%newname%"=="" (
        echo "Renaming Computer to %newname% and resetting Ncentral ID."
        
        REM You can uncomment the following lines to actually perform the renaming

        .\NcentralAssetTool.exe -t
        powershell -Command Rename-Computer -NewName %newname%
        shutdown /r /t 0
    ) else (
        echo "Error: New machine name is not provided."
    )
    
) else (
    echo "Invalid action. Please provide 'rename' or 'ncentral' as an argument."
)

endlocal

exit /b

:help
echo Usage: mybatchfile.bat [option]
echo.
echo Options:
echo   rename - Rename computer only
echo   ncentral - Reset Ncentral ID only
echo   all - Rename computer and reset Ncentral ID
echo.
echo Example:
echo   mybatchfile.bat all
echo.
exit /b