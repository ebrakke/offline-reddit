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
    <div class="col-sm-12">
      <h3>{post.title}</h3>
      <p>{post.author}</p>
      <p>{post.selftext}</p>
      <button class="btn btn-info" onclick={hide_children}>{hide_all_children ? 'Show Children' : 'Hide children'}</button>
    </div>
    <div class="col-sm-12">
      <app-comments comments={comments} post_fullname={post.name} hide_all_children={hide_all_children}/>
    </div>
  </div>

  <script>
    const api = require('../api');
    this.on('route', (subreddit, postId) => {
      api.getPostComments(subreddit, postId)
    })
    this.hide_all_children = false

    this.hide_children = () => {this.hide_all_children = !this.hide_all_children }

    api.on('getPostComments', ({post, comments}) => {
      this.post = post;
      this.comments = comments;
      this.update();
    })
  </script>
</app-post>

<app-comment>
  <li if={!(comment.kind === 'more')} class="container-fluid">
    <p>{comment.data.author} - <span class="text-success">{comment.data.score}</span></p>
    <p onclick={toggle}><raw content={comment.data.body_html}/></p>
    <hr/ >
    <app-comments hide_all_children={opts.hide_all_children} show={show_replies} if={comment.data.replies} comments={comment.data.replies.data.children} post_fullname={opts.post_fullname} nest={opts.nest + 1}/>
  </li>

  <li if={comment.kind === 'more' && !loaded_more} class="container-fluid">
    <a onclick={load_more}>Load More ({comment.data.count})</a>
    <hr />
  </li>

  <li show={loaded_more} class="container-fluid">
    <app-comments comments={loaded_comments} hide_all_children={opts.hide_all_children} post_fullname={opts.post_fullname} nest={opts.nest + 1}/>
  </li>

  <style>
    app-comment {
      padding-bottom: 5px;
    }
  </style>
  
  <script>
    const api = require('../api')
    this.comment = opts.comment
    this.show_replies = !opts.hide_all_children
    
    this.toggle = function(e) {
      // Don't toggle if they're clicking on a link in the page
      if (e.target.tagName == 'A') {
        return
      }
      this.show_replies = !this.show_replies
    }

    this.load_more = function() {
      api.getMoreComments(this.opts.post_fullname, this.comment.data.name, this.comment.data.children)
    }

    api.on(`getMoreComments-${this.comment.data.name}`, ({moreId, comments}) => {
      this.loaded_more = true
      this.loaded_comments = comments
      this.update();
    } )
  </script>
</app-comment>

<app-comments>
  <ul class="list-unstyled">
    <app-comment post_fullname={parent.opts.post_fullname} each={comment in opts.comments} comment={comment} hide_all_children={opts.hide_all_children}/>
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

<raw>
  <span></span>

  <script>
    this.root.innerHTML = $('<div />', {html: opts.content}).text()
    this.on('update', () => { this.root.innerHTML = $('<div />', {html: opts.content}).text() })
  </script>
</raw>
