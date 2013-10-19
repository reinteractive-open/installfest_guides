---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/understanding_migrations.md
---

# Understanding Migrations
Welcome back to reInteractive's Ruby on Rails 15 minute blog tutorial series. If you haven't started following through the series and you're new to Rails then you might want to start with the [first post](/guides/installfest/getting_started). Today we'll be following directly on from [Part 4](/guides/installfest/admin_and_markdown). If you feel confident with Rails and want to learn more about building a feature that requires migrations then instructions for doing so are provided below.

In this installment we'll be learning more about how to manage your database structure through migrations. 

The first feature we're going to work on is the ability for Posts to have a published state. This means we can author our blog posts in the admin panel, then publish them at a later date giving us a little more control over our blogging system. Lets get started.

### Application Setup

You'll need to have been following our InstallFest blog posts starting with [http://reinteractive.net/posts/32](/guides/installfest/getting_started) and have completed [http://reinteractive.net/posts/42](/guides/installfest/admin_and_markdown). If you've done this but want to start with some fresh code, you can by copying the tag that's available in the public git repository.

[https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/before_published_and_author](https://github.com/reinteractive-open/rails-3-2-intro-blog/tree/before_published_and_author) which you can download to your computer [here](https://github.com/reinteractive-open/rails-3-2-intro-blog/archive/before_published_and_author.zip).

Download the zip file, unpack it to a folder on your computer and commit it to git using the following prompt commands:

```sh
bundle install
rake db:create db:setup
git add .
git commit -m "Restarting the 15 minute blog"
```

You'll need to refer to this post if you want to [get it setup](/guides/installfest/getting_started) on Heroku.

Lets dive into writing these new features.

### Write a feature spec

We'll start by writing a spec for this new feature. It's often good to start with a feature spec since it will let you scope the new functionality without having to know all the in-depth implementation details ahead of time.

Open `spec/features/managing_posts_spec.rb` and add the following scenario to the 'with an existing blog post` context.

```ruby
scenario 'Publishing an existing blog' do
  visit admin_post_path(@post)
  click_link 'Edit Post'

  check 'Published'
  click_button 'Update Post'

  expect(page).to have_content 'Post was successfully updated'
  expect(Post.last.published?).to be_true
end
```

The final spec should look like: [https://gist.github.com/lengarvey/5551994](https://gist.github.com/lengarvey/5551994)

When you've saved the spec you can run it with `rspec spec/features/managing_posts_spec.rb`. Naturally it will faily since we haven't implemented any of the functionality to support it yet. Lets get started with that now.

### A post can be published

`rails g migration AddPublishedToPost published:boolean`

Open the migration generated. It will look like __but won't be the same as__ `db/migrate/20130510023357_add_published_to_post.rb`

```ruby
class AddPublishedToPost < ActiveRecord::Migration
  def change
    add_column :posts, :published, :boolean, :default => false
  end
end
```

After saving this we need to migrate our development database and prepare our test database. Run the following: 

```sh
rake db:migrate db:test:prepare
```

Now when we run `rspec spec/features/managing_posts_spec.rb` we get a new error:

```sh
ActiveModel::MassAssignmentSecurity::Error:
  Can't mass-assign protected attributes: published
```

What this error means is that ActiveAdmin tried to use mass-assignment to update our Post database record and we haven't configured our Post model to accept this. This error is helping us to protect our application from a common form of security vulnerability which you can read about in the [Rails Security Guide](http://guides.rubyonrails.org/security.html#mass-assignment).

To fix the error open: `app/models/post.rb` and update it to:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title, :published

  has_many :comments

  validates_presence_of :body, :title

  def content
    MarkdownService.new.render(body)
  end
end
```

The `attr_accessible` line here lists out the attributes in the model which are accessible for mass-assignment. Note that in Rails 4 this is changing to use a different technique called [Strong Parameters](https://github.com/rails/strong_parameters).

After saving `app/models/post.rb` we re-run our spec (`rspec spec/features/managing_posts_spec.rb`) and everything passes!

But… there's a problem. Unpublished blogs are still visible to the public. We'll need to go ahead and write another feature scenario to ensure that this rule is enforced for the public section of our application too!

### Unpublished posts aren't visible!

Open `spec/features/reading_blog_spec.rb` and change the contents to be:

```ruby
require 'spec_helper'

feature 'Reading the Blog' do
  context 'for an unpublished post' do
    background do
      @post = Post.create(:title => 'Unpublished Post', :body => 'Lorem ipsum dolor sit amet')
    end

    scenario 'it does not appear in the index' do
      visit root_path

      expect(page).to_not have_content 'Unpublished Post'
    end

    scenario 'it cannot be visited directly' do
      expect(lambda {
        visit post_path(@post)
      }).to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'for a published post' do
    background do
      @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet', :published => true)
      Post.create(:title => 'Another Awesome Post', :body => 'Lorem ipsum dolor sit amet', :published => true)
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
end
```

What we've done here is split our test into two separate contexts. One for posts that are published, and one for posts that aren't. We expect to see different behaviour from both contexts.

When we run this spec (`rspec spec/features/reading_blog_spec.rb --order default`) we get two failures:

```sh
  1) Reading the Blog for an unpublished post it does not appear in the index
     Failure/Error: expect(page).to_not have_content 'Unpublished Post'
       expected not to find text "Unpublished Post" in "Your Blog Name Menu Github Twitter About me Listing posts Unpublished Post Lorem ipsum dolor sit amet Powered by: rails-3-2-intro-blog Developed at: InstallFest 2013"
     # ./spec/features/reading_blog_spec.rb:12:in `block (3 levels) in <top (required)>'

  2) Reading the Blog for an unpublished post it cannot be visited directly
     Failure/Error: }).to raise_error(ActiveRecord::RecordNotFound)
       expected ActiveRecord::RecordNotFound but nothing was raised
     # ./spec/features/reading_blog_spec.rb:18:in `block (3 levels) in <top (required)>'
