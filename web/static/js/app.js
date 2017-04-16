// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import socket from "./socket"
import "moment"
import "fuse.js"

//import MaterialDatePicker from "./material-datetime-picker.js"
import "dropify"
import "jquery.filer"
import "fine-uploader"
import "dropzone"
import bootstrapMaterialDatePicker from "./bootstrap-material-datetimepicker.js"
import "leaflet"


/*
import { Core, Dashboard, GoogleDrive, Webcam, Tus10, MetaData, Informer } from 'uppy'

window.Core = Core;

import "uppy"
import { Core, Dashboard, GoogleDrive, Webcam, Tus10, MetaData, Informer } from "uppy"

const Uppy = require('./uppy/lib/core')
const Dashboard = require('./uppy/lib/plugins/Dashboard')
const GoogleDrive = require('./uppy/lib/plugins/GoogleDrive')
const Dropbox = require('./uppy/lib/plugins/Dropbox')
const Webcam = require('./uppy/lib/plugins/Webcam')
const Tus10 = require('./uppy/lib/plugins/Tus10')
const MetaData = require('./uppy/lib/plugins/MetaData')
const Informer = require('./uppy/lib/plugins/Informer')
*/
//import MaterialDatetimePicker from "./material-datetime-picker.js"
// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

//import Elm from './rumblelm';
//window.Elm = Elm;