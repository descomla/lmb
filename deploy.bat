rd /S /Q C:\wamp64\www\lmb\img
rd /S /Q C:\wamp64\www\lmb\styles
del /F /Q C:\wamp64\www\lmb\*.*

xcopy img C:\wamp64\www\lmb\img\ /e /i
xcopy styles C:\wamp64\www\lmb\styles\ /e /i

xcopy index.html C:\wamp64\www\lmb\
xcopy elm.js C:\wamp64\www\lmb\
move elm.js web\
