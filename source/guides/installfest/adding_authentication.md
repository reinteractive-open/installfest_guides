---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/adding_authentication.md
---

# Adding Authentication
In the [previous guide](/guides/installfest/getting_started) you built a simple blogging engine using Rails and published it on [Heroku](https://www.heroku.com). If you haven't run through that post then you should do so now before starting this one. If you feel confident with Rails but want to learn more about authentication you can find some instructions on getting the code set up properly below.

## Introduction to Authentication
Authentication is the process of identifying a user. This is usually based on a username and password, which is what we will be using here.

You have been using gems, and making changes to your Gemfile, in the [previous guide](/guides/installfest/getting_started) without any real explanation. Put simply, a gem provides a specific piece of functionality for your application. It is packaged as a library that contains the code for the functionality you require, together with any files or assets related to that functionality.

In this guide, we will be using a gem called [Devise](https://github.com/plataformatec/devise) to add authentication to our blog application. The devise gem features in pretty much every Rails application you will ever come across so listen up and pay attention! :-)

### Setup
Add the gem `devise` to your `Gemfile` so it looks like this:
(Windows users, if you added it previously, don't forget to keep the coffee-script-source gem in the list)

```ruby
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use devise for authentication
gem 'devise'

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

Save the file and run `bundle install`

This will add devise to our Rails application. (If you are on Windows, and have an error message about bcrypt_ext, see below).

Devise is the most popular authentication solution testing tool which provides a special testing language (powered by Ruby) for testing existing code and for informing developers about the structure and functionality of yet to be written code!

To complete the installation run:

`rails generate devise:install`

### Windows bcrypt_ext error

Follow the steps below to fix this issue:

1. Run `gem uninstall bcrypt` (select yes to go through with it)
2. Run `gem install bcrypt --platform=ruby`
3. Open `Gemfile` and add the line `gem ‘bcrypt’, platforms: :ruby`
4. Run `bundle install`
5. Restart your server
6. Run `rails generate devise:install` as per the step above

### Configuring Devise

One of the many useful features of devise is that it sends confirmation emails to your users. For this to work, we need to set up the default URL options in each environment. Let's start with development and leave test and production for later.

Open `config/environments/development.rb` and add the following line right at the end (before the keyword `end`):

`config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }`

We also need to display any alerts that devise might generate. To do this, open `app/views/layouts/application.html.erb` and make it look like the following:

```ruby
# app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
  <head>
    <title>QuickBlog</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <% if notice %>
    <p class="alert alert-success"><%= notice %></p>
  <% end %>
  <% if alert %>
    <p class="alert alert-danger"><%= alert %></p>
  <% end %>
    <%= yield %>
  </body>
</html>
```

### Add the User Model

Authentication doesn't make much sense unless we have the concept of a User.

Run the following commands one by one:

`rails generate devise user`

`rails db:migrate`

This will create a User table in our database and a User model in our application to talk to it.


### Create your first user

A user table isn't much use without a user, so let's create one now.

First, make sure your server is running.

Then, navigate to [http://localhost:3000/users/sign_up](http://localhost:3000/users/sign_up) and create a user account.


### Add sign-up and login links

You have probably noticed many websites with a link in the top right corner advising you that you are logged in, or providing you with a link to sign up. Let's add that to our app!

Open `app/views/layouts/application.html.erb` and make it look like the following:


```ruby
<!DOCTYPE html>
<html>
  <head>
    <title>QuickBlog</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <p class="navbar-text pull-right">
    <% if user_signed_in? %>
      Logged in as <strong><%= current_user.email %></strong>.
      <%= link_to 'Edit profile', edit_user_registration_path, :class => 'navbar-link' %> |
      <%= link_to "Logout", destroy_user_session_path, method: :delete, :class => 'navbar-link'  %>
    <% else %>
      <%= link_to "Sign up", new_user_registration_path, :class => 'navbar-link'  %> |
      <%= link_to "Login", new_user_session_path, :class => 'navbar-link'  %>
    <% end %>
    </p>
    
    <% if notice %>
      <p class="alert alert-success"><%= notice %></p>
    <% end %>
    <% if alert %>
      <p class="alert alert-danger"><%= alert %></p>
    <% end %>
    <%= yield %>
  </body>
</html>
```

If a user is not logged in, we need to redirect them to the login page. Open `app/controllers/application_controller.rb` and add:

`before_action :authenticate_user!`

just before the `end` keyword so that it looks like:

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
end
```

`application_controller` is a project-wide file, so those settings will apply to the entire app. However, we can override it on a case-by-case basis.

In the case of blog posts; anybody can read our blogs, we simply don't want to allow them to create or edit (or delete). To do this, open `app/controllers/posts_controller.rb` and add:

`before_action :authenticate_user!, except: [:show, :index]`

just after the first `before_action` so that it looks like:

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
```

To view our changes, make sure your server is running and navigate to [http://localhost:3000](http://localhost:3000). You should see your login status at the top of the page.


### Cleaning up

We've now secured our application by adding authentication. We've increased our confidence in our existing code and we're ready to move on to adding some automated testing to our blog. Before we do that though we should commit our code.

Run:

```sh
git add .
git commit -m "Adding devise gem for authentication"
```

## Next Steps

Up next we're going to add some automated testing to the blogging engine. Head on over to [Part 3: Testing the Blog](/guides/installfest/testing_the_blog) to get started.

If you're interested in more training from reinteractive, or just want to give us some feedback on this you can leave a comment below or:

#### Sign up to our Training mailing list.

Just put your email below and we'll let you know if we have anything more for you. We hate spam probably more than you do so you'll only be contacted by us and can unsubscribe at any time:

<form action="http://reinteractive.us4.list-manage.com/subscribe/post?u=b6281a8c8660a40e246de37d1&amp;id=e8c8222e0b" method="post" class="subscribe-form" name="mc-embedded-subscribe-form" target="_blank" novalidate="">
            <input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required="">
            <input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button">
</form>

#### Do Development Hub

Sign up for [DevelopmentHub](http://reinteractive.com/community/development_hub). We'll guide you through any issues you're having getting off the ground with your Rails app.

#### Or just

Tweet us [@reinteractive](http://www.twitter.com/reinteractive). We'd love to hear feedback on this series, do you love it? Want us to do more? Let us know!
