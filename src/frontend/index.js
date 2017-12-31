const riot = require('riot');
const route = require('riot-route/tag');
const app = require('./tags/app.tag');
const api = require('./api');
const auth = require('./auth');

const start = token => {
  api.setAuthHeader(token);
  riot.mount(app);
  route.base('/');
  route.start(true);
};

if (localStorage.getItem('accessToken')) {
  start(localStorage.getItem('accessToken'));
} else {
  auth.getAccessToken();
}

auth.on('getAccessToken', token => {
  localStorage.setItem('accessToken', token);
  start(token);
});

// if ('serviceWorker' in navigator) {
//   window.addEventListener('load', function() {
//     navigator.serviceWorker.register('./sw.js', { scope: '/' }).then(
//       function(registration) {
//         // Registration was successful
//         console.log(
//           'ServiceWorker registration successful with scope: ',
//           registration.scope
//         );
//       },
//       function(err) {
//         // registration failed :(
//         console.log('ServiceWorker registration failed: ', err);
//       }
//     );
//   });
// }
