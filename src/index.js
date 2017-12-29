const riot = require('riot');
const route = require('riot-route/tag');
const app = require('./tags/app.tag');

riot.mount(app);
route.base('/');
route.start(true);
