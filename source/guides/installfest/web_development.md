#A bit about Web development

Web development is a term used for all of the work involved in developing a web site or application for the Internet or intranet. 

Within Web development there are many acronyms used by developers to refer to things within the software world. Don't be afraid of these, we will explain some of these to you here.

##Front End
Front end refers to the design, style, user experience and presentation within a web site or application. It is everything you see and that you can interact with on the screen. The front end is an interface between the user and the back end. The front end is made up of HTML, CSS and Javascript. 

###HTML - Hyper text mark up
HTML is the structure of the application. Tags are used to define how your content should be read by a web browser. It allows you to create structured documents with structure for your text such as paragraphs, headings, lists, links and other items.

For example:

We've used no tags to create this document.

```
Hello

Welcome to the Installfest guides!

Thanks for reading this.

```
In your browser it will look like this:

![No HTML](/images/web_dev/no_html.png)

Now, we've used h1 (heading) tags, p (paragraph) tags and b (bold) tags in the same document. 

```
<h1>Hello</h1>

<p>
<b>Welcome to the Installfest guides!</b>
</p>

<p>Thanks for reading this.</p>

```
Now it will look like this in your browser: 

![With HTML](/images/web_dev/with_html.png)

###CSS - Cascading style sheets
CSS is a language used to refer to the style of a document. A style sheet is made up of a list of rules that should be applied in order to style the document. 

For example:

Let's add style to our document. 

```
<style>
h1 { color: red }
p { color: blue }
</style>

<h1>Hello</h1>

<p>
<b>Welcome to the Installfest guides!</b>
</p>

<p>Thanks for reading this.</p>
```
Now you can see the styling in the browser:

![With CSS](/images/web_dev/with_style.png)

###JS - JavaScript 
JavaScript is used to make a web page more interactive. It is a dynamic language that runs on your web browser, and allows the user to interact with and change the content that is being displayed. It is the drop down and pop up that allows the the user to change what they see without the entire page having to reload.

##Back End
Back end refers to the data storage, business rules, processing, persistence and performance of your application. The backend usually consists of three parts: a server, an application, and a database. There are many back end languages including Ruby, Java, PHP and .NET. 

###Server
The sever is where you publish. It serves up your front end and sends it to the browser, pulling up information from the user's account that is stored in the database.


###Database
The database holds your information. You can think of it like an excel spreadsheet. This information can be pictures, videos, comments, posts, text etc. and varies from application to application. The database stores any data that has been added to the application by the user. The information is stored so that the next time the users logs in, their information is available to them. 









