---
github_url: https://github.com/reinteractive-open/installfest_guides/blob/develop/source/guides/installfest/admin_and_markdown.md
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

### Conflicting security checks

If you recall in the second guide, [Adding Authentication](/guides/installfest/adding_authentication), we use the devise gem to check that a user is signed in before allowing them to interact with our blog app.

Active Admin is a way for a special user, an aministrator, to go behind the scenes to administer our blog posts. To override the devise settings in this case, we need to disable the devise check for Active Admin.

Open the file `config/initializers/active_admin.rb` and add `config.skip_before_action :authenticate_user!` near the top, after the line `config.site_title = "Quick Blog"`.

The first few lines of your file should look lke this:

```ruby
ActiveAdmin.setup do |config|
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "Quick Blog"

  config.skip_before_action :authenticate_user!

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  # config.site_title_link = "/"
  ...
```

### Implement a failing test

We're about to start implementing some functionality which means we should first write a test. This test will fail until we finish implementing our new feature.

Open `spec/features/managing_posts_spec.rb` and change the contents of this file to match:

```ruby
# spec/features/managing_posts_spec.rb
require 'rails_helper'

feature 'Managing blog posts' do

  context 'as an admin user' do
    background do
      email = 'admin@example.com'
      password = 'password'
      @admin = AdminUser.create(email: email, password: password)

      log_in_admin_user
    end

    def log_in_admin_user(email = 'admin@example.com', password = 'password')
      reset_session!
      visit admin_root_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Login'
    end

    scenario 'Posting a new blog' do
      click_link 'Posts'
      click_link 'New Post'

      fill_in 'post_title', with: 'New Blog Post'
      fill_in 'post_body', with: 'This post was made from the Admin Interface'
      click_button 'Create Post'

      expect(page).to have_content 'This post was made from the Admin Interface'
    end

    context 'with an existing blog post' do
      background do
        @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet')
      end

      scenario 'Editing an existing blog' do
        visit admin_post_path(@post)

        click_link 'Edit'

        fill_in 'Title', with: 'Not really Awesome Blog Post'
        click_button 'Update Post'

        expect(page).to have_content 'Not really Awesome Blog Post'
      end
    end

  end

end
```

(Don't forget to save your file.)

As an admin user we'd expect to be able to log into the admin panel, click a 'Posts' link and create a post or edit an existing one.

```sh
Failures:

  1) Managing blog posts as an admin user Posting a new blog
     Failure/Error: click_link 'Posts'
     Capybara::ElementNotFound:
       Unable to find link "Posts"
     # ./spec/features/managing_posts_spec.rb:23:in `block (3 levels) in <top (required)>'

  2) Managing blog posts as an admin user with an existing blog post Editing an existing blog
     Failure/Error: visit admin_post_path(@post)
     NoMethodError:
       undefined method `admin_post_path' for #<RSpec::Core::ExampleGroup::Nested_1::Nested_1::Nested_1:0x007fcc703ee6c8>
     # ./spec/features/managing_posts_spec.rb:39:in `block (4 levels) in <top (required)>'
```

These scenarios fail because we haven't created the posts section of our admin panel yet. Let's do that now.

Run: `rails generate active_admin:resource Post`, then open `app/admin/post.rb` and add `permit_params :title, :body` at the top so it looks like:

```ruby
ActiveAdmin.register Post do

  permit_params :title, :body

end
```

(Don't forget to save your file.)

You can open up your browser and manually check that our changes work did what you want, but we will re-run the spec (`rspec spec/features/managing_posts_spec.rb`) to be sure.

Finally, we'll be editing and adding an additional feature spec aimed at the user interface of our application:

```ruby
require 'rails_helper'

feature 'Managing blog posts' do

  scenario 'Guests cannot create posts' do
    visit root_path
    expect(page).to_not have_button 'New Post'
  end

  context 'as an admin user' do
    ...
  end

end
```

Saving and then running this spec with `rspec spec/features/managing_posts_spec.rb` should result in this error:

```sh
Failures:

  1) Managing blog posts Guests cannot create posts
     Failure/Error: expect(page).to_not have_link 'New Post'
     Capybara::ExpectationNotMet:
       expected not to find link "New Post", found 1 match: "New Post"
     # ./spec/features/managing_posts_spec.rb:7:in `block (2 levels) in <top (required)>'
