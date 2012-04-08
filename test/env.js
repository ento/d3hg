var jsdom = require("jsdom");
document = jsdom.jsdom("<html><head></head><body></body></html>", null, {features: {QuerySelector: true}});

window = document.createWindow();
navigator = window.navigator;
CSSStyleDeclaration = window.CSSStyleDeclaration;

require("./env-fragment");

require('../node_modules/d3/d3.v2');

exports.d3hg = require('../d3hg').d3hg;