```

The first error here indicates that unpublished blogs appear in our blog post index, and the second indicates that the blog is directly accessible even though it hasn't been published. Lets go and fix these problems.

Open: `app/controllers/posts_controller.rb` and modify the index action to look like:

```ruby
def index
  @posts = Post.where(:published => true)

  respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @posts }
    format.atom
  end
end
```

If you're confused as to what an "action" is. It's just a method in a controller that processes a particular request. Each request is "wired" from a URL to a controller by the routes file in your config folder.

If you then run our spec again (`rspec spec/features/reading_blog_spec.rb`) you'll notice that the first error has gone and we're left with only the second. We can fix this by editing the show action.

Change the show action to look like:

```ruby
def show
  @post = Post.where(:published => true).find(params[:id])

  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @post }
  end
end
``` 

### Red, Green, Refactor!

Success! Our spec now passes, but we've still got a little work to do. There's some code duplication there that we can fix. Instead of both the `index` and `show` actions both using the code `where(:published => true)` we'd like to move that into a method. Since it's database query we can use an [ActiveRecord scope](http://guides.rubyonrails.org/active_record_querying.html#scopes) to limit what is being returned to only the published posts. Open `app/models/post.rb` and update it to look like:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title, :published

  has_many :comments

  validates_presence_of :body, :title

  scope :published, where(:published => true)

  def content
    MarkdownService.new.render(body)
  end
end
```

What we've done here is moved the common code from both actions into a scope on the Post model itself. If at a future time we need to make the published logic more complicated (ie publishing at a specific time) we only have to change one place.

Now that we've got a scope on the model to use we should update both actions to use it. Update `app/controllers/posts_controller.rb` to look like:

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

Re-run our feature spec again after making this change (`rspec spec/features/reading_blog_spec.rb`) and everything should still be working perfeclty.

### Cleaning up

We've implemented a new feature and everything seems to work. Lets run our entire test suite just to make sure. Run: `rspec --order default`.

