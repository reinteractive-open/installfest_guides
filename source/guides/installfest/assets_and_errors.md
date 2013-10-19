---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/assets_and_errors.md
---

# Assets and Errors
Welcome back to reInteractive's Ruby on Rails 15 minute blog tutorial series. If you haven't started following through the series and you're new to Rails then you might want to start with the [first post](/guides/installfest/getting_started). Today we'll be following directly on from [Part 5](/guides/installfest/understanding_migrations). If you feel confident with Rails and want to learn more about the asset pipeline, static pages and custom error pages then you can find setup instructions below.

In this article we'll be going through 3 separate topics that will round out a series of posts we've made on building a blog in Rails 3.2. Today we'll be looking at:

1. An introduction to the assets folder
2. How to make Static Pages and understanding routes
3. Customising your application error pages

Each of these topics are fairly simple so if you're at this stage of the series you should have no problems keeping up.

### Application Setup

You'll need to have been following our InstallFest blog posts starting with [http://reinteractive.net/posts/32](/guides/installfest/getting_started) and have completed [http://reinteractive.net/posts/47](/guides/installfest/understanding_migrations). If you've done this but want to start with some fresh code, you can by copying the tag that's available in the public git repository.

[https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/posts_author](https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/posts_author) which you can download to your computer [here](https://github.com/reinteractive-open/rails-3-2-intro-blog/archive/posts_author.zip).

Download the zip file, unpack it to a folder on your computer and commit it to git using the following prompt commands:

```sh
bundle install
rake db:create db:setup
git add .
git commit -m "Restarting the 15 minute blog"
```

You'll need to refer to this post if you want to [get it setup](/guides/installfest/getting_started) on Heroku.

Lets dive into writing these new features.


## Assets in Rails

We've got the foundations of a fully capable and customised blogging engine, but right now we don't really know how to add in pictures or more style into our application. We've touched on some of this with some basic styles and Zurb Foundation, and now it's time to learn more.

Assets in Rails are items that are considered static such as your images, CSS files or Javascript code. Rails provides some powerful tools for managing assets which enables you to create a performant, CDN ready, scalable application with minimal effort.

One of the best and biggest changes to Rails recently has been the [Asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html). The Asset pipeline moves static assets from the `public` folder into the `app` folder and introduces the concept of precompilation.


### Precompilation of Static Assets in Rails

Since images, stylesheets and javascript code are static and generally don't change they are often [minified](http://en.wikipedia.org/wiki/Minification_(programming)), compressed and compacted in a single file. Minifying your CSS and JavaScript removes any whitespace, newlines and often changes variable names to save as much space as possible! Concatenating CSS into a single stylesheet means that you minimize the number of HTTP requests a browser must perform to retrieve your styles. When Rails (or more correctly [Sprockets](https://github.com/sstephenson/sprockets)) compiles images, stylesheets and javascripts it will insert a fingerprint into the name which represents the contents of the file. You can read more about this in the [Asset Pipeline Rails Guide](https://github.com/sstephenson/sprockets). This might mean you end up with a file that looks like:

```
application-908e25f4bf641868d8683022a5b62f54.css
```

Mostly this functionality happens for free when you deploy your application to Heroku (deploying to other platforms can be automated using a tool like [Capistrano](https://github.com/capistrano/capistrano) but it's beyond the scope of this tutorial) but you do need to be aware of how it works because it will affect how you write some of your CSS and HTML (ERB). Because every asset is fingerprinted it means that when you, for instance, link to, or embed an image within your HTML or CSS it means you need to use the provided Rails helper rather than hard-coding the name.

**Creating an img tag in your HTML(ERB)**

```erb
<%= image_tag "rails.png" %>

```

**Placing a background image in your CSS(ERB)**

```css
.class { background-image: url(<%= asset_path 'image.png' %>) }
```

**and in SASS/SCSS**

```
image-url("rails.png") becomes url(/assets/rails.png)
image-path("rails.png") becomes "/assets/rails.png".
```



The best resource to read on this is the [Asset Pipeline Rails Guide](http://guides.rubyonrails.org/asset_pipeline.html) (specifically [this](http://guides.rubyonrails.org/asset_pipeline.html#coding-links-to-assets) section).

That's a lot of background, so lets continue on with coding.

## Creating a static page

One of the things missing from our blog are some static pages that aren't specifically part of the blog but might describe the author(s). Lets go and create an About page.

One of the techniques we might use to do this is to simply create a static html page and place it in the `public` folder. While this would work it would mean that we'd lose any styling and wouldn't be able to put dynamic content into our about page at all. Instead we'll create a pages controller, wire up a route manually and create the view for it. This is a very quick process:

Naturally we should first create a test.

### Creating a failing feature spec

Since this is a fairly simple, high-level feature often it would go untested but since we're being good developers we'll implement a straight-forward Acceptance test in the form of a feature spec. Create a file `spec/features/static_pages_spec.rb` and make it look like:

```ruby
require 'spec_helper'

feature 'Browsing Static Pages' do
  context 'the about page' do
    scenario 'it is browseable from the header' do
      visit root_path

      click_link 'About me'

      expect(page.status_code).to eq 200
    end
  end
end
```

What we're doing here is instructing our in-memory browser to navigate to the `root_path` then click the 'About me' link and check that the page returned has a status code of 200 (which is success).

Run that spec with `rspec spec/features/static_pages_spec.rb` and you'll get the following error:

```sh
Failures:

  1) Browsing Static Pages the about page it is browseable from the header
     Failure/Error: click_link 'About me'
     ActionController::RoutingError:
       No route matches [GET] "/about"
     # ./spec/features/static_pages_spec.rb:8:in `block (3 levels) in <top (required)>'

Finished in 0.03137 seconds
1 example, 1 failure
```

This failure just means our page didn't load. We're ready to go ahead and implement our about page now.

### Implementing the controller

Open your terminal, start your rails server (using `rails s`) then open another terminal and create your controller. Open Sublime and create a file `app/controllers/pages_controller.rb` with the following contents:

```ruby
class PagesController < ApplicationController
  def about
  end
end
```

What we're doing here is creating a `Pages` controller with the action of `about`. This about method has nothing in it, but in Rails it automatically assumes you'll be rendering a view of the same name. If you don't call the `render` method in a controller it will automatically attempt to render `app/views/<controller>/<action>.html.erb`, in this case it will attempt to render `app/views/pages/about.html.erb`.

### Wire up the route

Right now this controller isn't accessible. We'd like it to be at `/about` so let's go and create that route. Open `config/routes.rb` and update it to look like:

```ruby
QuickBlog::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'posts#index'

  resources :posts do
    resources :comments, :only => [:create]
  end

  get '/about', :to => 'pages#about'
end
```

Note that if you named your application something besides quick_blog then you should only add the line:

```ruby
get '/about', :to => 'pages#about'
```

What this does is it tells the Rails router to pass any HTTP GET requests directed at `/about` to the `pages#about` action. This shorthand is just the PagesController about method we created earlier.

Save the routes file and rerun our spec with `rspec spec/features/static_pages_spec.rb` and we'll receive another different error:

```sh
Failures:

  1) Browsing Static Pages the about page it is browseable from the header
     Failure/Error: click_link 'About me'
     ActionView::MissingTemplate:
       Missing template pages/about, application/about with {:locale=>[:en], :formats=>[:html], :handlers=>[:erb, :builder, :coffee, :arb]}. Searched in:
         * "/Users/artega/dev/reinteractive/quick_blog/app/views"
```

If you open your browser at this time and navigate to http://localhost:3000/about you'll receive exactly the same error in your browser. What this error says is that we don't have a template for our action. Create an empty file at: `app/views/pages/about.html.erb` (the pages folder doesn't exist yet) and rerun your test (you can refresh your browser too). This time the test passes so we're ready to put some content into our view. Open `app/views/pages/about.html.erb` and update it to look like:

```html
 <h1>About me</h1>

 <p>
   I'm a new Rails developer just learning all these cool things.
 </p>
 <p>
   What was most significant about the lunar voyage was not that man set foot on the Moon but that they set eye on the earth.
   Here men from the planet Earth first set foot upon the Moon. July 1969 ActionDispatch. We came in peace for all mankind.
   Dinosaurs are extinct today because they lacked opposable thumbs and the brainpower to build a space program.
 </p>
```

This is mostly just filler text so update it to be whatever you please.

That's our first static page. One of the big benefits was that our styling, header and footers didn't need to be implemented in our static page so we could focus entirely on the content. This is because all that other stuff is provided by our layout file in `app/layouts/application.html.erb`

Lets move along to customising our error pages but first we should commit our work.

```sh
git add .
git commit -m "about me page implemented"
```

## Custom Error Pages

One final thing that we haven't customised on our personal website are custom error messages. One important aspect of running any web application is accepting that users will encounter errors and we should be making sure our error pages provide the user with a nice experience. There are 3 error pages that we need to customise:

* 404 - Not Found. This error occurs when the user tries to access something that doesn't exist.
* 422 - Unprocessable Entity. This occurs when the server can't make the change that the user requests. Basically this is an error that is caused by the user submitting something that the server refuses to handle.
* 500 - Internal Server Error. This normally occurs when there's a bug or error within the code itself.

These pages are accessible at:

* 404 - [http://localhost:3000/404](http://localhost:3000/404)
* 422 - [http://localhost:3000/422](http://localhost:3000/422)
* 500 - [http://localhost:3000/500](http://localhost:3000/500)

Normally, in development mode you won't see these error pages when an error occurs. This is because Rails will give you extra debugging information to help your development. If you navigate to [http://localhost:3000/doesntexist](http://localhost:3000/doesntexist) you'll see an error indicating that there's been a "Routing Error". However in Production mode this would look like the 404 page linked above. We can force Rails to show the production-style error pages durign development mode by changing a configuration variable. If you open `config/environments/development.rb` and change `config.consider_all_requests_local` to be equal to false (then restart your Rails server) you'll see the error pages instead of the debugging ones.

One more important thing to realise is that by default the error pages are simply the static HTML pages in the `./public/` folder. If you customise the `public/404.html` file that will be your new Not Found error page. However there are a couple of small problems.

1. We can't use the asset pipeline in these static pages. We could put images and other assets into the public folder but this is starting to split out application. But this starts to split our applicaiton up. If we make a style change in our application we'd like this to be reflected in our error pages too.
2. We might want to include our header and footer navigation into our error pages, but doing this would mean that we'd have to duplicate this code into our static error pages.

Luckily there is a simpler way.

### Configuring your application

First of all we'll instruct Rails that when an error occurs we'd like to use our own application's router to handle the error. Open `config/application.rb` and add the following configuration directive:

```ruby
config.exceptions_app = self.routes
```

Your entire application.rb should look like:

```ruby
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module QuickBlog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.exceptions_app = self.routes
  end
end
```

Save that file and next we'll configure our router to handle a 404 Not Found error. Open `config/routes.rb` and make it look like:

```ruby
QuickBlog::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => 'posts#index'

  resources :posts do
    resources :comments, :only => [:create]
  end

  get '/about', :to => 'pages#about'

  match '/404', :to => 'errors#not_found'
end
```

Notice that we've added a 404 route and wired it to the ErrorController#not_found action. This controller doesn't exist so we should create it. Create a file `app/controllers/errors_controller.rb` which should look like:

```ruby
class ErrorsController < ApplicationController
  def not_found
  end
end
```

Finally we need to create the view. Create a file `app/views/errors/not_found.html.erb` with the following contents:

```html
  <h1>404 not found</h1>
```

If we navigate to [http://localhost:3000/404](http://localhost:3000/404), however, we still see the Rails default error page. This is just because we still have the `public/404.html` file. Delete it, refresh your browser and you'll see our custom error page. Let's make it a bit cooler.

Download [this image](http://i.imgur.com/q3078Bs.jpg) and save it as `app/assets/images/404.jpg`. Open `app/views/errors/not_found.html.erb` and update it to be:

```erb
  <h1>404 not found</h1>
  <%= image_tag '404.jpg' %>
```

What we've done here is added an image to our asset bundle, and then referenced it using the `image_tag` helper method which will be aware of the fingerprint that the image will get when it's compiled for production use.

### Adding the other two error pages

Open your `errors_controller.rb` file and update it to look like:

```ruby
class ErrorsController < ActionController::Base
  layout 'application'

  def not_found
  end

  def internal_error
  end

  def unprocessable_entity
  end
end
```

We've made a couple of changes here.

1. We no longer inherit from ApplicationController. This means we're less likely to get problems if we have a code issues in ApplicationController.
2. Because we no longer inherit from ApplicationController we need to setup our layout properly.
3. We've added in two new actions. One for 500 errors and one for 422 errors.

Next we'll update our routes file. Open `app/routes.rb` and add in the following two routes:

```ruby
  match '/500', :to => 'errors#internal_error'
  match '/422', :to => 'errors#unprocessable_entity'
```

Finally create two views:

Create `app/views/errors/internal_error.html.erb` with the contents:

```html
  <h1>500</h1>
```

And create `app/views/errors/unprocessable_entity.html.erb` with the contents:

```html
  <h1>422</h1>
```

Both these files are just placeholders. It's up to you to customise them for your own application!

Next we need to delete `public/500.html` and `public/422.html`. Now if you navigate to [http://localhost:3000/422](http://localhost:3000/422) and [http://localhost:3000/500](http://localhost:3000/500) you'll see your new error pages.

### Testing your error pages with "real" fake errors

We haven't written a spec for these error pages, and it's true they're quite difficult to test in that way. Instead we're going to manually check that we get what we expect.

First we'll setup our development environment to show us production style errors. Open `config/environments/development.rb` and set `config.consider_all_requests_local       = false`. Restart your rails server.

In your browser navigate to: [http://localhost:3000/doesntexist](http://localhost:3000/doesntexist) and you'll see our custom 404 page. Next we'll force an error to occur by raising one. By raising this error we'll force Rails to show the 500 custom page. Open `app/controllers/posts_controller.rb` and update it to look like:

```ruby
class PostsController < ApplicationController
  def index
    raise 'test'
    @posts = Post.published

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.atom
    end
  end

  def show
    @post = Post.published.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
end
```

Notice that we've added a `raise 'test'` method call. This will raise a RuntimeError. Open your browser and navigate to [http://localhost:3000/](http://localhost:3000). You'll see our very simple, but custom, 500 page.

Open `app/controllers/posts_controller.rb` and change it back to what it was:

```ruby
class PostsController < ApplicationController
  def index
    @posts = Post.published

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.atom
    end
  end

  def show
    @post = Post.published.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
end
```

And then open `config/environments/development.rb` and change `config.consider_all_requests_local` back to `true`. Restart your rails server.

## Wrapping up

What we've learned about in this article is:

1. The asset pipeline and using images in ERB and CSS. We used an image on our custom error page too!
2. How to create a static page and wire it up in your routes file.
3. How to create truly custom error pages.

## Committing

We should commit to git now.

```sh
git add .
git rm public/404.html public/422.html public/500.html
git commit -m "Custom error pages"
```

## Next Steps

If you've come this far and you're interested in more training, or just most posts you've got a few options:

#### Sign up to our Training mailing list.

Just put your email below and we'll let you know if we have anything more for you. We hate spam probably more than you do so you'll only be contacted by us and can unsubscribe at any time:

<form action="http://reinteractive.us4.list-manage.com/subscribe/post?u=b6281a8c8660a40e246de37d1&amp;id=e8c8222e0b" method="post" class="subscribe-form" name="mc-embedded-subscribe-form" target="_blank" novalidate="">
            <input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required="">
            <input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button">
</form>

#### Do Development Hub

Sign up for [DevelopmentHub](http://reinteractive.net/service/development_hub). We'll guide you through any issues you're having getting off the ground with your Rails app.

#### Or just

Tweet us [@reinteractive](http://www.twitter.com/reinteractive) (or me [@lgarvey](http://www.twitter.com/lgarvey)). We'd love to hear feedback on this series, do you love it? Want us to do more? Let us know!
