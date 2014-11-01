var glob = require('glob'),
    handlebars = require('handlebars') ,
    fs = require('fs'),
    theme_info_default,
    theme_info,
    template;


function LoadTemplate (callback) {
    fs.readFile('template/theme.lua', {
        encoding: 'utf8',
    }, function (err, data) {
        if (err)
            throw err;

        callback(handlebars.compile(data));
    });
}


function LoadDefaultThemeData (callback) {
    fs.readFile('theme-data-default.json', {
        encoding: 'utf8',
    }, function (err, data_default) {
        if (err)
            throw err;

        callback(JSON.parse(data_default));
    });
}

LoadTemplate(function (template1) {
    template = template1;

    LoadDefaultThemeData(function (theme_info_default1) {
        theme_info_default = theme_info_default1;

        glob('themes/*/theme-data.json', {}, function (er, files) {
            for (var i = 0; i < files.length; i++) {
                ProcessThemedata(files[i], function (theme_info) {
                    console.log('theme_info', template(theme_info));
                });
            }
        });
    });
});

function ProcessThemedata (filename, callback) {
    fs.readFile(filename, {
        encoding: 'utf8',
    }, function (err, data) {
        if (err)
            throw err;

        theme_info = JSON.parse(data);

        for (var attrname in theme_info_default)
            if (typeof theme_info[attrname] === 'undefined')
                theme_info[attrname] = theme_info_default[attrname];

        callback(theme_info);
    });
}



//
// var data = { 'name': 'Alan', 'hometown': 'Somewhere, TX',
//              'kids': [{'name': 'Jimmy', 'age': '12'}, {'name': 'Sally', 'age': '4'}]};
// var result = template(data);

// console.log(result);