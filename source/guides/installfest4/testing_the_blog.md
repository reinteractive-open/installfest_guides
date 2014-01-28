---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/testing_the_blog.md
---

# Testing the Blog with RSpec
Welcome back to reInteractive's Ruby on Rails 15 minute blog tutorial series. If you haven't started following through the series and you're new to Rails then you might want to start with the [first post](/guides/installfest/getting_started). Today we'll be following directly on from [Part 2](/guides/installfest/finishing_a_basic_blog). If you feel confident with Rails but want to learn more about testing you can find some instructions on getting the code set up properly below.

## Introduction to Automated Testing
One of the biggest advantages of Rails is the community focus on testing. The Ruby and Rails communities have put a great deal of effort into building first-class tools and methods for making sure our apps are as correct as possible. With tools like RSpec and Capybara, Ruby and Rails lead the way in developing easy to use and innovative tools to support widely embraced methods like Test Driven Development (TDD), Behaviour Driven Development (BDD) and Continuous Integration (CI).

Let's start by setting up our Rails application for testing.

### Application Setup

You'll need to have been following our InstallFest blog posts starting with [http://reinteractive.net/posts/32](/guides/installfest/getting_started) and have completed [http://reinteractive.net/posts/34](/guides/installfest/finishing_a_basic_blog). If you've done this but want to start with some fresh code by copying the tag that's available in the public git repository.

[https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/part_2_complete](https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/part_2_complete) which you can download to your computer [here](https://github.com/reinteractive-open/rails-3-2-intro-blog/archive/part_2_complete.zip).

Download the zip file, unpack it to a folder on your computer and commit it to git using the following prompt commands:

```sh
bundle install
rake db:create db:setup
git add .
git commit -m "Restarting the 15 minute blog"
```

You'll need to refer to this post if you want to [get it setup](/guides/installfest/getting_started) on Heroku.

Lets dive into testing now.

### Setup
Add to `Gemfile`:

```ruby
group :test, :development do
  gem "rspec-rails", "~> 2.0"
end
```

Run `bundle install`

This will add Rspec and RSpec Rails to our Rails application. RSpec is a commonly used TDD (and BDD) testing tool which provides a special testing language (powered by Ruby) for testing existing code and for informing developers about the structure and functionality of yet to be written code!

To complete the installation run:

```sh
rails generate rspec:install
rails generate rspec:model post
rails g rspec:model comment
```

Normally if you generate a Rails entity like a controller or model then this will automatically create a spec for you, but since we've already got a bunch of code that isn't tested we have to manually generate a spec to test our comment model.

We can now run the specs we've generated. Run `rake spec`. Alternatively use the `rspec` command. You can run individual specs as follows:

`rspec spec/models/post_spec.rb`

Or all the model specs with: `rspec spec/models`. With this last example you're providing a directory for `rspec` to run, it simply runs every spec it can find in that folder and all sub-folders.

### Testing the Post

Our Post model seems fairly empty but there is already some business logic in there that we can test. Rails validations are considered business logic and are easy to test. Open `spec/models/post_spec.rb` and update it so that it looks like:

```ruby
require 'spec_helper'

describe Post do
  it 'should validate presence of title' do
    post = Post.new
    post.valid?
    expect(post.errors.messages[:title]).to include "can't be blank"
  end
end
```

Once you've saved it, run `rspec spec/models/post_spec.rb`. The test should pass with `1 example, 0 failures`. But we're not done yet. Over the lifetime of our application we'll probably be adding lots of extra functionality and our spec is very flat. We should organise it a litte better and structure it in such a way which also lets us reuse code:

```ruby
require 'spec_helper'

describe Post do
  describe 'validations' do
    subject(:post) { Post.new } # sets the subject of this describe block
    before { post.valid? }      # runs a precondition for the test/s

    [:title, :body].each do |attribute|
      it "should validate presence of #{attribute}" do
        expect(post).to have_at_least(1).error_on(attribute)
        expect(post.errors.messages[attribute]).to include "can't be blank"
      end
    end
  end
end
```


What we're doing here is splitting up the test into a "validations" section and then declaring the subject of the test. The before block will invoke some common code to be run for each test and then each test just checks that there is an error on the model, and that the error is the expected error.

RSpec is a tool that provides a nice Domain Specific Language (DSL) to write specs. The important documentation to read is for [expectations and matchers](http://rubydoc.info/gems/rspec-expectations/frames), but for the purposes of this project we'll be providing and explaining most of the test code for you.

Since we're writing a fully functional spec for code that is already written, we'll need to make sure our test actually works by intentionally "breaking" some of our code. Open `app/models/post.rb` and comment out Line 6 so your Post model looks like:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title

  has_many :comments

  # validates_presence_of :body, :title
end
```

Once you've saved the model, you can rerun the spec with `rspec spec/models/post_spec.rb`. You should receive `2 examples, 2 failures` and the error messages will be printed in your terminal. Be careful to read the error messages closely. When you're done uncomment Line 6 in `app/models/post.rb` save the file and rerun the spec to ensure that everything is passing correctly.

We'll also need to write a unit test for our comment model. Open `spec/models/comment_spec.rb` and update it to ensure that a comment will always belong to a post, and the comment will always have a body. The code to do this looks like:

```ruby
require 'spec_helper'

describe Comment do
  describe 'validations' do
    subject(:comment) { Comment.new }
    before { comment.valid? }

    [:post, :body].each do |attribute|
      it "should validate presence of #{attribute}" do
        expect(comment).to have_at_least(1).error_on(attribute)
        expect(comment.errors.messages[attribute]).to include "can't be blank"
      end
    end
  end
end
```

When you run `rspec spec/models/comment_spec.rb` you'll receive:

```sh
Failures:

  1) Comment validations should validate presence of post
     Failure/Error: expect(comment).to have_at_least(1).error_on(attribute)
       expected at least 1 error on :post, got 0
     # ./spec/models/comment_spec.rb:10:in `block (4 levels) in <top (required)>'

  2) Comment validations should validate presence of body
     Failure/Error: expect(comment).to have_at_least(1).error_on(attribute)
       expected at least 1 error on :body, got 0
     # ./spec/models/comment_spec.rb:10:in `block (4 levels) in <top (required)>'
