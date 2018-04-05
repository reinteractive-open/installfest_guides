---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/admin_and_markdown.md
---

# Admin and Markdown

## Adding ActiveAdmin and Markdown support to Rails

Welcome back to reinteractive's Ruby on Rails 15 minute blog tutorial series.
If you haven't started following through the series and you're new to Rails then you might want to begin with [Getting Started](/guides/installfest/getting_started). Today we'll be following directly on from [Part 4](/guides/installfest/finishing_a_basic_blog). If you feel confident with Rails but want to learn more about ActiveAdmin and/or Markdown you can find some instructions on getting the code set up properly below.

## Installing an Administration System

One of the big problems with our blog is that we're using HTTP Basic Authentication to prevent anyone from creating and editing blog posts and that the links to perform these actions are right there in the blog. Instead we'd prefer to have an admin panel where we could manage our blog posts. We could build one from scratch but there's a fantastic gem called [ActiveAdmin](https://github.com/activeadmin/activeadmin) that we can use to easily give us what we want.

Let's dive into installing ActiveAdmin.

### Installing ActiveAdmin

Open your `Gemfile` and add the following lines to the file:

```ruby
# Gemfile

...

gem 'inherited_resources', github: 'activeadmin/inherited_resources'
gem 'activeadmin', github: 'activeadmin'
gem 'devise'
```