Oh no! We have some errors to fix.

```sh
  1) Posting Comments Posting a comment
     Failure/Error: visit post_path(@post)
     ActiveRecord::RecordNotFound:
       Couldn't find Post with id=1 [WHERE "posts"."published" = 't']
     # ./app/controllers/posts_controller.rb:13:in `show'
     # ./spec/features/post_comments_spec.rb:10:in `block (2 levels) in <top (required)>'

  2) Writing blog posts Writing a blog post in markdown
     Failure/Error: visit post_path(Post.last)
     ActiveRecord::RecordNotFound:
       Couldn't find Post with id=1 [WHERE "posts"."published" = 't']
     # ./app/controllers/posts_controller.rb:13:in `show'
     # ./spec/features/writing_posts_spec.rb:28:in `block (2 levels) in <top (required)>'
```

They both look like similar errors, but we'll deal with them one by one. First open `spec/features/post_comments_spec.rb` and notice that we're attempting to visit a blog post that isn't published. Update the spec to look like:

```ruby
require 'spec_helper'

feature 'Posting Comments' do
  background do
    @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet', :published => true)
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

Next we open `spec/features/writing_posts_spec.rb`. This time we need to set the post to be published properly. Remember that each of these feature specs is automating a theoretical tester clicking around in a browser. An actual user would just click the "Published" checkbox in order to make sure their new blog post is published. Lets update the spec to reflect that:

```ruby
require 'spec_helper'

feature 'Writing blog posts' do
  background do
    email = 'admin@example.com'
    password = 'password'
    @admin = AdminUser.create(:email => email, :password => password)

    log_in_admin_user
  end

  def log_in_admin_user(email = 'admin@example.com', password = 'password')
    reset_session!
    visit admin_root_path
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Login'
  end

  scenario 'Writing a blog post in markdown' do
    click_link 'Posts'
    click_link 'New Post'

    fill_in 'post_title', :with => 'New Blog Post'
    fill_in 'post_body', :with => "[Example.com link](http://example.com/)"
    check 'post_published'
    click_button 'Create Post'

    visit post_path(Post.last)

    expect(page).to have_link 'Example.com link'
  end
end
```

Save that and now rerunning our test suite shows we have no errors! We're ready to commit.

```sh
git add .
git commit -m "Posts can be published"
```

## Posts should have an Author!

Another feature that would be awesome to have is for Posts to have an author. The author would simply be the Admin User that creates the post. We should write a test first:

### Viewing a post should display the author

Open up: `spec/features/reading_blog_spec.rb` and update the 'for a published post' context to look like:

```ruby
  context 'for a published post' do
    background do
      email = 'admin@example.com'
      password = 'password'
      @admin = AdminUser.create(:email => email, :password => password)

      @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet', :published => true, :author => @admin)
      Post.create(:title => 'Another Awesome Post', :body => 'Lorem ipsum dolor sit amet', :published => true, :author => @admin)
    end

    scenario 'Reading the blog index' do
      visit root_path

      expect(page).to have_content 'Awesome Blog Post'
      expect(page).to have_content 'Another Awesome Post'
      expect(page).to have_content 'Posted by: admin@example.com'
    end

    scenario 'Reading an individual blog' do
      visit root_path
      click_link 'Awesome Blog Post'

      expect(current_path).to eq post_path(@post)
    end
  end
```