```

If you open `app/models/comment.rb` you'll notice that there isn't any validations on our comment model. If you add `validates_presence_of :post, :body` into the class and re-run your spec you'll see the test pass and "go green". Congratulations, you've just TDD'd your first piece of application logic. One of the amazing things about working with Rails there's a very quick feedback loop between writing a failing test, making it pass and then suddenly having a full functional feature in your application. 

At this stage we've completed a small block of work, tests are passing (which you can check by running the `spec` command) so we should commit our work with: `git add .` and `git commit -m "Added spec and first model specs"`

We're not done with our tests though.

### Acceptance tests

Rails fully supports the concept of an acceptance test, which is a full-stack automated test that behaves exactly like someone opening a browser and clicking around your site. We'll be using [Capybara](https://github.com/jnicklas/capybara) primarily with [RackTest](https://github.com/jnicklas/capybara#racktest).

#### Setting up Capybara

As you probably expect by now we'll be adding a new gem to our `Gemfile`. Open the `Gemfile` and add the following lines to the bottom:

```ruby
group :test do
  gem 'capybara'
end
```

Then run `bundle install` to install the new gems. We only need Capybara for our tests, so we're creating a section specifically to ensure that Capybara is only loaded when we run our tests.

Next open `spec/spec_helper.rb` (which was created when you installed spec). Set the contents of the file to:

```ruby
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|

  # Run each test within a database transaction
  config.use_transactional_fixtures = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
```

Next we'll create our first acceptance test.

#### The first acceptance test

Create a folder: `spec/features` then create a file `spec/features/reading_blog_spec.rb` with the following contents:

```ruby
require 'spec_helper'

feature 'Reading the Blog' do
  background do
    @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet')
    Post.create(:title => 'Another Awesome Post', :body => 'Lorem ipsum dolor sit amet')
  end

  scenario 'Reading the blog index' do
    visit root_path

    expect(page).to have_content 'Awesome Blog Post'
    expect(page).to have_content 'Another Awesome Post'
  end

  scenario 'Reading an individual blog' do
    visit root_path
    click_link 'Awesome Blog Post'

    expect(current_path).to eq post_path(@post)
  end
