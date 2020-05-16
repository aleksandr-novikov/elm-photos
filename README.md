# elm-photos

Instagram-like photos application in Elm.

How to run on Mac:
```shell script
brew install elm
elm install
elm make src/Photos.elm --output dist/build.js
open ./index.html
```

Websocket test messages:
{"id":4,"url":"https://a-novikov.surge.sh/4.jpg","caption":"Tree Canopy","liked":false,"comments":[],"username":"sude"}
{"id":5,"url":"https://a-novikov.surge.sh/5.jpg","caption":"Contemplation","liked":false,"comments":[],"username":"aleks"}
{"id":6,"url":"https://a-novikov.sh/6.jpg","caption":"Pretty Flowers","liked":false,"comments":[],"username":"dude"}
