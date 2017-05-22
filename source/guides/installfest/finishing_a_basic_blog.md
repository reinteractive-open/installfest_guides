---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/finishing_a_basic_blog.md
---

# Finishing a Basic Blog
In the [first guide](/guides/installfest/getting_started) you built a simple blogging engine using Rails and published it up on [Heroku](https://www.heroku.com). If you haven't run through that post then you should do so now before starting this one. In this installment, together, we'll add some features to your blogging engine, show you more about Rails and make it look nicer using [Bootstrap](http://getbootstrap.com/). Let's dive in.

## Preparation for our coding session

First we want to start our Rails server, so open two terminals and change to the directory we're developing our app in. In one of our terminals start the Rails server with `rails s` (s is short for server). Next start Sublime Text and open the folder that your app is stored in. By doing this you get to see the directory structure of Rails in the sidebar so you'll be able to navigate around your project a little more easily.

![image](/images/guides/sublime_folder.png)

## AJAX commenting with unobtrusive JavaScript

The blogging engine we've got works great, but it definitely doesn't feel like a smooth, modern web-app. Luckily with Rails it's easy to add in simple JavaScript! Just like all the other helpers that Rails provides if this isn't powerful enough for your needs you can always add as much custom JavaScript into `app/assets/javascripts/` as you like.

What you'll be doing is adding in some functionality to the commenting system so that posting a comment doesn't require a page reload. This means that we'll be submitting our comments using [AJAX](https://en.wikipedia.org/wiki/Ajax_(programming)) and then rendering the comments onto the post page using JavaScript. First we'll tackle posting the form using AJAX.

#### Making the form submit via AJAX

Open `app/views/posts/show.html.erb` and add a `remote: true` option to the `form_for` method call. Your show view should look like:

```erb
<p id="notice"><%= notice %></p>

<%= render partial: @post %>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>

<h2>Comments</h2>
<div id="comments">
  <%= render partial: @post.comments %>
</div>

<%= form_for [@post, Comment.new], remote: true do |f| %>
  <p>
    <%= f.label :body, "New comment" %><br/>
    <%= f.text_area :body %>
  </p>
  <p><%= f.submit "Add comment" %></p>
<% end %>
```

(Don't forget to save your file.)

Adding that remote flag to the method call means that Rails will automatically set up the form to be submitted via AJAX.

If you refresh the [post view page](http://localhost:3000/posts/1) and try to submit a comment you'll notice that nothing happens. However if you switch to the terminal running your Rails server you'll be able to see that the request was received by the server, it's just doing the wrong thing with that request.

```ruby
Started POST "/posts/1/comments" for 127.0.0.1 at 2013-04-23 11:24:09 +1000
Processing by CommentsController#create as JS
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"7LoEUBBCMxTBpHrno9DiLO80itbBagHKsiTmAbhODJ0=", "comment"=>{"body"=>"Test comment"}, "commit"=>"Add comment", "post_id"=>"1"}
  Post Load (0.1ms)  SELECT "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT 1  [["id", "1"]]
   (0.0ms)  begin transaction
  SQL (4.8ms)  INSERT INTO "comments" ("body", "created_at", "post_id", "updated_at")
VALUES (?, ?, ?, ?)  [["body", "Test comment"], ["created_at", Tue, 23 Apr 2013 01:24:09 UTC +00:00], ["post_id", 1], ["updated_at", Tue, 23 Apr 2013 01:24:09 UTC +00:00]]
   (0.9ms)  commit transaction
Redirected to http://localhost:3000/posts/1
```

The last line of the log here indicated that the server redirected to `/posts/1` as the response. We don't want that behaviour for an AJAX call.

#### Setting up the server to process AJAX requests

Let's fix that by making our 'create comment' action aware of JavaScript AJAX requests.
First we need to add the responders gem to our Gemfile.

Open the `Gemfile` and make your `Gemfile` look like:

```ruby
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: [:development, :test]
gem 'pg', group: :production
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'record_tag_helper', '~> 1.0'
gem 'responders'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

(Don't forget to save your file.)

Return to your command prompt and run the following command to update our gems:

```
bundle install
```

Open `app/controllers/comments_controller.rb` and change the create
method to respond to AJAX requests as follows:

```ruby
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(comment_params)
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
```

(Don't forget to save your file.)

What this means is that your app will respond to regular HTML requests in the same way as before (by redirecting to the url of the post) but will render a view when receiving a JS request. This view doesn't exist yet so you'll need to create it now.

Create a new file `app/views/comments/create.js.erb`. This is a Javascript file that will be returned to the browser and executed. We want it to do two things: Insert the comment html into the document, and clear the comment form. Your `create.js.erb` file should look like:

```js
$('#comments').append('<%= escape_javascript(render partial: @comment) %>');
$('#comment_body').val('')
```

(Don't forget to save your file.)

Now when you submit a comment, you'll see the comment appear immediately in the section above the form and the comment field will be cleared. One cool thing about the approach you've learned here is that everything will continue to work even if a browser has JavaScript disabled.

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git add .
git commit -m "comments can be submitted via ajax"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able to navigate to your blog on Heroku now to see the changes you've made.

## Creating an RSS Atom feed

The next feature on our list is to implement an RSS Atom feed. Once again Rails makes this job pretty simple. We'll be outputting our list of posts in an Atom format rather than a HTML format. If you open `app/controllers/posts_controller.rb` you might notice that already the index method will respond to the JSON format. We can see this in action by going to: [http://localhost:3000/posts.json](http://localhost:3000/posts.json). You'll see all your posts rendered in JSON format.

#### Making the server Atom aware

Our first job is to get the same behaviour but render the posts in Atom format.
Update your index action so it looks like:

```ruby
  # GET /posts
  # GET /posts.json
  # GET /posts.atom
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.atom
    end
  end
```

(Don't forget to save your file.)

If you go to [http://localhost:3000/posts.atom](http://localhost:3000/posts.atom) you'll receive an error that the template is missing.

![template missing error](/images/guides/missing_template.png)

#### Building the Atom feed

This just means we need to create it. We'll be creating a file called: `app/views/posts/index.atom.builder` and putting the following contents into that file:

```ruby
atom_feed do |feed|
  feed.title "InstallFest Quick Blog"
  feed.updated @posts.first.updated_at

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title post.title
      entry.content post.body, type: 'html'

      entry.author do |author|
        author.name 'Installfest Attendee'
      end
    end
  end
end
```

(Don't forget to save your file.)

You might want to customise your ATOM feed by changing the name of the blog, or by changing the author name to your own. Refresh the [http://localhost:3000/posts.atom](http://localhost:3000/posts.atom) page and you'll see the XML being returned properly.

#### RSS feed discovery

Our next job is to publicise the ATOM feed so that RSS readers (if they still exist) can easily subscribe. We'll do this by opening `app/views/layouts/application.html.erb` and adding this link tag that will allow some browsers to auto-discover our RSS feed.

```erb
<%= auto_discovery_link_tag(:atom, posts_path(:atom)) %>
```

Your `application.html.erb` file should look like:

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>QuickBlog</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>

    <%= auto_discovery_link_tag(:atom, posts_path(:atom)) %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```

(Don't forget to save your file.)

To test this you might like to temporarily install [this plugin to Google Chrome](https://chrome.google.com/webstore/detail/rss-subscription-extensio/nlbjncdgjeocebhnmkbbbdekmmmcbfjd?hl=en) and reload any page on your blog site. The `application.html.erb` layout file is used to wrap every view in your application. This means that changes made to this file will affect every single page in your application. After you load up any page in your blog you should see an RSS icon in the URL bar. Clicking it will take you to your site's RSS feed.

![rss feed indicator](/images/guides/rss_feed_indicator.png)

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git add .
git commit -m "adding atom feed and autodiscovery"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able to navigate to your blog on Heroku now to see the changes you've made.

## Giving your blog some style

Up until this point we've really neglected the look and feel of our blog. It definitely feels a bit boring! We'll be making it look much nicer by using a UI library called [Bootstrap](http://getbootstrap.com/). Bootstrap is a front-end framework that allows you to make your websites look good quickly and easily.

The first step is to [download Bootstrap](http://getbootstrap.com/getting-started/). Put it in a folder that makes sense to you.

Next, we need to copy the files we require into our rails project. From your bootstrap folder, copy the following:

`css/bootstrap.css` and `css/bootstrap.min.css` to: `app/assets/stylesheets`,

`js/bootstrap.js` and `js/bootstrap.min.js` to: `app/assets/javascripts`,

and

`fonts/` (the folder and it's contents) to `public/assets`. You may need to create an `assets` folder under `public` and then move the `fonts` folder under that.

Open `app/assets/stylesheets/application.css` and add the following line:

`*= require bootstrap.min`

Open `app/assets/javascripts/application.js` and add the following line:

`//= require bootstrap.min`

Open `app/assets/stylesheets/application.css` and add the following lines:

```
@font-face {
   font-family: 'Glyphicons Halflings';
   src: url('/assets/fonts/glyphicons-halflings-regular.eot');
   src: url('/assets/fonts/glyphicons-halflings-regular.eot?#iefix') format('embedded-opentype'),
      url('/assets/fonts/glyphicons-halflings-regular.woff') format('woff'),
      url('/assets/fonts/glyphicons-halflings-regular.ttf') format('truetype'),
      url('/assets/fonts/glyphicons-halflings-regular.svg#glyphicons_halflingsregular') format('svg');
}
```

(Don't forget to save your files.)

One of the signature features of Bootstrap is the grid system. The grid system creates page layouts through a series of rows and columns that houses your content.

The basic rules are that you must have a `.container` within which a `.row` can be placed. Within each `.row`, you specify how many columns you wish to span (there are 12 available columns).

We're going to start off with two very quick things with Bootstrap. We'll give our content some whitespace so it's easier to read, and we'll change all our buttons so that they have a bit more style. First open your layout file `app/views/layouts/application.html.erb` and update it to look like:

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>QuickBlog</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>

    <%= auto_discovery_link_tag(:atom, posts_path(:atom)) %>
  </head>

  <body>
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-10 col-md-8">
          <%= yield %>
        </div>
      </div>
    </div>
  </body>
</html>
```

(Don't forget to save your file.)

You will notice that, apart from wrapping the `yield` statement in various `div`s, we added several different classes to the final enclosing `div`.

* `col-xs-12` means that on an extra-small device (such as a phone), we want whatever text is produced by the `yield` to take up all 12 columns.
* `col-sm-10` means that on a small device (such as a tablet), we want whatever text is produced by the `yield` to take up 10 columns, leaving 2 empty columns.
* `col-md-8` means that on a medium device (such as a laptop), we want whatever text is produced by the `yield` to take up 8 columns, leaving 4 empty columns. Because there is nothing specified for `col-lg-xx` (which would be a desktop computer), these will also fall under this category and have their content restricted to eight columns.

To illustrate the changes we just made, we are going to need a long blog post. The easiest way to create one is go to the [Lorem Ipsum website](http://www.lipsum.com/feed/html) and copy and paste the text it generates. Use this text to create a new blog post.

Once we have the new long post created, return to [your post listings](http://localhost:3000/posts).

If your browser window is expanded (and you are using a laptop or larger), you should observe that the text occupying about three-quarters of the width of the screen. Resize the screen and, as it shrinks, you will see the text bouncing around. First occupying ten-twelfths, and then as it gets very small, the entire width of the screen.

Now open `app/views/posts/index.html.erb` and update it to look like:

```erb
<h1>Listing posts</h1>

<%= render partial: @posts %>

<%= button_to 'New Post', new_post_path, method: :get, class: "btn-primary" %>
```

(Don't forget to save your file.)

We have changed `link_to`, that unobtrusive barely-noticeable link for adding a new post, to `button_to` which will now give us a button. Note: `link_to` and `button_to` are Rails helper methods that saves us writing the corresponding HTML.

If you refresh your [index page](http://localhost:3000/posts), you should now see that our "New Post" link at the bottom of the page, is now a lovely blue button.

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git rm app/assets/stylesheets/scaffolds.scss
git add .
git commit -m "adding bootstrap styling"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able to navigate to your blog on Heroku now to see the changes you've made.

## Adding some personality

Your blog works, it has posts and comments but it doesn't feel like your own. We're going to add in a header and footer which will allow users to navigate a little more easily and will give you the chance to personalise your blog a bit more. In all web pages the header and footer are generally common across all pages, Rails gives us a layout file that lets us make these sorts of changes to every page at once.

First we'll create two files: a header and a footer. Create
`app/views/layouts/_header.html.erb` put the following code in it:

```erb
    <nav class="navbar navbar-inverse navbar-static-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">My Awesome Blog</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
          <ul class="nav navbar-nav navbar-right">
            <li><a href="#">About</a></li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Topics<span class="caret"></span></a>
              <ul class="dropdown-menu">
                <li><a href="#">Books</a></li>
                <li><a href="#">Movies</a></li>
                <li><a href="#">Games</a></li>
              </ul>
            </li>
            <li><a href="#">Contact</a></li>
          </ul>
        </div>
      </div>
    </nav>
```

And then create `app/views/layouts/_footer.html.erb` and put the following code in it:

```erb
<div class="container">
  <footer class="footer">
    <div class="row">
      <div class="col-md-4">
        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
        <h3>My Awesome Blog!</h3>
        <p>Developed at: <%= link_to 'InstallFest 2017', 'http://reinteractive.com/community/installfest' %></p>
      </div>
      <div class="col-md-4">
        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
        <h3>I did it myself</h3>
        <p>It was easy, just follow the guide.</p>
      </div>
      <div class="col-md-4">
        <span class="glyphicon glyphicon-education" aria-hidden="true"></span>
        <h3>No Cheating</h3>
        <p>Just Ruby code within a Rails framework.</p>
      </div>
    </div>
  </footer>
</div>
```

These Header and Footer files contain some example HTML that will give you a starting point. Before you modify them open up `app/views/layouts/application.html.erb` and insert the command to render the partials you just created. Your layout file will look like:

```erb
<!DOCTYPE html>
<html>
  <head>
    <title>QuickBlog</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>

    <%= auto_discovery_link_tag(:atom, posts_path(:atom)) %>
  </head>

  <body>
    <%= render partial: 'layouts/header' %>
    <div class="container">
      <div class="row">
        <div class="col-xs-12 col-sm-10 col-md-8">
          <%= yield %>
        </div>
      </div>
    </div>
    <%= render partial: 'layouts/footer' %>
  </body>
</html>
```

(Don't forget to save your files.)

Refresh your browser or navigate to [http://localhost:3000](http://localhost:3000) to see the changes you've just made. Feel free to go ahead and edit the header and footer html files now to make your blog truly personal.

If you've been successful (and if you haven't, please ask for some help) then your blog should be looking something like this:

![completed blog](/images/guides/completed_blog.png)

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git add .
git commit -m "adding header and footer"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able
to navigate to your blog on Heroku now to see the changes you've made.

## Questions and homework

You might notice a few things you want to change about the application. While some things are easy, others will require more effort or possible some [assistance from a mentor](http://www.reinteractive.com/community/development_hub).

**Q) How to remove the "Listing posts" heading?**

A) *Open `app/views/posts/index.html.erb`. You should be able to figure it out from there :)*

**Q) How do I make the About me link work in the header?**

A) *There are a couple of ways of doing this. You can alter the link so it points to `/about.html` and create a file in `public/` or alternatively create generate a controller and wire up a route to an action in that controller. You can read more about this in the [routing guide](http://guides.rubyonrails.org/routing.html#connecting-urls-to-code) and the [action controller guide](http://guides.rubyonrails.org/action_controller_overview.html#methods-and-actions).*

**Q) There's a bug that lets a user submit blank comments!**

A) *You can fix this by creating a validation on your comment model. Look at see how you created a validates_presence_of validation in the Post model and replicate that in the Comment model*

**Q) I want to have proper user logins for both creating a post and submitting comments.**

A) *You can use a gem like [Devise](https://github.com/plataformatec/devise) to do this, it can be a bit complicated though. Ryan Bates has done some excellent screencasts on [Devise](http://railscasts.com/episodes/209-devise-revised) and [Authentication from Scratch](http://railscasts.com/episodes/250-authentication-from-scratch-revised). If you're keen to learn more about Rails you should subscribe!*

## Next Steps

Up next we'll add an Administration panel and convert our blog posts to Markdown format. Click [here](/guides/installfest/admin_and_markdown) to check it out and continue your Rails adventure.
