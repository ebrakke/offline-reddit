<app>
  <app-global-nav></app-global-nav>
  <router>
    <route path="/subreddit/*/*"><app-post /></route>
    <route path="/subreddit/*"><app-subreddit/></route>
    <route path="/">
      <home />
    </route>
  </router>
</app>

<app-home>
  <p> Welcome!</p>
</app-home>

<app-subreddit>
  <div class="row">
    <app-posts if={posts.length} posts={posts}/>
  </div>

  <script>
    const api = require('../api')
    this.posts = []

    this.on('route', (subreddit) => {
      api.getSubreddit(subreddit)
    })

    api.on('getSubreddit', posts => {
      this.posts = posts
      this.update()
    })
  </script> 
</app-subreddit>

<app-post>
  <p if={!post}>Loading...</p>
  <div if={post} class="row">
    <div class="col-12">
      <h3>{post.title}</h3>
      <p>{post.author}</p>
    </div>
    <div class="col-12">
      <app-comments comments={comments}/>
    </div>
  </div>

  <script>
    const api = require('../api');
    this.on('route', (subreddit, postId) => {
      api.getPostComments(subreddit, postId)
    })

    api.on('getPostComments', ({post, comments}) => {
      this.post = post;
      this.comments = comments;
      this.update();
    })
  </script>
</app-post>

<app-comment>
  <li if={!(comment.kind === 'more')} class="container-fluid">
    <p>{comment.data.author} - {comment.data.ups}:{comment.data.downs}</p>
    <p onclick={toggle}>{comment.data.body}</p>
    <ul if={comment.data.replies && show_replies} class="list-unstyled">
      <app-comment each={reply in comment.data.replies.data.children} comment={reply}/>
    </ul>
  </li>

  <li if={comment.kind === 'more'} class="container-fluid">
    <a onclick={load_more}>Load More ({comment.data.count})</a>
    <p>{comment.data.id}</p>
  </li>

  <style>
    app-comment {
      padding-bottom: 5px;
    }
  </style>
  
  <script>
    this.comment = opts.comment
    this.show_replies = true
    
    this.toggle = function() {
      this.show_replies = !this.show_replies
    }

    this.load_more = function() {

    }
  </script>
</app-comment>

<app-comments>
  <ul class="list-unstyled">
    <app-comment each={comment in opts.comments} comment={comment}/>
  </ul>

  <script>
  </script>
</app-comments>

<app-post-list-item>
  <li onclick={onPostClick}>
    <h3>{title}</h3>
    <p>{author}</p>
  </li>

  <script>
    const route = require('riot-route/tag')
    this.onPostClick = () => {
      route(`/subreddit/${this.subreddit}/${this.id}/`)
    }
  </script>
</app-post-list-item>

<app-posts>
  <div class="col-12">
    <ul class="list-unstyled">
      <app-post-list-item each={opts.posts}></app-post-list-item>
    </ul>
  </div>
</app-posts>

<app-global-nav>
  <div class="global-nav row">
    <div class="col-12">
      <p class="text-center">Text Reddit<p>
    </div>
  </div> 

  <style>
    .global-nav {
      padding: 20px;
      background-color: #c7c7c7;
    }
  </style>
</app-global-nav>
