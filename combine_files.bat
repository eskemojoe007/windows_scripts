@Echo off
rem --------------------------------------------------------
rem                 combine_files.bat
rem --------------------------------------------------------
REM This file appends multiple files using the built in windows
REM copy /b and a list of the file names and outputs it to the user defined
REM variable of output.<last_extension>
REM Files are dragged onto this script


REM --------------------------------
REM  User input variables
REM --------------------------------
set output=output



REM Check to see if we have any inputs...if we don't skip everything
if [%1]==[] goto :done

REM --------------------------------
REM Loop through all the dragged files
REM --------------------------------
@echo.
@echo You input the following files:
set n=0
set var=""
:loop

rem Output each file
@echo %~dpn1%~x1

rem add fn to string
if %n%==0 (
    set var="%~dpn1%~x1"
) else (
    set var=%var%+"%~dpn1%~x1"
)

rem store the extension...last one we'll use
set ext=%~x1

rem get the next input file
shift
set /a n+=1
if not [%1]==[] goto loop

REM --------------------------------
REM Now save and combine the files
REM --------------------------------

REM @echo string is: %var%
@echo.
@echo saving file to:   %output%%ext%
@echo ---------------------------------
@echo "windows copy /b output"
@echo ---------------------------------

copy /b %var% %output%%ext%

:done
echo.
set /P dummy=All done.  Press any key to terminate program...
