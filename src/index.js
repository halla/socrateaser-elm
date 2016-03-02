'use strict';

require('./styles/style.css')

require('./index.html');

var Elm = require('./Main.elm')
var mountElem = document.getElementById('main');

var app = Elm.embed(Elm.Main, mountElem);

var interop = require('./interop.js')

app.ports.chatMsg.subscribe(interop.chatMsg);