(Don't forget to save your file.)

Your gemfile should now look like:
(Windows users, if you added it previously, don't forget to keep the coffee-script-source gem in the list)

```ruby
# Gemfile
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.5'
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

gem 'record_tag_helper', '~> 1.0'
gem 'responders'

gem 'inherited_resources', github: 'activeadmin/inherited_resources'
gem 'activeadmin', github: 'activeadmin'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

Then in your terminal run `bundle install --without=production` to install ActiveAdmin. Once bundle has finished installing you will need to configure ActiveAdmin by running the following commands one by one:

```sh
rails generate active_admin:install
```

```sh
rails db:migrate
```

```sh
rails db:seed
```

### Add Posts to Active Admin

We need to create the posts section of our admin panel. Let's do that now.

Run: `rails generate active_admin:resource Post`,

then open `app/admin/post.rb` and add `permit_params :title, :body` at the top so it looks like:

```ruby
# app/admin/post.rb
ActiveAdmin.register Post do

  permit_params :title, :body

end
```

(Don't forget to save your file.)

Finally we need to restart our rails server as we have made some changes to the database and rails environment. Change to the terminal window where you are running rails server, stop it with `Ctrl-c` and then restart it with `rails server`.

Now you can open your browser to [http://localhost:3000/admin](http://localhost:3000/admin) and log into your new admin interface using the default credentials: `admin@example.com` and `password`.

### Edit an existing blog post

Across the top, you should see a menu that looks like the image below:

![Active Admin Menu](/images/guides/active_admin_menu.png)

Click on 'Posts'

From there, you will see a list of the existing blog posts we have created so far, each with a link to View, Edit, and Delete.

Choose a blog post and click on Edit.

From there, make some changes and click on the 'Update Post' button at the bottom of the page.

To view your changes, return to [http://localhost:3000](http://localhost:3000)

### Create a new blog post

As above, return to [http://localhost:3000/admin](http://localhost:3000/admin) and click on 'Posts'.

This time, click on the 'New Post' button in the top right hand of the page.

Fill out the title and the body and click 'Create Post'.

Again, to view your changes, return to [http://localhost:3000](http://localhost:3000)


### Cleaning up and Committing

We're at a good spot! Thanks to the power of ActiveAdmin we were able to implement an admin panel extremely quickly, but don't be misled into thinking that all Rails apps are this simple though.

In any case we should run all our tests to ensure that everything is working, then commit our code.

Run: `rspec`

You'll see that everything passes but there's a curious new spec that we didn't create. This was generated automatically for you when you installed ActiveAdmin. Since there's no functionality in there that we wrote we're going to simply delete the spec.

On OSX or Linux run `rm spec/models/admin_user_spec.rb` and 

on Windows run `del spec\models\admin_user_spec.rb`.

Now it is time to commit our changes. Run the following in your command line:

```sh
git add .
git commit -m "added ActiveAdmin and a Posting admin interface"
```

## Adding Markdown formatting support to posts

One feature we'd love to have on our blog is the ability to author our blog posts using Github-style [Markdown](https://help.github.com/enterprise/11.10.340/user/articles/github-flavored-markdown/). Luckily doing this in Ruby is quite simple and integrating it in Rails should only take a few lines of code. We'll be using the excellent [redcarpet](https://github.com/vmg/redcarpet) markdown engine, and the [rouge](https://github.com/jneen/rouge) code highlighting utility.

Note to people who are following along and can't compile gems with native extensions: You can skip following section and use the pure Ruby [Maruku](https://github.com/bhollis/maruku) gem for markdown support instead. You can head to: [http://git.io/9h-eeQ](http://git.io/9h-eeQ) to find a guide on how to do this next section using the Maruku gem instead.

First, open your `Gemfile` and add the following lines:

```ruby
gem 'redcarpet'
gem 'rouge'
```

Then, after saving your file, in your terminal run `bundle install --without=production` to install them

Now lets get started by writing a failing test for our markdown service first.

### Writing a failing MarkdownService spec

We're going to be creating a class for our Rails application that takes markdown formatted text and returns HTML. There is some disagreement in the Rails community as to where custom code should be placed. Some people prefer to use the `lib` folder, but we prefer to put application code in `app/<directory>`. In this case we'll be creating a service so we'll first be making two folders: `app/services` and `spec/services`. Also create a file `spec/services/markdown_service_spec.rb`. This test will look like:

```ruby
# spec/services/markdown_service_spec.rb
require 'rails_helper'

describe MarkdownService do
  it { should be_a MarkdownService }
end
```

(Don't forget to save your file.)

This is the most basic spec that simply states that there should be a class called `MarkdownService`. Run this spec with `rspec spec/services` you'll receive an error:

```sh
spec/services/markdown_service_spec.rb:3:in `<top (required)>': uninitialized constant MarkdownService (NameError)
```

This simply tells us that we haven't created the class yet. Create a file `app/services/markdown_service.rb` with the contents:

```ruby
class MarkdownService
end
```

After saving this file, rerun our spec with `rspec spec/services`. This time the spec will pass. Obviously this class doesn't do anything yet so we'll need to add the functionality.

Open `app/services/markdown_service.rb` and update the contents to:

```ruby
# app/services/markdown_service.rb
require 'rouge/plugins/redcarpet'

class MarkdownService
  class HTMLWithRouge < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet # yep, that's it.
  end

  def initialize
    @markdown = Redcarpet::Markdown.new(HTMLWithRouge, fenced_code_blocks: true)
  end

  def render(text)
    @markdown.render(text)
  end
end
```

(Don't forget to save your file.)

### As a user I want to write Posts in Markdown

We've implemented a utility class for converting a markdown string into HTML, but we still need to properly integrate that into our Rails application.

The problem is that, right now, our blog application just spits out the text roughly as entered into the database. To fix this, we need to give our model the ability to convert database contents into HTML using the MarkdownService we wrote in the section above.

Open: `app/models/post.rb` and provide the implementation for the render method:

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :body, :title, presence: true

  def content
    MarkdownService.new.render(body)
  end
end
```

(Don't forget to save your file.)

So now we have a `Post#content` method to convert our database contents into HTML but we also need to update our view template to acutally use this method.

Open: `app/views/posts/_post.html.erb` and change it to the following:

```erb
<h2><%= link_to_unless_current post.title, post %></h2>
<%= post.content.html_safe %>
```

(Don't forget to save your file.)

One thing to note is that since we want to render the HTML generated by our markdown engine as HTML and not have it be automatically escaped by the Rails view we need to convert it to a SafeBuffer using the html_safe method call.

### Create a blog post using markdown

Navigate to [http://localhost:3000](http://localhost:3000) and click on the 'New Post' button.

Create a new post and include a markdown-style link. An example is provided below:

```
This blog post should include a markdown-style link. Here is a link to [google](https://www.google.com.au/).
```

Save that and view the blog post. Instead of the text `[google](https://www.google.com.au/)`, you should see instead the word 'google' as a link and clicking on it should take you to the google website. Success!

### Cleaning up

Commit all those changes with:

```sh
git add .
git commit -m "Added markdown support for blog posts"
```

This might be a good time to push to Heroku too. Do that by typing

```sh
git push heroku master
```

## Next Steps

Up next we'll add features to your blog and learn more about Rails migrations. Click [here](/guides/installfest/understanding_migrations) to check it out and continue your Rails adventure.

If you're interested in more training from reinteractive or just want to give us some feedback on this you can leave a comment below or:

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
