---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/getting_started.md
---

# Getting Started
## Preparation

#### Prerequisites

1. A working version of Rails 3.2 which you can install using [Rails Installer](http://railsinstaller.org/) for Windows or Mac.
2. Sublime Text 2. If you prefer another text editor like vim, emacs or TextMate that's fine too but these instructions will specifically mention Sublime.

#### Next steps

Open two command prompts. One of these you'll use to run your local Rails server and the other you'll use for entering all other commands.
Whenever you need to start or restart the rails server use one of these prompts, for all other command line work you can use the other.


## Setting up our Rails app

`rails new quick_blog -T`

Entering this command into your command prompt will cause Rails to generate a new application and begin to install dependencies for your application. This process may take a few minutes, so you should let it continue. Once it has finished type:

`cd quick_blog`

To change into the folder where your application is stored. If you look at the contents of this folder you'll see:

![The default Rails application structure](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/default_rails_structure.png)

This is the standard structure of a new Rails application. Once you learn this structure it makes working with Rails easier since everything is in a standard place. Next we'll run this fresh application to check that our Rails install is working properly. Type:

`rails server`

Open your web-browser and head to: [http://localhost:3000](http://localhost:3000) you should see something that looks like:

![Rails default homepage](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/rails_default_home.png)

Now that you've created the Rails application you should open this folder using Sublime. Open up Sublime, then open the quick_blog folder that was just generated.

## Creating basic functionality

Now we're ready to get started building an actual blog. In your command prompt press `Ctrl-c` to stop the Rails server, or open a new command prompt and navigate to your Rails application folder. Then you can use a Rails generator to build some code for you:

`rails g scaffold Post title body:text`

You'll be presented with something that looks like:

![Scaffolding posts](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/scaffolding_posts.png)

An important file that was generated was the migration file: `db/migrate/20130422001725_create_posts.rb` Note that you will have a different set of numbers in yours.

```ruby
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
```

This file is some Ruby code that is a database agnostic way to manage your schema. You can see that this code is to create a table called `Posts` and to create two columns in this table, a title column and a body column. Finally we need to instruct Rails to apply this to our database. Type:

`rake db:migrate`

Once this command has run you can start up your Rails server again with `rails server` and then navigate to [http://localhost:3000/posts](http://localhost:3000/posts) to see the changes you've made to your application.

![Empty posts list](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/empty_posts_list.png)

From here you can play around with your application. Go ahead and create a new blog post.

![Creating a new post](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/filling_out_posts_form.png)

You'll notice you can create new posts, edit or delete them. We're going to add in some functionality to our new Rails app which enforces a rule that every post must have a title. Open `app/models/post.rb` and add the line:

```ruby
validates_presence_of :body, :title
```

To the code. Your `post.rb` file should look like:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title

  validates_presence_of :body, :title
end
```

We can check that this works by editing our blog post, deleting the title and clicking `Update Post`. You'll get an error informing you that you've just attempted to break the rule you just inserted:

![Rails validation error](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/validation_errors.png)

## Making things prettier

Right now our [show post page](http://localhost:3000/posts/1) isn't looking very good. We'll open `app/views/posts/show.html.erb` and make it look like the following:

```erb
 <p id="notice"><%= notice %></p>

 <h2><%= link_to_unless_current @post.title, @post %></h2>
 <%= simple_format @post.body %>

 <%= link_to 'Edit', edit_post_path(@post) %> |
 <%= link_to 'Back', posts_path %>
```

At this point you can refresh the show post page in your browser to see the changes you've made.

We'll also want to make our blog listing prettier too, we'll use a Rails partial (a partial is simply a reusuable block of HTML code. It's part of a web page) to achieve this. We want our listing and the individual blog pages to look the same so first we'll create a file: `app/views/posts/_post.html.erb` The underscore in front of the filename here tells Rails that this is a partial. We'll take

```erb
 <h2><%= link_to_unless_current @post.title, @post %></h2>
 <%= simple_format @post.body %>
```

Out of `app/views/posts/show.html.erb` and put it in our `_post.html.erb` file. After that, change all the `@post` to be `post` instead. This means your `_post.html.erb` file will be:

```erb
 <h2><%= link_to_unless_current post.title, post %></h2>
 <%= simple_format post.body %>
```

In our `show.html.erb` file we want to insert the code to put our partial into our show view. Insert the code: `<%= render :partial => @post %>` to make it look like:


```erb
 <p id="notice"><%= notice %></p>

 <%= render :partial => @post %>

 <%= link_to 'Edit', edit_post_path(@post) %> |
 <%= link_to 'Back', posts_path %>
```

Save all these files and refresh [the show posts page](http://localhost:3000/posts/1). This is to check that you haven't broken anything with those changes.

Our index page still hasn't changed though so we're going to open the `index.html.erb` file up and remove the table in there and replace it with the partial again so we're re-using that code:

```erb
 <h1>Listing posts</h1>

 <%= render :partial => @posts %>

 <%= link_to 'New Post', new_post_path %>
```


## Access control

One huge problem with our blog is that anyone can create, edit and delete blog posts. Let's fix that. We'll use HTTP Basic authenticate to put a password on actions we don't want everyone accessing. Open `app/controllers/posts_controller.rb` and add `before_filter :authenticate, :except => [ :index, :show ]` on line 2 just below the class declaration. At the bottom of your file put the following code:

```ruby
  private
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == "admin" && password == "secret"
    end
  end
```

Overall your `posts_controller.rb` should have the following code at the top and the bottom of the file. Note that all the methods are excluded here for brevity.

```ruby
class PostsController < ApplicationController
  before_filter :authenticate, :except => [ :index, :show ]

  // … all your actions go in here

  private
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == "admin" && password == "secret"
    end
  end
end
```

With that code in place you can try to [add a new post](http://localhost:3000/posts/new) and you'll be prompted to enter a username and password.

![image](http://reinteractive.net/assets/blog_images/rails-3-2-intro-blog/authentication_required.png)

## Adding comments
#### Creating a database model and routing

No blog is complete without comments. Let's add them in. On our command prompt, shut down your rails server by hitting `Ctrl-C` and then type in:

`rails generate resource Comment post:references body:text`

Then you'll want to update your database here to reflect the schema change you've just made:

`rake db:migrate`

After this you'll need to inform Rails that your Posts will potentially have many Comments. Open `app/models/post.rb` and add the line: `has_many :comments` somewhere inside the class. This should look like:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title

  has_many :comments

  validates_presence_of :body, :title
end
```

The back-end for your comments is almost complete, we only need to configure the url that is used to create your comments. Since comments belong to a post we'll make the URL reflect this. Right now you can see all the configured URLs by typing `rake routes` in your command prompt. If you do this now you'll get something like the following:

```ruby
    comments GET    /comments(.:format)          comments#index
             POST   /comments(.:format)          comments#create
 new_comment GET    /comments/new(.:format)      comments#new
edit_comment GET    /comments/:id/edit(.:format) comments#edit
     comment GET    /comments/:id(.:format)      comments#show
             PUT    /comments/:id(.:format)      comments#update
             DELETE /comments/:id(.:format)      comments#destroy
       posts GET    /posts(.:format)             posts#index
             POST   /posts(.:format)             posts#create
    new_post GET    /posts/new(.:format)         posts#new
   edit_post GET    /posts/:id/edit(.:format)    posts#edit
        post GET    /posts/:id(.:format)         posts#show
             PUT    /posts/:id(.:format)         posts#update
             DELETE /posts/:id(.:format)         posts#destroy
```

Your URLs (or routes) are configured in all Rails applications in the file `config/routes.rb`, open it now and remove the line `resources :comments`. Re-run `rake routes` and you'll notice that all the URLs for comments have disappeared. Update your `routes.rb` file to look like the following:

```ruby
QuickBlog::Application.routes.draw do
  resources :posts do
    resources :comments, :only => [:create]
  end

  # root :to => 'welcome#index'
end
```

Because comments will be visible from the show Post page along with the form for creating them, we don't need to have URLs for displaying comment listings, or individual comments. When you rerun `rake routes` now you'll see the following line:

```ruby
post_comments POST   /posts/:post_id/comments(.:format) comments#create
```

Before we're finished with the backend for our commenting system we need to write the action that will create our comments. For more information on actions please read the Rails Guide on [ActionController](http://guides.rubyonrails.org/action_controller_overview.html).

Open `app/controllers/comments_controller.rb` and make your code look like the following:

```ruby
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(params[:comment])
    redirect_to @post
  end
end
```

#### Putting comments into your HTML view

You've created the database model for your comments, migrated your database, informed Rails of the relationship between comments and posts, configured a URL that lets you create your comments and created the controller action that will create the comments. Now you need to display any comments that have been submitted for a post, and allow users to submit comments. Open `app/views/posts/show.html.erb` and make it look like:

```erb
 <p id="notice"><%= notice %></p>

 <%= render :partial => @post %>

 <%= link_to 'Edit', edit_post_path(@post) %> |
 <%= link_to 'Back', posts_path %>

 <h2>Comments</h2>
 <div id="comments">
  <%= render :partial => @post.comments %>
 </div>
```

You'll now need to create a file called `app/views/comments/_comment.html.erb` with the following contents:

```erb
<%= div_for comment do %>
  <p>
    <strong>
      Posted <%= time_ago_in_words(comment.created_at) %> ago
    </strong>
    <br/>
    <%= comment.body %>
  </p>
<% end %>
```

Back in `app/views/posts/show.html.erb` you need to add in the form for submitting a comment so add the following code to the bottom of that file.

```erb
<%= form_for [@post, Comment.new] do |f| %>
  <p>
    <%= f.label :body, "New comment" %><br/>
    <%= f.text_area :body %>
  </p>
  <p><%= f.submit "Add comment" %></p>
<% end %>
```

Comments are now working (if they aren't make sure you restart your `rails server`) so go ahead and browse to [your post](http://localhost:3000/posts/1) and add a new comment.

## Publishing your Blog on the internet

Heroku is a fantastically simple service that can be used to host Ruby on Rails applications. You'll be able to host your blog on Heroku on their free-tier but first you'll need a Heroku account. Head to [https://www.heroku.com/](https://www.heroku.com/), click Sign Up and create an account. The starter documentation for Heroku is available at: [https://devcenter.heroku.com/articles/quickstart](https://devcenter.heroku.com/articles/quickstart). Once you've got an account you'll need to download the toolbelt from [https://toolbelt.heroku.com/](https://toolbelt.heroku.com/) and set it up on your computer.

### About databases

Up until this point we've been using SQLite as our database, but unfortunately Heroku doesn't support the use of SQLite. So we're going to be running Postgres instead. Setting this up is easy. You'll need to open the `Gemfile` and make your `Gemfile` look like:

```ruby
source 'https://rubygems.org'

gem 'rails', '3.2.12'

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
end

gem 'jquery-rails'
```

After this, run the command `bundle install --without=production` on your command line.

### Regarding version control

Heroku also requires that every application is placed under version control before it is deployed. Simply run the following commands on the command prompt to make sure your application is properly controlled:

```ruby
git init
git add .
git commit -m "initial blog commit"
```

### Deploying your application

In the same command prompt you should be ready to deploy your application. First we create our Heroku application:

`heroku create`

Now we push our application to Heroku:

`git push heroku master`

Finally we set up our database:

`heroku run:detached rake db:setup`

This setup of the database should only need to take place the first time you deploy to heroku. Afterwards you may need to run `db:migrate` instead.
The `detached` option runs the command in the background. It is there only to ensure the process will go through, even on faulty Internet connection. You can use `heroku logs` to view the output of the command.

Finally you should be able to browse to the URL that Heroku has given you and check to see that your blog has been deployed properly!

Welcome to Ruby on Rails. If you're this far along you should definitely [head on over to Part 2](/guides/installfest/finishing_a_basic_blog) which goes more in depth with Rails and begins to add more features to the blogging engine.
