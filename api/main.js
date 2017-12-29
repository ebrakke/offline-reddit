const restify = require('restify');
const request = require('request');
const corsMiddleware = require('restify-cors-middleware');
const uuid4 = require('uuid/v4');
const config = require('./config.json');

const authenticate = (req, res, next) => {
  const authEndpoint = 'https://www.reddit.com/api/v1/access_token';
  request
    .post(
      authEndpoint,
      {
        form: { grant_type: 'client_credentials', device_id: uuid4() }
      },
      (err, response, body) => {
        res.json({ accessToken: JSON.parse(body).access_token });
      }
    )
    .auth(process.env.CLIENT_ID, process.env.CLIENT_SECRET);
};

const cors = corsMiddleware({
  origins: ['http://localhost:5000']
});

const server = restify.createServer();
server.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'X-Requested-With');
  return next();
});
server.get('/auth', authenticate);

server.listen(3000);
