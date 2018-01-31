@Echo off
SETLOCAL ENABLEEXTENSIONS
SET me=%~n0
SET parent=%~dp0

rem --------------------------------------------------------
rem                 toggleProxy.bat
rem --------------------------------------------------------
REM This file is used to toggle the proxy settings for some of the dev tools
REM used depending if you are on the GE network or not.


REM --------------------------------
REM  User input variables
REM --------------------------------

REM Set the root path...probably don't change
set ROOT=%HOMEDRIVE%%HOMEPATH%

REM Proxy address, may need to be updated in the future when
REM   ge changes things
set proxy=http://PITC-Zscaler-Americas-Alpharetta3PR.proxy.corporate.ge.com:80

REM File list with spaces that you need commented or uncommented
REM  If just using conda, you only need .condarc .  But I have
REM  I have other tools that need the same treatment
set files=%ROOT%\.condarc %ROOT%\.npmrc %ROOT%\.atom\.apmrc

REM Check to see the current status of the proxyOn variable...
REM this is where we store whether the proxy is on or off
REM Proxy is turned on if proxyOn==1, off if proxyOn==0
if /I %proxyOn%==1 (
    REM If the proxy was on...we want to turn it off
    echo Proxy was on...turning it off

    REM Clear the HTTP_PROXY and HTTPS_PROXY env variables
    echo Removing HTTP_PROXY and HTTPS_PROXY variables
    REG delete HKCU\Environment /F /V HTTP_PROXY >nul 2>&1
    REG delete HKCU\Environment /F /V HTTPS_PROXY >nul 2>&1

    REM Turning off the proxy, we need to comment the rc files
    echo Commenting files: %files%
    sed -i "s/^/;/" %files%

    REM Toggle the prxoy key
    echo Toggling proxyOn env variable
    setx proxyOn 0 >nul 2>&1
) ELSE (
    REM Proxy is off...turn it on
    echo Proxy was off...turning it on

    REM Set the HTTP_PROXY and HTTPS_PROXY variables
    echo Setting HTTP_PROXY and HTTPS_PROXY variables
    setx HTTP_PROXY %proxy% >nul 2>&1
    setx HTTPS_PROXY %proxy% >nul 2>&1

    REM Comment the rc files to disable the proxy
    echo UnCommenting files: %files%
    sed -i "s/;//" %files%

    REM Toggle the proxy key
    echo Toggling proxyOn env variable
    setx proxyOn 1 >nul 2>&1
)

REM Let user end script
echo.
set /P dummy=All done.  Press any key to terminate program...
