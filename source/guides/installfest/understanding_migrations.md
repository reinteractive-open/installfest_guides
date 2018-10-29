---
github_url: https://github.com/reinteractive-open/installfest_guides/tree/master/source/guides/installfest/understanding_migrations.md
---

# Understanding Migrations
Welcome back to reinteractive's Ruby on Rails 15 minute blog tutorial series.
If you haven't started following through the series and you're new to Rails then you might want to begin with [Getting Started](/guides/installfest/getting_started). Today we'll be following directly on from [Part 5](/guides/installfest/admin_and_markdown). If you feel confident with Rails and want to learn more about building a feature that requires migrations then instructions for doing so are provided below.

In this instalment we'll be learning more about how to manage your database structure through migrations. Firstly, though, we need to learn about Active Record, which is a key concept in understanding databases within the context of a Rails environment.

## Active Record

Active Record is the M in [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) - the model - which is the layer of the system responsible for communicating directly with your database and for representing business data and logic.

Rails Active Record is the [Object/Relational Mapping (ORM)](https://en.wikipedia.org/wiki/Object-relational_mapping) layer supplied with Rails. It closely follows the standard ORM model:

- tables map to classes,
- rows map to objects
- columns map to object attributes.

Rails Active Records provide an interface between the tables in a relational database and the Ruby program code that manipulates database records.

### A post can be published

The first feature we're going to work on is the ability for Posts to have a published state. This means we can author our blog posts in the admin panel, then publish them at a later date giving us a little more control over our blogging system. Lets get started.

Run the following in your terminal:

`rails generate migration AddPublishedToPost published:boolean`

Open the migration generated. It will look like, __but won't be the same as__, `db/migrate/20130510023357_add_published_to_post.rb` and add `default: false` to the change.

```ruby
# db/migrate/20130510023357_add_published_to_post.rb
class AddPublishedToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :published, :boolean, default: false
  end
end
```

After saving this, we need to add these changes to our development database by running a migration. Enter the following into your terminal:

```sh
rails db:migrate
```

`default: false` means that any records without the published flag set (including those that were created before we added this flag) will have the published flag as false.

To allow ActiveAdmin to use mass-assignment to update our Post database record (read more about mass-assignment in the [Rails Security Guide](http://guides.rubyonrails.org/v3.2.8/security.html#mass-assignment)), we need to configure Rails to allow this.

Open `app/admin/post.rb` and add `:published` to the permitted params as shown:

```ruby
# app/admin/post.rb
ActiveAdmin.register Post do

  permit_params :title, :body, :published

end
```

The `permit_params` line lists all the attributes in the model which are accessible for mass-assignment. You can read more about this here: [Strong Parameters](https://github.com/rails/strong_parameters).

But… there's a problem. Unpublished blogs are still visible to the public. We'll need to go ahead and write another feature scenario to ensure that this rule is enforced for the public section of our application too.

### Unpublished posts aren't visible!

Open `app/controllers/posts_controller.rb` and modify the index action to look like:

```ruby
def index
  @posts = Post.where(published: true)

  respond_to do |format|
    format.html # index.html.erb
    format.json { render json: @posts }
    format.atom
  end
end
```

(Don't forget to save your file.)

If you're confused as to what an "action" is, it's just a method in a controller that processes a particular request. Each request is "wired" from a URL to a controller by the routes file in your config folder.

Now edit the show action to look like:

```ruby
# app/controllers/posts_controller.rb

...

def show
  @post = Post.where(published: true).find(params[:id])

  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @post }
  end
end
```

(Don't forget to save your file.)

### Fix failing specs

If you re-run your specs (`rails spec`), you will see we have a number of failures. This is because, when we create our test blog posts, we have not set the published flag. Let's do that now.

Open `spec/features/post_comments_spec.rb` and make it look like the following:

```ruby
# spec/features/post_comments_spec.rb
require 'rails_helper'

RSpec.feature "Posting Comments", :type => :feature do
  background do
    @post = Post.create(title: 'Awesome Blog Post', body: 'Lorem ipsum dolor sit amet', published: true)
  end

  scenario "Visit root_path" do
    @user = User.create(email:'test@example.com', password: 'secret')

    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'

    visit post_path(@post)

    comment = 'This post is just filler text. Ripped off!'

    fill_in 'comment_body', with: comment
    click_button 'Add comment'

    expect(page).to have_content comment
  end
end
```

Open `spec/features/writing_posts_spec.rb` and make it look like the following:

```ruby
# spec/features/writing_posts_spec.rb
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
    page.check 'Published'
    click_button 'Create Post'

    visit post_path(Post.last)
    save_and_open_page

    expect(page).to have_link 'Example.com link'
  end
end
```

Finally, open `spec/features/reading_blog_spec.rb` and make it look like the following:

```ruby
# spec/features/reading_blog_spec.rb
require 'rails_helper'

feature 'Reading the Blog' do
  background do
    Post.destroy_all
    @post = Post.create(title: 'Awesome Blog Post', body: 'Lorem ipsum dolor sit amet', published: true)
    Post.create(title: 'Another Awesome Post', body: 'Lorem ipsum dolor sit amet', published: true)
    @user = User.create
    sign_in @user
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

In each of these three specs, we have either added `published: true` to the `Post.create()` line or checked the 'Published' checkbox (`page.check 'Published'`).

### Red, Green, Refactor!

Success! Our code works, but we've still got a little work to do. There's some code duplication there that we can fix. Instead of both the `index` and `show` actions both using the code `where(published: true)` we'd like to move that into a method. Since it's a database query we can use an [ActiveRecord scope](http://guides.rubyonrails.org/active_record_querying.html#scopes) to limit what is being returned to only the published posts.

Open `app/models/post.rb` and update it to look like:

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  validates :body, :title, presence: true

  scope :published, -> { where(published: true) }

  def content
    MarkdownService.new.render(body)
  end
end
```

What we've done here is moved the common code from both actions into a scope on the Post model itself. If, at a future time, we need to make the published logic more complicated (ie publishing at a specific time) we only have to change one place.

Now that we've got a scope on the model to use we should update both actions to use it.

Update `app/controllers/posts_controller.rb` to look like:

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  # GET /posts
  # GET /posts.json
  # GET /posts.atom
  def index
    @posts = Post.published

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
      format.atom
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.published.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end
end
```

(Don't forget to save your file.)

Return to your browser at [http://localhost:3000](http://localhost:3000) and check to see that everything is OK.

### Cleaning up

We've implemented a new feature and everything seems to work. We're ready to commit our changes.

```sh
git add .
git commit -m "Posts can be published"
```

## Posts should have an Author!

Another feature that would be awesome to have is for Posts to have an author. The author would simply be the Admin User that creates the post. We should write a test first:

### Viewing a post should display the author

Open `spec/features/reading_blog_spec.rb` and change the contents to be:

```ruby
# spec/features/reading_blog_spec.rb
require 'rails_helper'

feature 'Reading the Blog' do
  context 'for an unpublished post' do
    background do
      email = 'admin@example.com'
      password = 'password'
      @admin = AdminUser.create(email: email, password: password)

      @post = Post.create(title: 'Unpublished Post', body: 'Lorem ipsum dolor sit amet', author: @admin)
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
      email = 'admin@example.com'
      password = 'password'
      @admin = AdminUser.create(email: email, password: password)

      @post = Post.create(title: 'Awesome Blog Post', body: 'Lorem ipsum dolor sit amet', published: true, author: @admin)
      Post.create(title: 'Another Awesome Post', body: 'Lorem ipsum dolor sit amet', published: true, author: @admin)
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

end
```

(Don't forget to save your file.)

When we run this spec we get some failures which we're going to ignore since they're telling us we have work to do!

### Running the migration and wiring up Rails

First we need to create a migration. We do this using the `rails generate` command (which can be shortened to `rails g`) like so:

```sh
rails g migration AddAuthorToPost author_id:integer
```

```sh
rails db:migrate
```

Now open `app/models/post.rb` and update it to inform Rails that a Post belongs to an author but that the Author's model is named "AdminUser".

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  belongs_to :author, class_name: "AdminUser"

  validates :body, :title, presence: true

  scope :published, -> { where(published: true) }

  def content
    MarkdownService.new.render(body)
  end
end
```

We'll also open `app/models/admin_user.rb` and do the reverse side of the association by informing Rails that an AdminUser has many posts.

```ruby
# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  devise :database_authenticatable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :posts

  def name
    email
  end

end
```

(Don't forget to save your files.)

Note that we've also created a name method in the AdminUser so that ActiveAdmin can use that in the admin panel.

### Editing the view to include the author

If we run our feature spec now with `rspec spec/features/reading_blog_spec.rb` we get an error that lets us know we're close. We don't have the right text on our web page.

Open: `app/views/posts/_post.html.erb` and add ` <h3> Posted by: <%= post.author.name %></h3>` under the `<h2>`

```erb
<h2><%= link_to_unless_current post.title, post %></h2>
<h3> Posted by: <%= post.author.name %></h3>
<%= post.content.html_safe %>
```

(Don't forget to save your file.)

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

What is happenening is that some posts **don't have** authors!

If the author is nil, it cannot have a name so we get that error. Ultimately this error is because not all our posts have authors and we didn't use defensive programming techniques.

Let's address our sloppy programming!

### Fixing sloppy programming with tests!

Since we can't rely on the author existing, but we can rely on the post existing we'll create a method on the post that returns the name of the author.

But first we should write a test for this.

Open `spec/models/post_spec.rb` and add a new test to it:

```ruby
# spec/models/post_spec.rb

...

describe '#author_name' do
  context 'when the author exists' do
    let(:author) { AdminUser.new }
    subject { Post.new(author: author).author_name }

    before { allow(author).to receive(:name).and_return("Jane Smith") }

    it { should eq "Jane Smith" }
  end

  context 'when the author doesnt exist' do
    subject { Post.new.author_name }

    it { should eq "Nobody" }
  end
end
```

(Don't forget to save your file.)

When you run this spec (`rspec spec/models/post_spec.rb`) you get the following error:

```sh
NoMethodError:
  undefined method `author_name' for #<Post:0x007fef40352a28>
```

Which is expected since you haven't made the author_name method yet in your Post model.

Open `app/models/post.rb` and update the Post model to look like:

```ruby
# app/models/post.rb
class Post < ApplicationRecord
  has_many :comments, dependent: :destroy

  belongs_to :author, class_name: "AdminUser"

  validates :body, :title, presence: true

  scope :published, -> { where(published: true) }

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

(Don't forget to save your file.)

Now when we run our `post_spec.rb` again we get no errors.

Next we need to update our Admin panel to allow users to set the author on posts.

First we update the 'writing blog posts' scenario in our tests in `spec/features/writing_posts_spec.rb` to look like this:

```ruby
# spec/features/writing_posts_spec.rb
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
    select('admin@example.com', from: 'Author')

    fill_in 'post_title', with: 'New Blog Post'
    fill_in 'post_body', with: "[Example.com link](http://example.com/)"
    check 'post_published'
    click_button 'Create Post'

    visit post_path(Post.last)

    expect(page).to have_link 'Example.com link'
    expect(page).to have_content 'Posted by: admin@example.com'
  end
  
end
```

Then we make them pass by opening `app/admin/post.rb` and adding `:author` and `:author_id` to the permitted params as shown:

```ruby
# app/admin/post.rb
ActiveAdmin.register Post do

  permit_params :title, :body, :published, :author, :author_id

end
```

All that's left to do now is update our view too!

Open `app/views/posts/_post.html.erb` and set the contents to be:

```erb
<h2><%= link_to_unless_current post.title, post %></h2>
<h3> Posted by: <%= post.author_name %></h3>
<%= post.content.html_safe %>
```

(Don't forget to save your files.)

You'll notice that instead of calling the author model directly we're using the method we just created instead.

We have a couple of final things to fix.

Open `spec/features/post_comments_spec` and change the contents to be:

```ruby
# spec/features/post_comments_spec.rb
require 'rails_helper'

feature 'Posting Comments' do
  background do
    @user = User.create(email: 'user@example.com', password: 'password')
    @admin = AdminUser.create(email: 'admin@example.com', password: 'password')

    @post = Post.create!(title: 'Awesome Blog Post', body: 'Lorem ipsum dolor sit amet', published: true, author: @admin)

    log_in_user
  end

  def log_in_user(email = 'user@example.com', password = 'password')
    reset_session!
    visit new_user_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  # Note this scenario doesn't test the AJAX comment posting.
  scenario 'Posting a comment' do
    visit post_path(@post)

    comment = 'This post is just filler text. Ripped off!'

    fill_in 'comment_body', with: comment
    click_button 'Add comment'

    expect(page).to have_content comment
  end
end
```

Open `spec/features/managing_posts_spec.rb` and change the contents to be:

```ruby
# spec/features/managing_posts_spec.rb
require 'rails_helper'

feature 'Managing blog posts' do

  scenario 'Guests cannot create posts' do
    visit root_path
    expect(page).to_not have_button 'New Post'
  end

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

    scenario 'Publishing an existing blog' do
      @post = Post.create(title: 'New Post', body: "Hello world!", published: true, author: @admin)
      @post.save!

      visit admin_post_path(@post)
      click_link 'Edit Post'

      check 'Published'
      click_button 'Update Post'

      expect(page).to have_content 'Post was successfully updated'
      expect(Post.last.published?).to be true
    end

    context 'with an existing blog post' do
      background do
        @post = Post.create(:title => 'Awesome Blog Post', :body => 'Lorem ipsum dolor sit amet', published: true, author: @admin)
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

Let's run our entire test suite now to check that everything is now okay.

### Cleaning up

Our tests all pass and we've implemented a new feature. It's time to commit our code again.

```sh
git add .
git commit -m "posts can have an author"
```

## Review

In this guide we implemented two features both of which required a database migration. We wrote tests for the functionality we wanted to implement and fixed some problems that occurred along the way.

## Next Steps

The next post in the series is available [here](/guides/installfest/assets_and_errors). You'll be learning about the Asset Pipeline, Static pages and Custom error pages. If you want to learn more about reinteractive's training services you can:

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
