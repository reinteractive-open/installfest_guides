---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/finishing_a_basic_blog.md
---

# Finishing a Basic Blog
In the [previous article](/guides/installfest/getting_started) you built a simple blogging engine using Rails and published it up on [Heroku](https://www.heroku.com). If you haven't run through that post then you should do so now before starting this one. In this installment, together, we'll add some features to your blogging engine, show you more about Rails and make it look nicer using [Zurb Foundation](http://foundation.zurb.com/). Let's dive in.

## Preparation for our coding session

First we want to start our Rails server, so open two terminals and change to the directory we're developing our app in. In one of our terminals start the Rails server with `rails s` (s is short for server). Next start Sublime Text and open the folder that your app is stored in. By doing this you get to see the directory structure of Rails in the sidebar so you'll be able to navigate around your project a little more easily.

![image](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/sublime_folder.png)


## Setting the index/root page in Rails

Currently our site only shows the posts if you navigate to `/posts`.  This is all well and good, but if you go to the "root page" of the website at [http://localhost:3000](http://localhost:3000) you get the "Welcome to Rails" page.

Obviously, if we want people to start reading our blog, it would be good if we show the blog posts we have immediately when they come to our site, without having them navigate elsewhere.

To set the root page of a Rails application, first you need to delete the "Welcome to Rails" page that is located at `public/index.html`.

Once done, open `config/routes.rb` and add `root :to => 'posts#index'` to that file so it looks like:

```ruby
QuickBlog::Application.routes.draw do
  root :to => 'posts#index'

  resources :posts do
    resources :comments, :only => [:create]
  end
end
```

The way we're using the root [method](https://github.com/rails/rails/blob/a72dab0b6a16ef9e83e66c665b0f2b4364d90fb6/actionpack/lib/action_dispatch/routing/mapper.rb#L253) here indicates that we want the root path of our application to be sent to the `PostsController` index action which you created in the previous article. If you open [http://localhost:3000](http://localhost:3000) you'll see your posts index rather than the boring default Rails page.

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git add .
git rm public/index.html
git commit -m "setting a root page"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able to navigate to your blog on Heroku now to see the changes you've made.

## AJAX commenting with unobtrusive JavaScript

The blogging engine we've got works great, but it definitely doesn't feel like a smooth, modern web-app. Luckily with Rails it's easy to add in simple JavaScript! Just like all the other helpers that Rails provides if this isn't powerful enough for your needs you can always add as much custom JavaScript into `app/assets/javascripts/` as you like.

What you'll be doing is adding in some functionality to the commenting system so that it posting a comment doesn't require a page reload. This means we'll be submitting our comments using AJAX and then rendering the comments onto the post page using JavaScript. First we'll tackle posting the form using AJAX.

#### Making the form submit via AJAX

Open `app/views/posts/show.html.erb` and add a `:remote => true` option to the form_for method call. Your show view should look like:

```erb
 <p id="notice"><%= notice %></p>

 <%= render :partial => @post %>

 <%= link_to 'Edit', edit_post_path(@post) %> |
 <%= link_to 'Back', posts_path %>

 <h2>Comments</h2>
 <div id="comments">
   <%= render :partial => @post.comments %>
 </div>

 <%= form_for [@post, Comment.new], :remote => true do |f| %>
   <p>
     <%= f.label :body, "New comment" %><br/>
     <%= f.text_area :body %>
   </p>
   <p><%= f.submit "Add comment" %></p> 
 <% end %>
```

Adding that the remote flag to that method call means that Rails will automatically set up that form to be submitted via AJAX.

If you refresh the [post view page](http://localhost:3000/posts/1) and try to submit a comment you'll notice that nothing happens, however if you switch to the terminal running your Rails server you'll be able to see that the request was received by the server, it's just doing the wrong thing with that request. 

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

The last line of the log here indicated that the server redirected to /posts/1 as the response. We don't want that behaviour for an AJAX call.

#### Setting up the server to process AJAX requests

Let's fix that by making our create comment action aware of JavaScript AJAX requests. Open `app/controllers/comments_controller.rb` and change the create method to respond to AJAX requests as follows:

```ruby
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(params[:comment])
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end
```

What this means is that your app will respond to regular HTML requests in the same way as before (by redirecting to the url of the post) but will render a view when receiving a JS request. This view doesn't exist yet so you'll need to create it now. Create a new file `app/views/comments/create.js.erb`. This is a JS file that will be returned to the browser and executed. We want it to do 2 things: Insert the comment html into the document, and clear the comment form. Your `create.js.erb` file should look like:

```js
$('#comments').append('<%= escape_javascript(render :partial => @comment) %>');
$('#comment_body').val('')
```

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

Our first job is to get the same behaviour but render the posts in Atom format. Update your index action so it looks like:

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

If you goto [http://localhost:3000/posts.atom](http://localhost:3000/posts.atom) you'll receive an error that the template is missing. 

![template missing error](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/missing_template.png)

#### Building the Atom feed

This just means we need to create it. We'll be creating a file called: `app/views/posts/index.atom.builder` and putting the following contents into that file:

```ruby
atom_feed do |feed|
  feed.title "InstallFest 2013 Quick Blog"
  feed.updated @posts.first.updated_at

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title post.title
      entry.content post.body, :type => 'html'

      entry.author do |author|
        author.name 'Installfest Attendee'
      end
    end
  end
end
```

You might want to customise your ATOM feed by changing the name of the blog, or by changing the author name to your own. Refresh the [http://localhost:3000/posts.atom](http://localhost:3000/posts.atom) page and you'll see the XML being returned properly. 

#### RSS feed discovery

Our next job is to publicise the ATOM feed so that RSS readers (if they still exist) can easily subscribe. We'll do this by opening `app/views/layouts/application.html.erb` and adding in a link tag that lets some browsers auto-discover our RSS feed. Your `application.html.erb` file should look like:

```erb
<!DOCTYPE html>
<html>
<head>
  <title>QuickBlog</title>
  <%= stylesheet_link_tag    "application", :media => "all" %>
  <%= javascript_include_tag "application" %>
  <%= csrf_meta_tags %>
  <%= auto_discovery_link_tag(:atom, posts_path(:atom)) %>
</head>
<body>

<%= yield %>

</body>
</html>
```

To test this you might like to temporarily install [this plugin to Google Chrome](https://chrome.google.com/webstore/detail/rss-subscription-extensio/nlbjncdgjeocebhnmkbbbdekmmmcbfjd?hl=en) and reload any page on your blog site. This layout file is used to wrap every view in your application so changes made to this file will affect every single page in your application. After you load up any page in your blog you should see an RSS icon in the URL bar. Clicking it will take your to your site's RSS feed.

![rss feed indicator](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/rss_feed_indicator.png)

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git add .
git commit -m "adding atom feed and autodiscovery"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able to navigate to your blog on Heroku now to see the changes you've made.

## Giving your blog some style

Up until this point we've really neglected the look and feel of your blog. It definitely feels a bit boring! We'll be making it look much nicer by using a UI library called [Foundation](http://foundation.zurb.com/). Foundation is similar to [Twitter Bootstrap](http://twitter.github.io/bootstrap/), but is slightly more compatible with Rails. Foundation is built using [Sass](http://sass-lang.com/) while Bootstrap is built using [Less](http://lesscss.org/). You can run Less in Rails, but it has some compatibility issues with Windows so today we'll be using Foundation.

We'll be installing Foundation using the zurb-foundation gem by adding it to our Gemfile's asset group. The Gemfile is a file that sits at the top level of your application directory structure and lists all of the dependencies and libraries that your code uses. Update your Gemfile so it looks like:

```ruby
source 'https://rubygems.org'

gem 'rails', '~> 3.2.12'

 # For gems only used in development
group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'

  gem 'zurb-foundation', '~> 4.0.0'
end

gem 'jquery-rails'
```

After you've saved that file, switch to your terminal and run: `bundle install --without=production`. We're going to skip installing the postgres gem in our development environment since it's likely your computer isn't set up to build it properly. Make sure at this point you also restart your Rails server, so switch to the command prompt where Rails is running press `Ctrl-C` and then restart it by typing `rails s`.

After you've done this you'll need to switch back to your other terminal and finish installing Foundation. Run: `rails g foundation:install`. This will prompt you with the following:

```ruby
    conflict  app/views/layouts/application.html.erb
Overwrite /Users/artega/dev/reinteractive/quick_blog/app/views/layouts/application.html.erb? (enter "h" for help) [Ynaqdh]
```

Press n and then enter to skip overwriting our `application.html.erb` layout file. By skipping this we do miss out on some of Foundation's responsive design features, but we've already added our RSS link to our layout file and allowing the install to overwrite our layout file would mean we'd lose that link. If you're comfortable putting the autodiscovery link tag back into the new layout file, rerun the foundation install and allow it to overwrite your layout.

You'll also want to remove the scaffolding css file that Rails provided to you when you scaffolded the Posting functionality. To do that just delete `app/assets/stylesheets/scaffolds.css.scss`. Refreshing your browser or navigating to [http://localhost:3000](http://localhost:3000) at this point will show some changes to the UI of your blog.

We're going to start off with two very quick things with Foundation. We'll give our content some whitespace so it's easier to read, and we'll change all our buttons so that they have a bit more style. First open your layout file `app/views/layouts/application.html.erb` and update it to look like:

```erb
  <!DOCTYPE html>
  <html>
  <head>
    <title>QuickBlog</title>
    <%= stylesheet_link_tag    "application", :media => "all" %>
    <%= javascript_include_tag "application" %>
    <%= csrf_meta_tags %>
    <%= auto_discovery_link_tag(:atom, posts_path(:atom)) %>
  </head>
  <body>
    <div id="main">
      <%= yield %>
    </div>
  </body>
  </html>
```

Then we'll create a file called `app/assets/stylesheets/common.css.scss` and put the following inside it:

```css
input[type="submit"] {
  @include button;
}

div#main {
  @include grid-row;
}

footer {
  margin-top: 50px;
  background-color: #000;
  color: #eee;
  text-align: center;
  p {
    line-height: 100px;
  }
}
```

Then we'll open `app/assets/stylesheets/application.css` and delete the line with `*= require_tree .` so that file will be:

```css
/*
 *= require_self
 *= require foundation_and_overrides
 */
```

Finally we'll open `app/assets/stylesheets/foundation_and_overrides.css.scss` and at the bottom of the file it should look like:

```ruby
@import 'foundation';
@import 'common';
```

These steps definitely need explaining. First in our layout file you wrapped the yield statement inside a div. Then we're creating a new SCSS file that does 3 things:

1. Changes all inputs with a type of submit to use Foundation's [button styling](http://foundation.zurb.com/docs/components/buttons.html).
2. Targets that div#main you inserted into the layout file and gives it Foundation's [grid-row behaviour](http://foundation.zurb.com/docs/components/grid.html).
3. Sets up some footer styling that we'll be using in a later step.

After this you removed the require_tree directive from the application.css file. This directive causes your application to stop automatically including every CSS file in the stylesheets folder. Immediately after this we import the new common.css.scss file into the foundation_and_overrides file so that our newly created CSS rules will be applied to our blog. We're doing this to inform Rails' asset pipeline that we'd like to use SASS to import the file, rather than relying on the asset pipeline's catch-all method. This gives us slightly more control over what gets included and also causes Foundation's mixins to work correctly. You can [read more about the asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) on the [Rails guide site](http://guides.rubyonrails.org/index.html).

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git add .
git rm app/assets/stylesheets/scaffolds.css.scss
git commit -m "adding zurb foundation"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able to navigate to your blog on Heroku now to see the changes you've made.

## Adding some personality

Your blog works, it has posts and comments but it doesn't feel like your own. We're going to add in a header and footer which will allow users to navigate a little more easily and will give you the chance to personalise your blog a bit more. In all web-pages the header and footer are generally common across all pages, Rails gives us a layout file that lets us make these sorts of changes to every page at once.

First we'll create two files a header and a footer. Create `app/views/layouts/_header.html.erb` put the following code in it:

```erb
<nav class="top-bar">
  <ul class="title-area">
    <!-- Title Area -->
    <li class="name">
      <h1>
        <%= link_to 'Your Blog Name', root_path %>
      </h1>
    </li>
    <!-- Remove the class "menu-icon" to get rid of menu icon. Take out "Menu" to just have icon alone -->
    <li class="toggle-topbar menu-icon"><a href="#"><span>Menu</span></a></li>
  </ul>
  <section class="top-bar-section">
    <ul class="right">
      <li class="divider hide-for-small"></li>
      <li>
        <%= link_to 'Github', 'https://github.com/reInteractive-open' %>
      </li>

      <li class="divider hide-for-small"></li>
      <li>
        <%= link_to 'Twitter', 'https://twitter.com/' %>
      </li>

      <li class="divider hide-for-small"></li>
      <li>
        <%= link_to 'About me', '/about' %>
      </li>
    </ul>
  </section>
</nav>
```

And then create `app/views/layouts/_footer.html.erb` and put the following code in it:

```erb
<footer>
  <p>
    Powered by: <%= link_to 'rails-3-2-intro-blog', 'https://github.com/reinteractive-open/rails-3-2-intro-blog' %>
    Developed at: <%= link_to 'InstallFest 2013', 'http://reinteractive.net/service/installfest' %>
  </p>
</footer>
```

These Header and Footer files contain some example HTML that will give you a starting point. Before you modify them open up `app/views/layouts/application.html.erb` and insert the command to render the partials you just created. Your layout file will look like:

```erb
<!DOCTYPE html>
<html>
<head>
  <title>QuickBlog</title>
  <%= stylesheet_link_tag    "application", :media => "all" %>
  <%= javascript_include_tag "application" %>
  <%= csrf_meta_tags %>
  <%= auto_discovery_link_tag(:atom, posts_path(:atom)) %>
</head>
<body>
  <%= render :partial => 'layouts/header' %>

  <div id="main">
    <%= yield %>
  </div>

  <%= render :partial => 'layouts/footer' %>
</body>
</html>
```

Refresh your browser or navigate to [http://localhost:3000](http://localhost:3000) to see the changes you've just made. Feel free to no go ahead and edit the header and footer html files now to make your blog truly personal.

If you've been entirely successful (and if you haven't feel free to ask for some help) then your blog should be looking something like this:

![completed blog](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/completed_blog.png)

#### Deploying your changes

At this point you can commit all your changes using git by typing:

```ruby
git add .
git commit -m "adding header and footer"
```

And then you can deploy to Heroku with `git push heroku master`. You'll be able to navigate to your blog on Heroku now to see the changes you've made.

## Questions and homework

You might notice a few things you want to change about the application. While some things are easy, others will require more effort or possible some [assistance from a mentor](http://www.reinteractive.net/service/development_hub).

**Q) How to remove the "Listing posts" heading? **

A) *Open `app/views/posts/index.html.erb`. You should be able to figure it out from there :)*

**Q) How do I make the About me link work in the header?**

A) *There are a couple of ways of doing this. You can alter the link so it points to /about.html and create a file in `public/` or alternatively create generate a controller and wire up a route to an action in that controller. You can read more about this in the [routing guide](http://guides.rubyonrails.org/routing.html#connecting-urls-to-code) and the [action controller guide](http://guides.rubyonrails.org/action_controller_overview.html#methods-and-actions).*

**Q) There's a bug that lets a user submit blank comments!**

A) *You can fix this by creating a validation on your comment model. Look at see how you created a validates_presence_of validation in the Post model and replicate that in the Comment model*

**Q) I want to have proper user logins for both creating a post and submitting comments.**

A) *You can use a gem like [Devise](https://github.com/plataformatec/devise) to do this, it can be a bit complicated though. Ryan Bates has done some excellent screencasts on [Devise](http://railscasts.com/episodes/209-devise-revised) and [Authentication from Scratch](http://railscasts.com/episodes/250-authentication-from-scratch-revised). If you're keen to learn more about Rails you should subscribe!*

## Next Steps

Up next is a guide on testing your 15 minute blog. Click [here](/guides/installfest/testing_the_blog) to check it out and continue your Rails adventure.
