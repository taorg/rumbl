exports.config = {
    // See http://brunch.io/#documentation for docs.
    files: {
        javascripts: {
            joinTo: {
                "js/app.js": /(web\/static\/js)|(node_modules)/,
                //"js/uppy.js": ["web/static/vendor/uppy/dist_0.15/uppy.min.js"],
                "js/uppy.js": ["node_modules/uppy/dist/uppy.min.js"],
                "js/material-datetime-picker.js": [
                    //"web/static/vendor/material-datetime-picker/confirmClearDateFlatpickr.js",
                    "web/static/vendor/material-datetime-picker/fuse.js",
                    "web/static/vendor/material-datetime-picker/fuseAutocomplete.js",
                    //"web/static/vendor/material-datetime-picker/bundle-leaflet-geosearch.js",
                    //"web/static/vendor/material-datetime-picker/material-datetime-picker.js",
                ],

            },
            //order: {
            //    after: ["node_modules/uppy/dist/uppy.min.js"] // concat app.css last
            //}
            // To use a separate vendor.js bundle, specify two files path
            // http://brunch.io/docs/config#-files-
            // joinTo: {
            //  "js/app.js": /^(web\/static\/js)/,
            //  "js/vendor.js": /^(web\/static\/vendor)|(deps)/
            // }
            //
            // To change the order of concatenation of files, explicitly mention here
            // order: {
            //   before: [
            //     "web/static/vendor/js/jquery-2.1.1.js",
            //     "web/static/vendor/js/bootstrap.min.js"
            //   ]
            // }
        },
        stylesheets: {
            joinTo: {
                "css/app.css": /^(web\/static\/css)|(node_modules)/
            },
            order: {
                after: ["web/static/css/app.css"] // concat app.css last
            }
        },
        templates: {
            joinTo: "js/app.js"
        }
    },

    conventions: {
        // This option sets where we should place non-css and non-js assets in.
        // By default, we set this to "/web/static/assets". Files in this directory
        // will be copied to `paths.public`, which is "priv/static" by default.
        assets: /^(web\/static\/assets)|(web\/elm\/elm-stuff)/
    },

    // Phoenix paths configuration
    paths: {
        // Dependencies and current project directories to watch
        watched: [
            "web/static",
            "test/static"
        ],

        // Where to compile files to
        public: "priv/static"
    },
    // Configure your plugins
    plugins: {

        babel: {
            // Do not use ES6 compiler in vendor code
            ignore: [/web\/static\/vendor/, "node_modules/uppy/dist/uppy.min.js"]
                //ignore: [/web\/static\/vendor/]
        },
        sass: {
            mode: "native",
            options: {
                includePaths: ['node_modules/materialize-css/sass']
            }
        }
    },

    modules: {
        autoRequire: {
            "js/app.js": ["web/static/js/app"]
        }
    },

    npm: {
        enabled: true,
        whitelist: ["phoenix", "phoenix_html"],
        styles: {
            "air-datepicker": ["dist/css/datepicker.css"],
            "daterange-picker-ex": ["src/daterangepicker.css"],
            "datetimeranger": ["src/datetimeranger.css"],
            "fine-uploader": ["jquery.fine-uploader/fine-uploader-gallery.css", "jquery.fine-uploader/fine-uploader-new.css"],
            "flatpickr": ["dist/themes/material_green.css"],
            "leaflet-geosearch": ["dist/style.css"],
            "jquery-typeahead": ["src/jquery.typeahead.css"],
            "timedropper-ex": ["src/timedropper.css"],
            "timepicker": ["jquery.timepicker.css"],
            "leaflet": ["dist/leaflet.css"],
            "uppy": ["dist/uppy.css"]
        },
        globals: {
            $: "jquery",
            jQuery: "jquery",
            L: "leaflet",
            moment: "moment",


        },
        static: [
            "node_modules/air-datepicker/dist/js/datepicker.js",
            "node_modules/air-datepicker/dist/js/i18n/datepicker.en.js",
            "node_modules/flatpickr/dist/flatpickr.js",
            //"node_modules/fuse.js/src/fuse.js",
            //"node_modules/flatpickr/dist/plugins/confirmDate/confirmDate.js",
            "node_modules/timepicker/jquery.timepicker.js",
            "node_modules/daterange-picker-ex/src/jquery.daterangepicker.js",
            "node_modules/daterange-picker-ex/src/jquery.daterangepicker.lang.js",
            "node_modules/datetimeranger/src/datetimeranger.js",
            "node_modules/datetimeranger/src/datetimeranger.lang.js",
            "node_modules/materialize-css/bin/materialize.js",
            "node_modules/jquery-typeahead/src/jquery.typeahead.js",
            "node_modules/timedropper-ex/src/timedropper.js",
            "node_modules/timedropper-ex/src/timedropper.lang.js",
            "node_modules/fine-uploader/jquery.fine-uploader/jquery.fine-uploader.js",
            "node_modules/uppy/dist/uppy.min.js"

        ]
    }
};