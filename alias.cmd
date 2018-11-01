@echo off
:: https://stackoverflow.com/questions/20530996/aliases-in-windows-command-prompt

:: Commands
DOSKEY prp=pipenv run python $*
DOSKEY pri=pipenv run ipython $*
DOSKEY prs=pipenv run shell
DOSKEY alias=atom %USERPROFILE%\Documents\GitHub\windows_scripts\alias.cmd

:: Common directories
DOSKEY cd_github=cd "%USERPROFILE%\Documents\GitHub\$*"
