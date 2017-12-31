const riot = require('riot');
const AUTH_URL = 'https://offline-reddit.herokuapp.com/api/auth';
// const AUTH_URL = 'http://localhost:3000/api/auth';

const auth = riot.observable();

auth.getAccessToken = () => {
  return fetch(AUTH_URL)
    .then(res => res.json())
    .then(res => auth.trigger('getAccessToken', res.accessToken));
};

module.exports = auth;
