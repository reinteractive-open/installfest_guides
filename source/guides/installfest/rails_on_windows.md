# Getting started on Windows

## Step One: Install Chocolatey

[Chocolatey](https://chocolatey.org/) is a tool that developers use to install other bits of software. Using chocolatey we can easily install things like the Postgres database tool, or even tools that will allow us to install other tools.

Installing chocolatey is easy.

First, open a command prompt as administrator
(Click Start, type: cmd, and press Control + Shift + Enter).

Then copy and paste the following command into the terminal and hit enter:

```
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
```

It might take a minute or two to start, but remain patient. :-)

## Step Two: Install Ruby

Installing Ruby is as simple as running the following command:

```sh
choco install ruby -y -version 2.2.4
```

We also need to add Ruby to PATH so our operating system knows about it.

Run the following command:

```
PATH=%PATH%;C:\tools\Ruby22\bin
```

Assuming that worked properly you can run:

```sh
ruby -v
```

and you should see something like:

```sh
ruby 2.2.4p230 (2015-12-16 revision 53155) [i386-mingw32]
```

If your Ruby is installed properly you can move onto the next section.

## Step Three: Install other helpful tools

There are a few other tools we are going to need to set our Rails environment up.

Copy and paste each of the following one by one into your terminal, checking the output for success each time:

```sh
choco install curl -y
```

```sh
choco install wget -y
```

```sh
choco install git -y
```

```sh
choco install nodejs -y
```

```sh
choco install ruby2.devkit -y
```

This next step is optional. If you already have a text editor that you use for writing code, you are welcome to use that.

If you do not, or you would like to try something new, feel free to install Sublime Text which is a popular text editor for Ruby developers.

```sh
choco install sublimetext3 -y
```

### Troubleshooting

If you get an "Access denied" error, check that you are using the Administrator Command Prompt.

If you are, and the error still occurs, rerun the command with the `-f` flag to force it to install again.

For example, `choco install git -f`

## Step Four: Install Ruby Gems

First change to the tools directory:

```
cd \tools\
```

Then fetch the latest rubygems:

```sh
wget https://rubygems.org/downloads/rubygems-update-2.6.12.gem
```

And install them:

```
gem install --local C:\rubygems-update-2.6.12.gem
```

And then run an update to ensure everything matches:

```sh
update_rubygems --no-ri --no-rdoc
```

## Step Five: Configure our environment

In a previous step we installed the [Ruby Development Kit](http://rubyinstaller.org/add-ons/devkit/). This is going to need some configuration. Run the following commands:

```
cd c:\tools\DevKit2
```

```
echo - c:/tools/Ruby22 > config.yml
```

```
ruby dk.rb install
```

```
gem update --system
```

## Step Six: Install Rails

Installing Rails is easy. To get the latest version just run:

```sh
gem install rails
```

Depending on your internet connection, this may take a while so sit back and relax. :-)

When it is complete, close your administrator command prompt and re-open it as a normal user (Click Start, type: cmd, and press Enter).

Congratulations on installing Rails! You should probably [get started with the rest of the guide now.](/guides/installfest/getting_started)
