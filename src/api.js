const riot = require('riot');
const API_URL = 'https://www.reddit.com/';
const api = riot.observable();

api.getSubreddit = subreddit => {
  return fetch(API_URL + `r/${subreddit}.json`)
    .then(res => res.json())
    .then(res =>
      api.trigger('getSubreddit', res.data.children.map(c => c.data))
    );
};

api.getPost = postId => {
  return fetch(API_URL + `by_id/t3_${postId}.json`)
    .then(res => res.json())
    .then(res => api.trigger('getPost', res.data.children[0].data));
};

api.getPostComments = (subreddit, postId) => {
  return fetch(API_URL + `r/${subreddit}/comments/${postId}.json?depth=100`)
    .then(res => res.json())
    .then(res =>
      api.trigger('getPostComments', {
        post: res[0].data.children[0].data,
        comments: res[1].data.children
      })
    );
};

module.exports = api;
