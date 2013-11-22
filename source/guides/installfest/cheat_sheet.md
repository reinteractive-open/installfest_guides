
#Command and Phrase Cheat Sheet

<table  class="cheat-sheet" border=0 width=825px cellspacing=2 cellpadding=20>

	<tr>
	 	<th width ="30%">Command</th>
	 	<th width ="35%">Action</th>
	 	<th width ="35%">InstallFest Example</th>
	</tr>
	 
 	<tr>
	 	<td class="command">rails new</td>
	 	<td>This command creates a new rails app.</td>
	 	<td> rails new <i>quick_blog</i></td>
	</tr>
 
	<tr>
	 	<td class="command">cd</td>
	 	<td>Change Directory. This will open your application folder in the command line.</td>
	 	<td>cd <i>quick_blog</i></td>
	</tr>
 
	<tr>
	 	<td class="command">
	 		<strong>rails server</strong>
	 		</br>
	 		or rails s (for short)</td>
	 	<td>This will start the server so that you can view your application in your browser locally.</td>
	 	<td><p>rails s  </p><p>Open localhost:3000 in your browser to view your app locally.</p></td>
	</tr>

	<tr>
		<td class="command">
			Ctrl + c
		</td>
		<td>
			This will stop the program that is running. You will use this to stop the Rails Server.
		</td>
		<td>
			<p>
				To continue working on your application you will need to stop the Rails Server.  
			</p>
			<p>
				Once the Rails Server has been stopped you will no longer be able to view your application in your browser until it is run again.
			</p>
		</td>
	</tr>

	<tr>
	 	<td class="command">
	 		<strong>rails generate</strong> 
	 		</br>
	 		or rails g (for short)
	 	</td>
	 	<td>This will generate templates of code that you need for your app to run. This saves you from having to write the all of the code yourself.</td>
	 	<td>
	 		<p>
	 			Rails generate <i>scaffold</i> (or any generator type).
	 		</p>
	 		<p>
	 			When you type rails generate it will give you a list of generators you can use.
	 		</p>
	 	</td>
	</tr>

	<tr>
		<td class="command">scaffold</td>
		<td>This generates the code for all the things you need for a new resource. This includes models, views and controllers (MVC). It also creates the ability to do these basic actions: create a new resources, edit a resource, show a resource and delete a resource.</td>
		<td>
			<p>
				rails g scaffold <i>Post title body:text</i>
			</p>

	 		<p>
	 			‘Post title’ is the name of your scaffold, ‘body’ is the attribute and ‘text’ is the type (ie. string,integer...) of attribute that it is.
	 		</p>

	 		<p>
	 			eg. You can now create new posts, edit posts, update posts and delete posts.
	 		</p>
	 	</td>
	</tr>

	<tr>
		<td class="command">Rake</td>
		<td>
			<p>
				Rake is Ruby ‘Make’, a standalone Ruby utility.
			</p>

			<p>
				It uses 'Rakefile' and .rake files to build up a list of tasks and is used for common administration tasks.
			</p>
		</td>
		<td>
			<p><i>rake db:migrate </i></p>
			<p>This command is used to apply your migration (eg. Creating a new scaffold) to your database (db).</p>
			<p>Your database is updated overtime as you apply each migration. Eg. It started off with nothing in it, now it has a table with a title column and a body column. </p>
			<p><i>rake routes </i></p>
			<p>
				The rake routes command will give you a list of all your defined routes. This can be used to find routing problems or give you an overview of the URLs in an your app.
			</p>
		</td>
	</tr>

	<tr>
		<td class="command">
			<strong>bundle install</strong>
			</br>
			or bundle (for short)
		</td>
		<td>
			This command installs your new gems. When you add a new gem to your Gemfile you’ll need to run bundle install in your command line to install it.
		</td>
		<td>
			<p>bundle install--without=production</p>
			<p>This means don’t install production gems such as postgres.</p>
		</td>
	</tr>

 </table>

 <br>

