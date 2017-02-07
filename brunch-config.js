exports.config = {
    // See http://brunch.io/#documentation for docs.
    files: {
        javascripts: {
            joinTo: {
                "js/app.js": /^(web\/static\/js)|(node_modules)/


                //"js/materialize.js": ["web/static/vendor/materialize/materialize.js"
            }

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
        assets: /^(web\/static\/assets)/
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
            ignore: [/web\/static\/vendor/]
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
        styles: {
            "air-datepicker": ["dist/css/datepicker.css"],
            "daterange-picker-ex": ["src/daterangepicker.css"],
            "datetimeranger": ["src/datetimeranger.css"],
            "dropify": ["dist/css/dropify.css"],
            "fine-uploader": ["jquery.fine-uploader/fine-uploader-gallery.css", "jquery.fine-uploader/fine-uploader-new.css", "jquery.fine-uploader/fine-uploader.css"],
            "flatpickr": ["dist/flatpickr.css"],
            "jquery.filer": ["css/themes/jquery.filer-dragdropbox-theme.css", "css/jquery.filer.css", "assets/fonts/jquery.filer-icons/jquery-filer.css"],
            "timedropper-ex": ["src/timedropper.css"],
            "timepicker": ["jquery.timepicker.css"]


        },
        globals: {
            $: "jquery",
            jQuery: "jquery",
            moment: "moment",
            Dropzone: "dropzone"
        },
        static: [
            "node_modules/air-datepicker/dist/js/datepicker.js",
            "node_modules/air-datepicker/dist/js/i18n/datepicker.en.js",
            "node_modules/flatpickr/dist/flatpickr.js",
            "node_modules/timepicker/jquery.timepicker.js",
            "node_modules/daterange-picker-ex/src/jquery.daterangepicker.js",
            "node_modules/daterange-picker-ex/src/jquery.daterangepicker.lang.js",
            "node_modules/datetimeranger/src/datetimeranger.js",
            "node_modules/datetimeranger/src/datetimeranger.lang.js",
            "node_modules/materialize-css/bin/materialize.js",
            "node_modules/timedropper-ex/src/timedropper.js",
            "node_modules/timedropper-ex/src/timedropper.lang.js",
            "node_modules/fine-uploader/jquery.fine-uploader/jquery.fine-uploader.js"
        ]
    }
};