---
github_url: https://github.com/reinteractive-open/installfest_guides/blob/develop/source/guides/installfest/getting_started.md
---

# Getting Started
## Preparation

#### Prerequisites

1. A working version of Rails 5.1. To determine if you've got a working version of Rails 5.1, type `rails -v` into your command prompt, or ask a mentor.
2. [Sublime Text](https://www.sublimetext.com). If you prefer another text editor like [Vim](http://www.vim.org/download.php), [emacs](https://www.gnu.org/software/emacs/), [TextMate](https://macromates.com/) or Github's [Atom](https://atom.io/) that's fine too but these instructions will specifically mention Sublime.

#### Next steps

Open a command prompt.

To do this on Windows: Open the Command Prompt window by clicking the Start button, clicking All Programs, clicking Accessories, and then clicking Command Prompt.

To do this on Mac: Open Finder in the Dock. Select applications. Then choose utilities. Double click on Terminal.

## Setting up our Rails app

Enter the following command into your command prompt:

`rails new quick_blog -T`

This command tells Rails to generate a new application and begin to install dependencies for your application. This process may take a few minutes, so you should let it continue.

The `-T` is short for `--skip-test-unit`.  We won't be specifically covering testing just now, so we won't need the `test` directory that Rails normally provides for you when generating a new project.

Once it has finished type:

`cd quick_blog`

Entering this command will change you into the folder where your application is stored. If you look at the contents of this folder you'll see:

![The default Rails application structure](/images/guides/default_rails_structure.png)

This is the standard structure of a new Rails application. Once you learn this structure it makes working with Rails easier since everything is in a standard place.

Next we'll run this fresh application to check that our Rails install is working properly. Type:

`rails server`

Open your web-browser and head to: [http://localhost:3000](http://localhost:3000) you should see something that looks like:

![Rails default homepage](/images/guides/onrails5.png)

Now that you've created the Rails application you should open this folder using Sublime.

Open up Sublime (or your chosen text editor).

From there, select `file -> open folder...` and navigate to the quick_blog folder that was just generated.

Note: If you open the entire folder - rather than just a file - you will find it much easier to navigate your project.

## Creating basic functionality

Now we're ready to get started building an actual blog.

In your command prompt press `Ctrl-c` (hold down the `Control` key, and press `c`) to stop the Rails server, or use your second command prompt and navigate to your Rails application folder.

Then you can use a Rails generator to build some code for you:

`rails generate scaffold Post title:string body:text`

__Let's break this command down:__

We're asking `rails` to `generate` a `scaffold` (basic building blocks; think construction scaffolding) for a "thing" that we want to call a `Post` in our system. In Rails terminology this "thing" (Post) is called a "resource".

We want to give our `Post` two attributes:

* a `title`, which we want to be a `string`, and
* a `body`, which we want to be `text`.

A `string` is computer-speak for a short sequence of characters like `"hello"` or `"Are you having fun, yet?"`, and can usually be as long as your average tweet. Blog titles tend to be short, so we'll use a `string` for ours.

`text` is like a `string`, but longer, so we'll use it to have enough room to write as many paragraphs as we want in the `body` of our blog post.

After running your command, you'll be presented with something that looks like:

![Scaffolding posts](/images/guides/scaffolding_posts.png)

An important file that was generated was the migration file:
`db/migrate/20140528075017_create_posts.rb`

Note that, as this filename starts with a unique id including the date and time, yours will have a different set of numbers.

You can view this file by going to Sublime, navigating through the folders on the left side column, and clicking on `20140528075017_create_posts.rb`.

```ruby
# db/migrate/20140528075017_create_posts.rb
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

This file is Ruby code that Rails uses to manage how your data is stored in the database.

You can see that this code is to create a table called `Posts` and to create two columns in this table, a title column and a body column.

Whilst we have generated this code to create our Posts table, the script has not yet been executed and therefore the table does not yet exist in our database.

We need to instruct Rails to apply this to our database. Returning to the command-line, type:

`rails db:migrate`

Once this command has run you can start up your Rails server again with `rails server` and then navigate to
[http://localhost:3000/posts](http://localhost:3000/posts) in your web browser to see the changes you've made to your application.*(Windows users see below)

![Empty posts list](/images/guides/empty_posts_list.png)

From here you can play around with your application.

Go ahead and create a new blog post.

![Creating a new post](/images/guides/filling_out_posts_form.png)

You'll notice you can create new posts, edit or delete them.

<hr>

*__Windows Users Only__

Some of you might get an error like the one below:

![Windows-coffeescript-error](/images/guides/windows-coffeescript-error.png)

You can fix this by opening up your `Gemfile` and adding `gem 'coffee-script-source', '1.8.0'`. Then go back to your command-line and run `bundle install` to install the gem.

__Important Note__: This extra line in your Gemfile is unique to your project. Further in the guide, where we make changes to our Gemfile, you must be sure that this line remains. Otherwise the error message above will return.

<hr>

__Back to guide...__

We're going to add some functionality to our new Rails app to enforce a rule that every post must have a title.

In Sublime, open `app/models/post.rb` and add the following line to your code:

```ruby
validates :body, :title, presence: true
```

(Don't forget to save your file.)

Your `post.rb` file should look like:

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  validates :body, :title, presence: true
end
```

We can check that this works by returning to our browser, editing our blog post, deleting the title and clicking `Update Post`.

You'll get an error informing you that you've attempted to break the rule you just created:

![Rails validation error](/images/guides/validation_errors.png)

## Changing the default look

Right now our [show post page](http://localhost:3000/posts/1) isn't looking very good.

In Sublime, open `app/views/posts/show.html.erb` and make it look like the following:

```erb
<p id="notice"><%= notice %></p>

<h2><%= link_to_unless_current @post.title, @post %></h2>
<%= simple_format @post.body %>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```

(Don't forget to save your file.)

At this point you can refresh the Show Post page in your browser to see the changes you've made.

We want to make our blog listing prettier too, and we'll use a Rails partial to achieve this. A partial is simply a reusuable block of HTML code which can be embedded into a web page.

We want our listing and the individual blog pages to look the same so first we'll create a new file using Sublime.

This file will be a partial file that will live in `app/views/posts/` and we will name `_post.html.erb`. (The underscore in front of the filename here tells Rails that this is a partial.)

We'll take:

```erb
<h2><%= link_to_unless_current @post.title, @post %></h2>
<%= simple_format @post.body %>
```

out of `app/views/posts/show.html.erb` 

and put it in our `_post.html.erb` file.

After that, change all three mentions of `@post` to be `post` instead.

This means your `_post.html.erb` file will be:

```erb
<h2><%= link_to_unless_current post.title, post %></h2>
<%= simple_format post.body %>
```

In our `show.html.erb` file we want to add in the partial that we just created.

Insert the code: `<%= render partial: @post %>` to make it look like:

```erb
<p id="notice"><%= notice %></p>

<%= render partial: @post %>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>
```

Save all these files and refresh the [show posts page](http://localhost:3000/posts/1).

This is to check that you haven't broken anything with those changes.

At this point, our index page still hasn't changed. So we're going to remove the table in there and replace it with the partial so we're re-using that code.

In Sublime, open the `index.html.erb` file up and make it look like:

```erb
<h1>Listing posts</h1>

<%= render partial: @posts %>

<%= link_to 'New Post', new_post_path %>
```

(Don't forget to save your file.)

## Adding comments
#### Creating a database model and routing

No blog is complete without comments. Let's add them in.

In our command prompt, shut down your rails server by hitting `Ctrl-C` and then type in:

`rails generate resource Comment post:references body:text`

Don't forget to update your database here to reflect the schema change you've just made:

`rails db:migrate`

After this you'll need to inform Rails that your Posts will potentially have many Comments.

In Sublime, open `app/models/post.rb` and add the line: `has_many :comments, dependent: :destroy` inside the class.

This should look like:

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :body, :title, presence: true
end
```

(Don't forget to save your file.)

The back-end for your comments is almost complete, we only need to configure the url that is used to create your comments.

Since comments belong to a post, we'll make the URL reflect this.

Right now you can see all the configured URLs by typing `rails routes` in your command prompt.

If you do this now you'll get something like the following:

```
      Prefix Verb   URI Pattern                  Controller#Action
    comments GET    /comments(.:format)          comments#index
             POST   /comments(.:format)          comments#create
 new_comment GET    /comments/new(.:format)      comments#new
edit_comment GET    /comments/:id/edit(.:format) comments#edit
     comment GET    /comments/:id(.:format)      comments#show
             PATCH  /comments/:id(.:format)      comments#update
             PUT    /comments/:id(.:format)      comments#update
             DELETE /comments/:id(.:format)      comments#destroy
       posts GET    /posts(.:format)             posts#index
             POST   /posts(.:format)             posts#create
    new_post GET    /posts/new(.:format)         posts#new
   edit_post GET    /posts/:id/edit(.:format)    posts#edit
        post GET    /posts/:id(.:format)         posts#show
             PATCH  /posts/:id(.:format)         posts#update
             PUT    /posts/:id(.:format)         posts#update
             DELETE /posts/:id(.:format)         posts#destroy
```

In Rails, your URLs (or routes) are configured in the file `config/routes.rb`.

Open this file in Sublime and remove the line `resources :comments`.

Re-run `rails routes` and you'll notice that all the URLs for comments have disappeared.

Update your `routes.rb`file to look like the following:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
```

(Don't forget to save your file.)

Because comments will be visible from the show Post page along with the form for creating them, we don't need to have URLs for displaying comment listings, or individual comments.

When you rerun `rails routes` you'll now see the following line:

```
post_comments POST   /posts/:post_id/comments(.:format) comments#create
```

Before we're completely finished with the backend for our commenting system, we need to write the action that will create our comments. (For more information on actions please read the Rails Guide on
[ActionController](http://guides.rubyonrails.org/action_controller_overview.html))

In Sublime, open `app/controllers/comments_controller.rb` and make your code look like the following:

```ruby
# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(comment_params)
    redirect_to @post
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
```

(Don't forget to save your file.)

#### Putting comments into your HTML view

So far you have:

* created the database model for your comments, 
* migrated your database, 
* informed Rails of the relationship between comments and posts, 
* configured a URL that lets you create your comments, and 
* created the controller action that will create the comments.

Now you need to display any comments that have been submitted for a post, and allow users to submit comments.

In Sublime, open `app/views/posts/show.html.erb` and make it look like:

```erb
<p id="notice"><%= notice %></p>

<%= render partial: @post %>

<%= link_to 'Edit', edit_post_path(@post) %> |
<%= link_to 'Back', posts_path %>

<h2>Comments</h2>
<div id="comments">
  <%= render partial: @post.comments %>
</div>
```

You'll now need to create a file called `app/views/comments/_comment.html.erb` with the following contents:

```erb
<p>
  <strong>
    Posted <%= time_ago_in_words(comment.created_at) %> ago
  </strong>
  <br/>
  <%= comment.body %>
</p>
```

(Don't forget to save these files.)

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

Comments are now working, so go ahead and browse to [your post](http://localhost:3000/posts/1) and add a new comment.

## Setting the index/root page in Rails

Currently our site only shows the posts if you navigate to `/posts`.  This is all well and good, but if you go to the "root page" of the website at [http://localhost:3000](http://localhost:3000) you get the "Welcome to Rails" page.

Obviously, if we want people to start reading our blog, it would be good if we show the blog posts we have immediately when they come to our site, without having them navigate elsewhere.

To set the root page of a Rails application, open `config/routes.rb` and add `root 'posts#index'` to that file so it looks like:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root 'posts#index'

  resources :posts do
    resources :comments, only: [:create]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
```
(Don't forget to save your file.)

The way we're using the root [method](https://github.com/rails/rails/blob/a72dab0b6a16ef9e83e66c665b0f2b4364d90fb6/actionpack/lib/action_dispatch/routing/mapper.rb#L253) here indicates that we want the root path of our application to be sent to the `PostsController` index action which you created in the previous section. If you open [http://localhost:3000](http://localhost:3000) you'll see your posts index rather than the boring default Rails page.

## Publishing your Blog on the internet

Heroku is a fantastically simple service that can be used to host Ruby on Rails applications. You'll be able to host your blog on Heroku on their free-tier, but first you'll need a Heroku account.

Head to [https://www.heroku.com/](https://www.heroku.com/), click 'Sign Up' and create an account.

The starter documentation for Heroku is available at: [https://devcenter.heroku.com/articles/quickstart](https://devcenter.heroku.com/articles/quickstart).

Once you've got an account you'll need to download the toolbelt from [https://toolbelt.heroku.com/](https://toolbelt.heroku.com/) and set it up on your computer.

### Make the application work on Heroku

Up until this point we've been using SQLite as our database, but unfortunately Heroku doesn't support the use of SQLite. So we're going to be running Postgres instead.

Open the `Gemfile` in Sublime and change line 12 from:

`gem 'sqlite3'`

to:

`gem 'sqlite3', group: [:development, :test]`

This tells Rails that, instead of using SQLite in *all* environments, we want to use SQLite in development and test only.

Then add `gem 'pg', '~> 0.18', group: :production` on the following line to let Rails know that we will be using Postgres in production. (Windows users, if you added it previously, don't forget to keep the coffee-script-source gem in the list)

It should look like:

```ruby
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: [:development, :test]
gem 'pg', '~> 0.18', group: :production
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
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

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

After this, run the command `bundle install --without=production` on your command line.

### Regarding version control

Heroku also requires that every application is placed under [version control](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) before it is deployed.

Simply run the following commands on the command prompt to make sure your application is properly controlled:

```ruby
git init
git add .
git commit -m "initial blog commit"
```

### Deploying your application

First, open a new command prompt. Make sure you are in your `quick_blog` project directory.

Then, login to Heroku by typing:

`heroku login`

in your terminal.

Then we create our Heroku application:

`heroku create`

Next we push our application to Heroku:

`git push heroku master`

Finally, we set up our database:

`heroku rails db:migrate`

The `detached` option runs the command in the background. It is there only to ensure the process will go through, even on faulty Internet connection. You can use `heroku logs` to view the output of the command.

To check that your blog has been deployed properly, browse to the URL that Heroku has given you.
e.g. `https://peaceful-hamlet-7389.herokuapp.com`

Note that you can also use the `heroku open` command to get to the root URL.

Welcome to Ruby on Rails! If you're this far along you might want to pause and catch your breath. Check out [WTF Just Happened? A Quick Tour of your first Rails App](https://reinteractive.com/posts/316) to recap.

After that, it's time to [head on over to Part 2](/guides/installfest/adding_authentication) which shows you how to add authentication to secure your 15 minute blog.
