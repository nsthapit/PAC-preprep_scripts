@echo off

rem Display help if no arguments are provided or if the first argument is /? or -h
if "%1"=="" (
    goto :help
) else if /I "%1"=="/?" (
    goto :help
) else if /I "%1"=="-h" (
    goto :help
)

rem Check the value of the first argument
if "%1"=="ncentral" (
    echo Installing Ncentral only.
    
    .\100WindowsAgentSetup_VALID_UNTIL_2024_09_18.exe /quiet
    
) else if "%1"=="sid" (
    echo Doing SID Change.
    .\sidchgl64-3.0j.exe -KEY=7qrd3-Knjfx-iC5dq-sf /F /S
    
) else if "%1"=="all" (
    echo Install Ncentral and SID Change.
    .\100WindowsAgentSetup_VALID_UNTIL_2024_09_18.exe /quiet
    .\sidchgl64-3.0j.exe -KEY=7qrd3-Knjfx-iC5dq-sf /F /S
    
) else (
    echo Invalid option.
    goto end
)

exit /b

:help
echo Usage: mybatchfile.bat [option]
echo.
echo Options:
echo   ncentral - Install Ncentral only
echo   sid - Change machine SID only
echo   all - Install Ncentral and change machine SID
echo.
echo Example:
echo   mybatchfile.bat all
echo.
exit /b