<table class="cheat-sheet" border=1 width=825px cellspacing=2 cellpadding=20>

	<tr>
	 	<th width ="15%">Phrase</th>
	 	<th width ="42.5%">Action</th>
	 	<th width ="42.5%">InstallFest Example</th>
	</tr>
 
	<tr>
		<td class="command">Active Record</td>
		<td>Active Record is the Model part of MVC.</td>
		<td>
			class CreatePosts < ActiveRecord::Migration 
		 	<p>This migration creates your table.</p>
			class Post < ActiveRecord::Base

			 This will create a Post model, mapped to a posts (Rails will pluralize your class names to find the respective database table) table at the database.
		</td>
	</tr>

	<tr>
		<td class="command">
			:<i>symbol</i>
		</td>
		<td>
			<p>A symbol is a name used to represent something in your app.</p>
	 		<p>Symbols only keep one copy in memory (unlike strings), so they are generally used to save on memory in your application.</p>
	 	</td>
	 	<td>
	 		:title 
	 		:body
	 </td>
	</tr>

	<tr>
		<td class="command">attr_accessible</td>
		<td>Attribute accessible allows you to access an attribute outside of the instance itself.</td>
		<td>attr_accessible</td>
	</tr>

	<tr>
		<td class="command"><%= %></td>
		<td>This indicates that ruby code is to be evaluated within the HTML. It can do things such as add links.</td>
		<td>
	 		<%= link_to 'Edit', edit_post_path(@post) %>
	 	</td>
	</tr>

	<tr>
	 	<td class="command">==</td>
	 	<td>With two equal signs you can check if two things are the same. If so, true will be returned.</td>
	 	<td>
			name == "admin"
		</td>
	</tr>

	<tr>
	 	<td class="command">&&</td>
	 	<td>It is logical AND evaluates to true or false. If both are true then the condition becomes true.</td>
	 	<td> 
	 		name == "admin" && password == "secret"
		</td>
	</tr>

 	<tr>
	 	<td class="command">@attributes</td>
	 	<td>Attributes are specific properties of an object. They are instance variables of a class instance. Ruby stores the name in a @name instance variable</td>
	 	<td>
	 		@posts
		</td>
	</tr>
 
	<tr>
	 	<td class="command">Method</td>
	 	<td>Methods are capabilities of an object. A method is used to create parameterized, reusable code.</td>
	 	<td>
	 		<p>
			 	def change
			 		create_table :posts do |t|
			 		t.string :title<br>t.text :body
			 		<p>t.timestamps
			 		end
			 	end
	 		</p>
	 	</td>
	</tr>

	<tr>
	 	<td class="command">Class</td>
	 	<td>A class allows you to create objects of a particular type and to create methods that relate to those objects.</td>
	 	<td>
	 		class Post < ActiveRecord::Base
	  		attr_accessible :body, :title

	  		has_many :comments

	  		validates_presence_of :body, :title
			End
	 		<p>The "<" means one class inherits from another class.</p>
		</td>
	</tr> 

</table>
<table class="cheat-sheet"  border=1 width=825px cellspacing=2 cellpadding=20>

	<tr>
		<th width ="15%">Version Control</th>
		<th width ="42.5%">Action</th>
		<th width ="42.5%">InstallFest Example</th>
	</tr>
 
 	<tr>
 		<td class="command">git init</td>
 		<td>This command create an empty Git repository.</td>
 		<td>git init</td>
 	</tr>

 	<tr>
 		<td class="command">git add .</td>
 		<td>This command adds a change in the working directory to the staging area telling Git to include updates to a particular file in the next commit. </td>
 		<td>git add .</td>
 	</tr>

	<tr>
		<td class="command">git commit</td>
		<td>
			<p>
				This command takes the staged code that was added and commits it to the project repository.
			</p>

 			<p>
 				This stores your code so that if you lose or change something locally, you have a way to retrieve a previous version.
 			</p>
 		</td>
 		<td>
 			<p>
 				git commit -m "initial blog commit"
 			</p>
 			<p>
 				- m is message related to that commit.
 			</p>
 		</td>
 	</tr>
</table>
 