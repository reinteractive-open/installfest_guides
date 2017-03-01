---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest41/admin_and_markdown.md
---

# Admin and Markdown

## Adding ActiveAdmin and Markdown support to Rails

Welcome back to reinteractive's Ruby on Rails 15 minute blog tutorial series.
If you haven't started following through the series and you're new to Rails then you might want to start with the [first post](/guides/installfest41/getting_started). Today we'll be following directly on from [Part 3](/guides/installfest41/testing_the_blog). If you feel confident with Rails but want to learn more about ActiveAdmin and/or Markdown you can find some instructions on getting the code set up properly below.

## Installing an Administration System

One of the big problems with our blog is that we're using HTTP Basic
Authentication to prevent anyone from creating and editing blog posts and that
the links to perform these actions are right there in the blog. Instead we'd
prefer to have an admin panel where we could manage our blog posts. We could
build one from scratch but there's a fantastic gem called
[ActiveAdmin](https://github.com/gregbell/active_admin) which we can use to
easily give us what we want.

### Application Setup

You'll need to have been following our InstallFest blog posts starting with
[http://reinteractive.com/posts/32](/guides/installfest41/getting_started) and
have completed
[http://reinteractive.com/posts/42](/guides/installfest41/testing_the_blog). If
you've done this but want to start with some fresh code, you can by copying the
tag that's available in the public git repository.

[https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/admin_markdown_complete](https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/admin_markdown_complete)
which you can download to your computer
[here](https://github.com/reinteractive-open/rails-3-2-intro-blog/archive/admin_markdown_complete.zip).

Download the zip file, unpack it to a folder on your computer and commit it to
git using the following prompt commands:

```sh
bundle install --without=production
rake db:create db:setup
git add .
git commit -m "Restarting the 15 minute blog"
```

You'll need to refer to this post if you want to [get it
setup](/guides/installfest41/getting_started) on Heroku.

Lets dive into installing ActiveAdmin.

### Installing ActiveAdmin

Open your `Gemfile` and add the following lines to the bottom of the file:

```ruby
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'devise'
```

Then in your terminal run `bundle install --without=production` to install
ActiveAdmin. Once bundle has finished installing you will need to cofigure
ActiveAdmin by running:

```sh
rails generate active_admin:install
rake db:migrate
```

Finally we need to restart our rails server as we have made some changes to the
database and rails environment. Change to the terminal window where you are
running rails server, stop it with `Ctrl-c` and then restart it with `rails s`.

Now you can open your browser to
[http://localhost:3000/admin](http://localhost:3000/admin) and log into your
new admin interface using the default credentials: `admin@example.com` and
`password`.

### Implement a failing test

We're about to start implementing some functionality which means we should
first write a test. This test will fail until we finish implementing our new
feature.

Open `spec/features/managing_posts_spec.rb` and change the contents of this
file to match:

```ruby
require 'spec_helper'

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

  end

end
```

As an admin user we'd expect to be able to log into the admin panel, click a
'Posts' link and create a post or edit an existing one.

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

These scenarios fail because we haven't created the posts section of our admin
panel yet. Let's do that now.

Run: `rails generate active_admin:resource Post`, then open `app/admin/post.rb`
and add `permit_params :title, :body` at the top so it looks like:

```ruby
ActiveAdmin.register Post do

  permit_params :title, :body

end
```

You can open up your browser and manually check that our changes work did what
you want, but we will re-run the spec (`rspec
    spec/features/managing_posts_spec.rb`) to be sure.

Finally, we'll be editing and adding an additional feature spec aimed at the
user interface of our application:

```ruby
require 'spec_helper'

feature 'Managing blog posts' do

  scenario 'Guests cannot create posts' do
    visit root_path
    expect(page).to_not have_link 'New Post'
  end


  context 'as an admin user' do
    ...
  end

end
```

Saving and then running this spec with `rspec
spec/features/managing_posts_spec.rb` should result in this error:

```sh
Failures:

  1) Managing blog posts Guests cannot create posts
     Failure/Error: expect(page).to_not have_link 'New Post'
     Capybara::ExpectationNotMet:
       expected not to find link "New Post", found 1 match: "New Post"
     # ./spec/features/managing_posts_spec.rb:7:in `block (2 levels) in <top (required)>'
```

If you look at this scenario, what we're checking is that a guest cannot create
a post. Specifically we want to ensure that there isn't a link called "New
Post" on the post index page. Currently this link exists so we experience our
test failure.


We can fix this scenario by opening: `app/views/posts/index.html.erb` and
deleting:

```erb
<%= link_to 'New Post', new_post_path %>
```

Save that and rerun our spec which should pass or "go green".

Some of you might already be protesting that we still have the backend code for
adding a post and all we've done is remove the link in the HTML, and you're
completely correct.  We need to remove the code from our controller and
configure our routes so that the only way to create or edit a post is in the
admin panel.

Open: `app/controllers/posts_controller.rb` and delete all the methods except
for index and show! You can also delete the authenticate method and the
before_filter line. Your PostsController should look like the following when
you've finished:

```ruby
class PostsController < ApplicationController
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

Since we've made a large change to one of our main controllers now would be a
good time to run our entire test suite. You'll actually see that everything
passes but there's a curious new spec that we didn't create. This was generated
automatically for you when you installed ActiveAdmin. Since there's no
functionality in there that we wrote we're going to simply delete the spec. On
OSX or Linux run `rm spec/models/admin_user_spec.rb` and on windows run `del
spec\models\admin_user_spec.rb`.

### Cleaning up and Committing

We're at a good spot! We've created an admin panel and wrote a test before even
started implementing it. Thanks to the power of ActiveAdmin we were able to
implement it extremely quickly, don't be misled into thinking that all Rails
apps are this simple though. In any case we should run all our tests to ensure
that everything is working, then commit our code.

Run: `rspec`

Ensure everything passes then run:

```sh
git add .
git commit -m "added ActiveAdmin and a Posting admin interface"
```

## Adding Markdown formatting support to posts

One feature we'd love to have on our blog is the ability to author our blog
posts using Github-style
[Markdown](https://help.github.com/articles/github-flavored-markdown). Luckily
doing this in Ruby is really easy and integrating it in Rails should only take
a few lines of code. We'll be using the excellent
[redcarpet](https://github.com/vmg/redcarpet) markdown engine, and the
[rouge](https://github.com/jayferd/rouge) code highlightning utility.

Note to people who are following along and can't compile gems with native
extensions. You can skip following section and use the pure Ruby
[Maruku](https://github.com/bhollis/maruku) gem for markdown support instead.
You can head to: [http://git.io/9h-eeQ](http://git.io/9h-eeQ) to find a guide
on how to do this next section using the Maruku gem instead.

First, open your `Gemfile` and add the following lines at the bottom:

```ruby
gem 'redcarpet'
gem 'rouge'
```

Then in your terminal run `bundle install --without=production` to install them

Now lets get started by writing a failing test for our markdown service first.

### Writing a failing MarkdownService spec

We're going to be creating a class for our Rails application that takes
markdown formatted text and returns HTML. There is some disagreement in the
Rails community as to where custom code should be placed. Some people prefer to
use the `lib` folder, but I prefer to put application code in
`app/<directory>`. In this case we'll be creating a service so we'll first be
making two folders: `app/services` and `spec/services`. Also create a file
`spec/services/markdown_service_spec.rb`. This test will look like:

```ruby
require 'spec_helper'

describe MarkdownService do
  it { should be_a MarkdownService }
end
```

This is the most basic spec that simply states that there should be a class
called `MarkdownService`. Run this spec with `rspec spec/services` you'll
receive an error:

```sh
spec/services/markdown_service_spec.rb:3:in `<top (required)>': uninitialized constant MarkdownService (NameError)
```

This simply tells us that we haven't created the class yet. Create a file
`app/services/markdown_service.rb` with the contents:

```ruby
class MarkdownService
end
```

And rerun our spec with `rspec spec/services`. This time the spec will pass.
Obviously this class doesn't do anything yet so we'll need to write another
test. Open `spec/services/markdown_service_spec.rb` and we'll write the test
for a render method.

The contents of this spec file will look like:

```ruby
require 'spec_helper'

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
      Redcarpet::Markdown.stub(:new) { markdown_engine }
    end

    it 'should delegate to the markdown engine' do
      # Set up the expectation of what our code should accomplish
      markdown_engine.should_receive(:render).with(content)
      MarkdownService.new.render(content)
    end
  end
end
```

This is a pretty big jump. But effectively this test is saying that the
`markdown_engine` will receive the render command with the content argument.
Then we call `MarkdownService#render`. There's definitely some advanced Ruby
magic going on here and it's totally fine if for the moment you don't
understand it fully. Also don't expect to be able to always TDD new code. Often
you need to prototype the implementation before you write the test.

Save the spec file and run your spec again. This time you'll receive another
failure so it's time to open the class we're testing again
(`app/services/markdown_service.rb`) and update the contents to:

```ruby
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

Re-running our spec everything should now pass.

### As a user I want to write Posts in Markdown

We've implemented a utility class for converting a markdown string into HTML,
  but we still need to properly integrate that into our Rails application. We
  should write a feature spec to make sure that this feature works properly.
  Create a file: `spec/features/writing_posts_spec.rb` with the following
  content.

```ruby
require 'spec_helper'

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

    page.should have_link 'Example.com link'
  end
end
```

What we're automating here is logging into the Admin panel, creating a post
with a markdown link, navigating to the post we've just created and then
checking that the post is rendered correctly in HTML. When we run this new spec
(using `rspec spec/features/writing_posts_spec.rb`) we are told:

```sh
expected to find link "Example.com link" but there were no matches
```

The problem is that right now our blog application just spits out the text
roughly as entered into the database. The quickest way of doing this is to give
our model the ability to convert it's contents to HTML. Let's write a test for
that.

Open: `spec/models/post_spec.rb` and update it to read:

```ruby
require 'spec_helper'

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
      MarkdownService.stub(:new) { markdown_service }
    end

    it 'should convert its body to markdown' do
      markdown_service.should_receive(:render).with('post body')
      Post.new(body: 'post body').content
    end
  end
end
```

What we've done here is added a test for a content method which will convert
the body of the Post object into HTML using the MarkdownService we wrote
earlier. Since we've already tested the MarkdownService we'll stub it out just
like we stubbed out the markdown engine itself in our MarkdownService test.

Run that spec (using `rspec spec/models/post_spec.rb`) and notice that it's
failing. We still need to provide the implementation to make this test pass.

Open: `app/models/post.rb` and provide the implementation for the render
method:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title

  has_many :comments

  validates_presence_of :body, :title

  def content
    MarkdownService.new.render(body)
  end
end
```

Save this and re-run our post model spec and observe that everything now
passes!

At this stage if we run all our specs (simply type `rspec`) we'll see we still
only have 1 failure. There's only 1 line of code needed to make this feature
spec pass so lets open: `app/views/posts/_post.html.erb` and update it to use
the `Post#content` method we wrote earlier.

```erb
 <h2><%= link_to_unless_current post.title, post %></h2>
 <%= post.content.html_safe %>
```

One thing to note is that since we want to render the HTML generated by our
markdown engine as HTML and not have it be automatically escapped by the Rails
view we need to convert it to a SafeBuffer using the html_safe method call.

Save that and rerun all our specs again (using `rspec`). Success! All our specs
pass and we've implemented that entire feature without even opening the browser
once. Implementing a feature in this way feels very liberating and can be very
fast. It means that as a developer you can focus on the implementation and
leave the front-end UI code for later (or for a specialist).

### Installing a stylesheet for code highlighting

Note: if you used Maruku instead of Redcarpet you can skip this section.

One great thing about the Redcarpet/Rouge combo is that it fully supports
Github style markdown including code blocks. We just need to install a
stylesheet which will support it.

Download:
[https://raw.github.com/richleland/pygments-css/master/github.css](https://raw.github.com/richleland/pygments-css/master/github.css)
into `vendor/assets/stylesheets`, then open
`app/assets/stylesheets/foundation_and_overrides.scss` and add the following
line to the bottom:

```ruby
@import 'github';
```

This informs the Rails asset pipeline that you'd like to include the code
stylesheet you just downloaded into your application.

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

Up next we'll add features to your blog and learn more about Rails migrations.
Click [here](/guides/installfest41/understanding_migrations) to check it out
and continue your Rails adventure.

If you're interested in more training from reinteractive or just want to give
us some feedback on this you can leave a comment below or:

#### Sign up to our Training mailing list.

Just put your email below and we'll let you know if we have anything more for
you. We hate spam probably more than you do so you'll only be contacted by us
and can unsubscribe at any time:

<form action="http://reinteractive.us4.list-manage.com/subscribe/post?u=b6281a8c8660a40e246de37d1&amp;id=e8c8222e0b" method="post" class="subscribe-form" name="mc-embedded-subscribe-form" target="_blank" novalidate="">
            <input type="email" value="" name="EMAIL" class="email" id="mce-EMAIL" placeholder="email address" required="">
            <input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button">
</form>

#### Do Development Hub

Sign up for [DevelopmentHub](http://reinteractive.com/community/development_hub).
We'll guide you through any issues you're having getting off the ground with
your Rails app.

#### Or just

Tweet us [@reinteractive](http://www.twitter.com/reinteractive). We'd love to hear feedback on this
series, do you love it? Want us to do more? Let us know!
