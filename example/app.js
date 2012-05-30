// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

// TODO: write your module tests here
var TiCookies = require('be.k0suke.ticookies');
Ti.API.info("module is => " + TiCookies);

// create cookie
TiCookies.createCookie({
	domain: '.example.com',
	name: 'NAME',
	value: 'VALUE',
	path: '/',	// optional, default '/'
	expire: '0'	// optional, default '0'
});

// remove cookies
TiCookies.removeCookies({
	domain: '*',	// '*' is all domains, '.example.com' etc...
	name: 'NAME'	// optional
});

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var webView = Ti.UI.createWebView({
	url: 'https://www.google.com/'
});
win.add(webView);

webView.addEventListener('load', function(){
	// get all cookies in array
	var cookies = TiCookies.getCookies();
	cookies.forEach(function(cookie){
		Ti.API.info(cookie);
	});
});

win.open();
