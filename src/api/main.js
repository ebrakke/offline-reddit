const express = require('express');
const request = require('request');
const uuid4 = require('uuid/v4');
const cors = require('cors');
const fallback = require('express-history-api-fallback');

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

const app = express();
app.use(cors());
app.use(express.static(__dirname + '/public'));
app.get('/api/auth', authenticate);
app.use('/', express.static(__dirname + '/public'));
app.use(fallback('index.html', { root: `${__dirname}/public` }));

const port = process.env.PORT || 3000;
const host = process.env.HOST || 'localhost';
app.listen(port, host, () => {
  console.log('server listening at port ' + port);
});