```

If you look at this scenario, what we're checking is that a guest cannot create a post. Specifically we want to ensure that there isn't a button called "New Post" on the post index page. Currently this button exists so we experience our test failure.

We can fix this scenario by opening: `app/views/posts/index.html.erb` and deleting:

```erb
<%= button_to 'New Post', new_post_path, method: :get, class: "btn-primary" %>
```

Save that and rerun our spec which should pass or "go green".

Some of you might already be protesting that we still have the backend code for adding a post and all we've done is remove the link in the HTML, and you're completely correct. We need to remove the code from our controller and configure our routes so that the only way to create or edit a post is in the admin panel.

Open: `app/controllers/posts_controller.rb` and delete all the methods except for index and show. You can also delete the authenticate method and the before_filter line. Your PostsController should look like the following when you've finished:

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

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

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
end
```

Save these changes.

Since we've made a large change to one of our main controllers now would be a good time to run our entire test suite.

You'll see that everything passes but there's a curious new spec that we didn't create. This was generated automatically for you when you installed ActiveAdmin. Since there's no functionality in there that we wrote we're going to simply delete the spec.

On OSX or Linux run `rm spec/models/admin_user_spec.rb` and 

on Windows run `del spec\models\admin_user_spec.rb`.

### Display the correct signed-in user on each page

Up until now, we have had only one type of user: the user created by the devise gem. Now that we have introduced an admin user, we need to change the link on each page that displays our signed-in status to ensure that it is checking for both devise and Active Admin users.

Fortunately, with Rails this is easy to do. `app/views/layouts/application.html.erb` contains text that is included on _every_ page in our application.

Change the contents of `app/views/layouts/application.html.erb` to make it look like the following:

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
    <p class="navbar-text pull-right">
    <% if admin_user_signed_in? %>
      Logged in as <strong><%= current_admin_user.email %></strong>.
      <%= link_to 'Edit profile', edit_admin_admin_user_path(current_admin_user.id), :class => 'navbar-link' %> |
      <%= link_to "Logout", destroy_admin_user_session_path, method: :delete, :class => 'navbar-link'  %>
    <% elsif user_signed_in? %>
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

### Exploring Active Admin in the browser

We've made many changes and confirmed that everything works as expected by writing RSpec tests. To check out the real power of Active Admin, we need to visit the browser!

First we need to restart our rails server as we have made some changes to the database and rails environment. Change to the terminal window where you are running rails server, stop it with `Ctrl-c` and then restart it with `rails server`.

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

We're at a good spot! We've created an admin panel and wrote a test before we even started implementing it. Thanks to the power of ActiveAdmin we were able to implement it extremely quickly, but don't be misled into thinking that all Rails apps are this simple though.

In any case we should run all our tests to ensure that everything is working, then commit our code.

Run: `rspec`

Ensure everything passes then run:

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

After saving this file, rerun our spec with `rspec spec/services`. This time the spec will pass.

Obviously this class doesn't do anything yet. One of the key principals of [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) is that we only need write the minimum code to make the test pass. This is the 'green' part of 'Red, Green, Refactor'. Once the test is passing, we can add more tests and flesh out the functionality.

Open `spec/services/markdown_service_spec.rb` and we'll write the test for a render method.

The contents of this spec file will look like:

```ruby
# spec/services/markdown_service_spec.rb
require 'rails_helper'

describe MarkdownService do
  it { should be_a MarkdownService }

  describe '#render' do
    let(:content) { "anything" } # we don't care what content gets rendered

    # the markdown engine is just a test double we can monitor in our test
    let(:markdown_engine) { double('Markdown') }

    before do
      # Stub out the redcarpet markdown engine
      # In our test we can assume it works properly
      # since it's a well tested library.
      allow(Redcarpet::Markdown).to receive(:new).and_return(markdown_engine)
    end

    it 'should delegate to the markdown engine' do
      # Set up the expectation of what our code should accomplish
      expect(markdown_engine).to receive(:render).with(content)
      MarkdownService.new.render(content)
    end
  end
end
```

