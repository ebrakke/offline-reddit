const riot = require('riot');
const auth = require('./auth');
const API_URL = 'https://oauth.reddit.com/';
const api = riot.observable();

api.setAuthHeader = token => {
  api.bearerToken = token;
};

api.getSubreddit = subreddit => {
  return fetch(API_URL + `r/${subreddit}.json`, {
    headers: { Authorization: `Bearer ${api.bearerToken}` }
  })
    .then(handleError)
    .then(res => res.json())
    .then(res =>
      api.trigger('getSubreddit', res.data.children.map(c => c.data))
    );
};

api.getPost = postId => {
  return fetch(API_URL + `by_id/t3_${postId}.json`, {
    headers: { Authorization: `Bearer ${api.bearerToken}` }
  })
    .then(handleError)
    .then(res => res.json())
    .then(res => api.trigger('getPost', res.data.children[0].data));
};

api.getPostComments = (subreddit, postId, sort = 'top') => {
  return fetch(
    API_URL + `r/${subreddit}/comments/${postId}.json?sort=${sort}`,
    {
      headers: { Authorization: `Bearer ${api.bearerToken}` }
    }
  )
    .then(handleError)
    .then(res => res.json())
    .then(res =>
      api.trigger('getPostComments', {
        post: res[0].data.children[0].data,
        comments: res[1].data.children
      })
    );
};

api.getMoreComments = (linkId, moreId, children, sort = 'top') => {
  return fetch(
    API_URL +
      `api/morechildren?api_type=json&limit_children=false&link_id=${linkId}&sort=${sort}&children=${children.join()}`,
    {
      method: 'GET',
      headers: { Authorization: `Bearer ${api.bearerToken}` }
    }
  )
    .then(handleError)
    .then(res => res.json())
    .then(res =>
      api.trigger(`getMoreComments-${moreId}`, {
        moreId,
        comments: res.json.data.things
      })
    );
};

function handleError(res) {
  if (res.status == 401) {
    handle401Error();
    throw new Error('Unauthorized');
  }
  return res;
}

function handle401Error() {
  localStorage.clear();
  auth.getAccessToken();
}

module.exports = api;
