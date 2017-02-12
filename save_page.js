var page = new WebPage()
var fs = require('fs');

page.onLoadFinished = function() {
    fs.write('processed.html', page.content, 'w');
    phantom.exit();
};

page.open(###REPLACE###/youtube, function() {
    page.evaluate(function() {
    });
});