(Don't forget to save your file.)

This is a pretty big jump. But effectively this test is saying that the `markdown_engine` will receive the render command with the content argument. Then we call `MarkdownService#render`. There's definitely some advanced Ruby magic going on here and it's totally fine if you don't understand it fully. Also don't expect to be able to always TDD new code. Often you need to prototype the implementation before you write the test.

Save the spec file and run your spec again. This time you'll receive another failure so it's time to open the class we're testing again (`app/services/markdown_service.rb`) and update the contents to:

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

Re-running our spec everything should now pass.

### As a user I want to write Posts in Markdown

We've implemented a utility class for converting a markdown string into HTML, but we still need to properly integrate that into our Rails application. We should write a feature spec to make sure that this feature works properly. Create a file: `spec/features/writing_posts_spec.rb` with the following content.

```ruby
require 'rails_helper'

feature 'Writing blog posts' do
  background do
    email = 'admin@example.com'
    password = 'password'
    @admin = AdminUser.create(email: email, password: password)

    log_in_admin_user
  end

  def log_in_admin_user(email = 'admin@example.com', password = 'password')
    reset_session!
    visit admin_root_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Login'
  end

  scenario 'Writing a blog post in markdown' do
    click_link 'Posts'
    click_link 'New Post'

    fill_in 'post_title', with: 'New Blog Post'
    fill_in 'post_body', with: "[Example.com link](http://example.com/)"
    click_button 'Create Post'

    visit post_path(Post.last)

    expect(page).to have_link 'Example.com link'
  end
end
```

(Don't forget to save your file.)

What we're automating here is logging into the Admin panel, creating a post with a markdown link, navigating to the post we've just created and then checking that the post is rendered correctly in HTML. When we run this new spec (using `rspec spec/features/writing_posts_spec.rb`) we are told:

```sh
expected to find link "Example.com link" but there were no matches
```

The problem is that right now our blog application just spits out the text roughly as entered into the database. The quickest way of doing this is to give our model the ability to convert it's contents to HTML. Let's write a test for that.

Open: `spec/models/post_spec.rb` and update it to read:

```ruby
# spec/models/post_spec.rb
require 'rails_helper'

describe Post do
  describe 'validations' do
    subject(:post) { Post.new } # sets the subject of this describe block
    before { post.valid? }      # runs a precondition for the test/s

    [:title, :body].each do |attribute|
      it "should validate presence of #{attribute}" do
        expect(post.errors[attribute].size).to be >= 1
        expect(post.errors.messages[attribute]).to include "can't be blank"
      end
    end
  end

  describe '#content' do
    # Create a double of the MarkdownService
    let(:markdown_service) { double('MarkdownService') }

    before do
      # We don't want to use the actual MarkdownService
      # since it's tested elsewhere!
      allow(MarkdownService).to receive(:new).and_return(markdown_service)
    end

    it 'should convert its body to markdown' do
      expect(markdown_service).to receive(:render).with('post body')
      Post.new(body: 'post body').content
    end
  end
end
```

(Don't forget to save your file.)

What we've done here is added a test for a content method which will convert the body of the Post object into HTML using the MarkdownService we wrote earlier. Since we've already tested the MarkdownService we'll stub it out just like we stubbed out the markdown engine itself in our MarkdownService test.

Run that spec (using `rspec spec/models/post_spec.rb`) and notice that it's failing. We still need to provide the implementation to make this test pass.

Open: `app/models/post.rb` and provide the implementation for the render method:

```ruby
class Post < ApplicationRecord
  has_many :comments

  validates_presence_of :body, :title

  def content
    MarkdownService.new.render(body)
  end
end
```

Save this and re-run our post model spec and observe that everything now passes!

At this stage if we run all our specs (simply type `rspec`) we'll see we still only have one failure. There's only one line of code needed to make this feature spec pass so let's open: `app/views/posts/_post.html.erb` and update it to use the `Post#content` method we wrote earlier.

```erb
<h2><%= link_to_unless_current post.title, post %></h2>
<%= post.content.html_safe %>
```

(Don't forget to save your file.)

One thing to note is that since we want to render the HTML generated by our markdown engine as HTML and not have it be automatically escaped by the Rails view we need to convert it to a SafeBuffer using the html_safe method call.

Save that and rerun all our specs again (using `rspec`). Success! All our specs pass and we've implemented that entire feature without even opening the browser once. Implementing a feature in this way feels very liberating and can be very fast. It means that as a developer you can focus on the implementation and leave the front-end UI code for later (or for a specialist).

### Cleaning up

Commit all those changes with:

```sh
git add .
git commit -m "Added markdown support for blog posts"
```

This might be a good time to push to Heroku too. Do that by typing:

```sh
git push heroku master
```

Then apply database migrations:

```sh
heroku run rails db:migrate
```

The seed file created by ActiveAdmin only creates the default admin user in the development environment, so the `db:seed` command used earlier won't have any effect. Instead, to create an admin user in production, start a Heroku Rails console:

```sh
heroku run rails console
```

Then manually execute the command to create the model record (substitute a more complex password here as the Heroku site is publicly accessible!):

```ruby
AdminUser.create!(email: 'admin@example.com', password: 'pick-a-secure-password', password_confirmation: 'pick-a-secure-password')
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