The entire spec should look like: [https://gist.github.com/5552474](https://gist.github.com/5552474)

When we run this spec we get two failures which we're going to ignore since they're telling us we have work to do!

### Running the migration and wiring up Rails

First we need to create a migration. We do this using the `rails generate` command (which can be shortened to `rails g`) like so:

```sh
rails g migration AddAuthorToPost author_id:integer
rake db:migrate db:test:prepare
```

Now open `app/models/post.rb` and update it to inform Rails that a Post belongs to an author but that the Author's model is named "AdminUser".

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title, :published, :author, :author_id

  has_many :comments

  belongs_to :author, :class_name => "AdminUser"

  validates_presence_of :body, :title

  scope :published, where(:published => true)

  def content
    MarkdownService.new.render(body)
  end
end
```

We'll also open `app/models/admin_user.rb` and do the reverse side of the association by informing Rails that an AdminUser has many posts.

```ruby
class AdminUser < ActiveRecord::Base
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :posts

  def name
    email
  end
end
```

We've also created a name method in the AdminUser so that ActiveAdmin can use that in the admin panel.

### Editing the view to include the author

If we run our feature spec now with `rspec spec/features/reading_blog_spec.rb` we get an error that lets us know we're close. We don't have the right text on our web page.

Open: `app/views/posts/_post.html.erb`

```erb
 <h2><%= link_to_unless_current post.title, post %></h2>
 <h3> Posted by: <%= post.author.name %></h3>
 <%= post.content.html_safe %>
```

Then run our spec again and it passes! But we have a problem. When we run our full test suite we get a couple of interesting errors:

```sh
ActionView::Template::Error:
  undefined method `name' for nil:NilClass
# ./app/views/posts/_post.html.erb:2:in `_app_views_posts__post_html_erb___569628799803112878_70171546453660'
```

This "undefined method x for nil:NilClass" is a very common and confusing error for newer Ruby and Rails developers. The problem is in our view and it's in the following code:

```erb
<%= post.author.name %>
```

What is happenening is that some posts **don't have** authors! If the author is nil, it cannot have a name so we get that error. Ultimately this error is because not all our posts have authors and we didn't use defensive programming techniques. Let's address our sloppy programming.

### Fixing sloppy programming with tests!

Since we can't rely on the author existing, but we can rely on the post existing we'll create a method on the post that returns the name of the author. But we should write a test for this first. Open `spec/models/post_spec.rb` and add a new test to it:

```ruby
describe '#author_name' do
  context 'when the author exists' do
    let(:author) { AdminUser.new }
    subject { Post.new(:author => author).author_name }

    before { author.stub(:name) { "Jane Smith" } }

    it { should eq "Jane Smith" }
  end

  context 'when the author doesnt exist' do
    subject { Post.new.author_name }

    it { should eq "Nobody" }
  end
end
```

The whole spec should look like: [https://gist.github.com/5552601](https://gist.github.com/5552601).

When you run this spec (`rspec spec/models/post_spec.rb`) you get the following error:

```sh
NoMethodError:
  undefined method `author_name' for #<Post:0x007fef40352a28>
```

Which is expected since you haven't made the author_name method yet in your Post model. Open `app/models/post.rb` and update the Post model to look like:

```ruby
class Post < ActiveRecord::Base
  attr_accessible :body, :title, :published, :author, :author_id

  has_many :comments

  belongs_to :author, :class_name => "AdminUser"

  validates_presence_of :body, :title

  scope :published, where(:published => true)

  def content
    MarkdownService.new.render(body)
  end

  def author_name
    if author
      author.name
    else
      "Nobody"
    end
  end
end
```

Now when we run our `post_model_spec.rb` again we get no errors. All that's left to do is update our view too!

Open `app/views/posts/_post.html.erb` and set the contents to be:

```erb
 <h2><%= link_to_unless_current post.title, post %></h2>
 <h3> Posted by: <%= post.author_name %></h3>
 <%= post.content.html_safe %>
```

You'll notice that instead of calling the author model directly we're using the method we just created instead. Let's run our entire test suite now to check that everything is now okay.

### Cleaning up

Our tests all pass and we've implemented a new feature. It's time to commit our code again.

```sh
git add .
git commit -m "posts can have an author"
```

## Review

In this article we implemented two features both of which required a database migration. We wrote tests for the functionality we wanted to implement and fixed some problems that occured along the way.

## Next Steps

The next post in the series is available [here](/guides/installfest/assets_and_errors). You'll be learning about the Asset Pipeline, Static pages and Custom error pages. If you want to learn more about reInteractive's training services you can:

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