end
```

Save this file and run it with: `rspec spec/features`. You should get `2 examples, 0 failures`. But once again there's a problem. We've written a test which passes immediately, we should make it fail to check that the test is actually checking what we want it to check. We'll open `app/views/posts/_post.html.erb` and alter the Post titles as follows:

```erb
 <h2><%= link_to_unless_current 'Blog Post', post %></h2>
 <%= simple_format post.body %>
```

Now when you rerun the spec (`rspec spec/features`) you'll receive two errors:

```sh
Failure/Error: expect(page).to have_content 'Awesome Blog Post'
  expected to find text "Awesome Blog Post"
  
Failure/Error: click_link 'Awesome Blog Post'
     Capybara::ElementNotFound:
       Unable to find link "Awesome Blog Post"
```

Undo your changes to `app/views/posts/_post.html.erb` so that it once again looks like:

```erb
 <h2><%= link_to_unless_current post.title, post %></h2>
 <%= simple_format post.body %>
```

And rerun your spec to make sure everything is okay.

### Writing more Acceptance Tests

Acceptance tests are really powerful since they are a high level description of how your application should function. By writing acceptance tests it's entirely possible to build an entire user-facing feature without opening your web-browser! But more importantly, it gives you a high level of confidence that a feature will work, and won't inadvertantly break if you make changes elsewhere.

We're going to make more acceptance tests now.

Create a file: `spec/features/post_comments_spec.rb` with the contents:

```ruby
require 'spec_helper'

feature 'Posting Comments' do
  background do
    @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet')
  end

  # Note this scenario doesn't test the AJAX comment posting.
  scenario 'Posting a comment' do
    visit post_path(@post)

    comment = 'This post is just filler text. Ripped off!'

    fill_in 'comment_body', :with => comment
    click_button 'Add comment'

    expect(page).to have_content comment
  end
end
```

Save that, then create a file: `spec/features/managing_posts_spec.rb` with the contents:

```ruby
require 'spec_helper'

feature 'Managing blog posts' do
  scenario 'Guests cannot create posts' do
    visit root_path
    click_link 'New Post'

    expect(page).to have_content 'Access denied'
  end

  scenario 'Posting a new blog' do
    visit root_path

    page.driver.browser.authorize 'admin', 'secret'
    click_link 'New Post'

    expect(page).to have_content 'New post'

    fill_in 'Title', :with => 'I love cheese'
    fill_in 'Body', :with => "It's pretty amazing, don't you think?"

    click_button 'Create Post'
    expect(page).to have_content 'I love cheese'
  end

  context 'with an existing blog post' do
    background do
      @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet')
    end

    scenario 'Editing an existing blog' do
      visit post_path(@post)

      page.driver.browser.authorize 'admin', 'secret'
      click_link 'Edit'

      fill_in 'Title', :with => 'Not really Awesome Blog Post'
      click_button 'Update Post'

      expect(page).to have_content 'Not really Awesome Blog Post'
    end
  end
end
```

Save that file. Now let's run all of our acceptance/feature specs. Open your terminal and run: `rspec spec/features`. If everything has worked you'll get something like:

```sh
......

Finished in 0.26705 seconds
6 examples, 0 failures
```

### Cleaning up

We've now tested our application with some unit tests of our models, and using acceptance tests. We've increased our confidence in our existing code and we're ready to move on to adding extra features to our blog. Before we do that though we should run all our tests and commit our code.

To run all your tests either run `rake spec` or `rspec`. Rake is a utility command which provides a common interface for interacting with your application. the `spec` task simply runs `rspec` internally. Once your tests have finished running (and they all pass!) you should commit your code. Run:

```sh
git add .
git commit -m "Adding rspec and tests for existing functionality"
```

## Next Steps

Up next we'll add in an Administration panel and convert our blog posts to Markdown format. Click [here](/guides/installfest/admin_and_markdown) to check it out and continue your Rails adventure.

If you're interested in more training from reInteractive or just want to give us some feedback on this you can leave a comment below or:

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
