#A bit about Ruby and Rails

##What is Ruby?
Ruby is a dynamic, general-purpose programming language.

###Some background on Ruby
Ruby was created by Yukihiro Matsumoto in Japan ~ 20 years ago. He designed the programming language not for its performance or speed, but for programmer happiness.

##What is Rails?
Rails is a web framework built using the Ruby language.

It emphasizes the use of well-known software engineering patterns including convention over configuration (CoC), don't repeat yourself (DRY), the active record pattern, and model–view–controller (MVC).

Rails is an opinionated framework, providing lots of defaults which make your life easier and make your web-app more secure.

##A web request in Rails
Like all web frameworks Rails starts with the request from the client. The client is probably a browser but could be another program or a utility like curl.

The important parts here are the HTTP verb "GET", and the path "/posts". Using the HTTP verb is an important part of being RESTful, keeping Rails semantically aligned with HTTP and allows us to have cleaner URLs.

A http client issues a request to the server:

![Web request](/images/ruby_rails/web_request_1.png)

Our request is accepted by the Rails router (located in config/routes.rb) and then forwarded onto the correct controller and action according to the rules the application programmer has put in there.

At any time you can type rake routes on your command line and see a list of routes your application will respond to. If your application can't respond to a request it will return a HTTP 404 not found response instead.

Rails handles the request, using the router to send the request to the correct controller and action. The router is in config/routes.rb

![Web request](/images/ruby_rails/web_request_2.png)

Here we see the controller has received the request and gathers data from the model/s, then renders the view template. Finally it returns the compiled HTML back to the browser.

This is still fairly standard with how things work in any MVC-based web framework.

The controller has access to the the request at all times but it's more common to see the controller be only concerned with the params of the request. The params of a request are the query parameters (they are in the URL after the ?) or the post params (sent as part of the request itself).

To learn more about Rails routing check out the [Routing guide](http://guides.rubyonrails.org/routing.html).

The controller action receives the request, gathers together information from the database and renders the response which is sent back to the client.

![Web request](/images/ruby_rails/web_request_3.png)

##Controllers
Controllers are the "C" in MVC and live in app/controllers. By convention they are named as a pluralised version of whatever "resource" (database model) it deals with. So if your controller handles the Post model it will be called PostsController and be in the file app/controllers/posts_controller.rb

```
class PostsController < ApplicationController
end
```

When you create a new Rails application it creates an ApplicationController which is used for common behaviour between your separate controllers.

Actions in a controller are the methods that deal with specific web-requests for that controllers resource. By convention there are seven resourceful actions: #index, #new, #create, #show, #edit, #update and #destroy

```
class PostsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
```

These default actions (or methods) represent CRUD - create, read, update and delete. By convention here is what each of those default resourceful actions do:

**index:** returns a list of things, in this case a list of posts.

**new:** returns a form allowing a new thing to be created, in this case a new post.

**create:** the form from the new action does a HTTP POST to the create action which uses the parameters from the form to create a thing, in this case a post.

**show:** shows a thing in this case a post. The thing it shows is determined by the id provided in the URL.

**edit:** returns a form allowing a thing to be edited. Similar to the new action but operates on an existing thing.

**update:** the edit form sends a PUT or PATCH request to this action which will update the thing according to the parameters.

**destroy:** destroys a thing. This uses the HTTP DELETE verb and the thing deleted is provided in the URL.

An important skill to learn is to try and stick to just using these default resourceful actions. This way your application will be able to grow naturally without your controllers becoming difficult to maintain.

You can find [more info on controllers here](http://guides.rubyonrails.org/action_controller_overview.html).

##Models and ActiveRecord
ActiveRecord is an object to relational mapper or ORM. It converts the tables in our database to Ruby objects which can be easily used in our Rails applications. It also provides us a simply query-interface which can be used instead of SQL.

This means you use your models to interact with your database. Models live in app/models.

```
class Post < ActiveRecord::Base
end
```

When Rails boots it reads the database structure and creates the attributes on this model depending on what is in the database.

```
p = Post.find(1) # find the post with an id of 1
p.id             #=> 1
p.title          #=> "Test title"
```

The code in your model can be focused on validations, or model specific business logic.

###Programming Models
Models are used to contain business logic which is related to that particular model. Validations are a good example. If you have a requirement that each Post must have a body field filled out then you would write this:

```
class Post < ActiveRecord::Base
  validates_presence_of :body
end
```

This can mirror a database-constraint, but it can also do different things. For example you might want to specify the format of an email address:

```
class User < ActiveRecord::Base
  validates_presence_of :email
  validates_format_of :email, with: /@/ # email must have a @ symbol in it.
end
```

##Views
Views in Rails are similar to what other frameworks might call templates. Each view contains the HTML we're going to be generating and also some Ruby code which can be used to repeat elements or insert dynamic data into the view. They live in app/views. Rails expects your views to be in a certain location depending on the controller action being executed.

By convention views are located in app/views and by convention the default view for each action is determined by the name of the controller and the name of the action. Views can also be reused by splitting common sections into "partials" which can be inserted into other views:
```
<%= render 'posts/some_partial' %>
```

Rails also has an application layout which holds all the common stuff surrounding each page in your application. These global files are located in app/views/layouts and the default layout file will be in app/views/layouts/application.html.erb

By default Rails uses ERB to embed Ruby code inside our HTML templates.

##ERB
ERB is the templating "language" used for Rails. It stands for "Embedded Ruby".

Ruby code:

```
<% ruby.code %>
```

Outputting the result of some Ruby:

```
<%= Post.find(1).body %>
```

So a simple HTML ERB template might look like:

```
<div class="posts">
  <% @posts.each do |post| %>
    <p><%= post.title %></p>
  <% end %>
</div>
```

##Assets
In Rails static assets (images, Javascript and CSS) are stored in app/assets. The appropriate directories will be generated for you when you create your Rails application. Rails natively handles CSS-preprocessors like SASS and the JavaScript-targetting CoffeeScript. Use of these is optional but personally recommended.

Rails has a technology called the Asset Pipeline which compiles SASS and CoffeeScript, concatenates and minifies CSS and JavaScript so only 1 request is required from your HTML to load your CSS and JavaScript. The Asset Pipeline also adds a "fingerprint" to your static assets which makes them very cache friendly. Integrating Rails with a content delivery network (CDN) is very easy.

You can [read more about the assets here](http://guides.rubyonrails.org/asset_pipeline.html).
