rd /S /Q web

xcopy img\*.* web\img\ /e /i
xcopy styles\*.* web\styles\ /e /i
xcopy index.html web\
xcopy favicon.ico web\

elm make src\Main.elm --output=elm.js
move elm.js web\
