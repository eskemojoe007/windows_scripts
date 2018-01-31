@Echo off
echo Disabling the "Local Area Connection 5"
netsh interface set interface "Local Area Connection 5" admin=disable
set /P dummy=All done.  Press any key to terminate program...
