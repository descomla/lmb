rd /S /Q web

mkdir web
xcopy img web\img\ /e /i
xcopy styles web\styles\ /e /i

elm-package install
elm-make src\MainLocal.elm --output=elm.js

xcopy index.html web\
xcopy elm.js web\
