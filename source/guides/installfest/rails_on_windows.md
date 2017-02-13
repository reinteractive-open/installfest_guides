# Getting started on Windows

Here is the basic outline of what we will do:

1. Install [chocolatey](https://chocolatey.org/)
2. Use chocolatey to install Ruby
3. Use chocolatey to install other helpful tools
4. Install Ruby Gems
5. Configure our environment
6. Use Ruby to install Rails

## Installing Chocolatey

[Chocolatey](https://chocolatey.org/) is a tool that developers use to install other bits of software. Using chocolatey we can easily
install things like the Postgres database tool, or even tools that will allow us to install other tools.

Installing chocolatey is easy. Firstly open a command prompt as administrator (right click "run as administrator").

Then copy and paste the following command into the terminal and hit enter:

```
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
```

## Installing Ruby

Installing Ruby is as simple as running the following command:

```sh
choco install ruby -y -version 2.2.4
```

We also need to add Ruby to PATH so our operating system knows about it. Run the following command:

```
PATH=%PATH%;C:\tools\Ruby22\bin
```

Assuming that worked properly you can run:

```sh
ruby -v
```

and you should see something like:

```sh
ruby 2.2.4p230 (2015-12-16 revision 53155) [x86_64-darwin13]
```

If your Ruby is installed properly you can move onto the next section.

## Install other helpful tools

There are a few other tools we are going to need to set our Rails environment up. Copy and paste each of the following one by one into your terminal:

```sh
choco install curl -y
choco install wget -y
choco install git -y
choco install nodejs -y
choco install sublime -y
choco install ruby2.devkit -y
```

## Install Ruby Gems

First change to the tools directory:

```
cd \tools\
```

Then fetch the latest rubygems:

```sh
wget https://rubygems.org/downloads/rubygems-update-2.6.8.gem
```

And install them:

```sh
gem install --local C:\rubygems-update-2.6.8.gem
```

And then run an update to ensure everything matches:

```sh
update_rubygems --no-ri --no-rdoc
```

## Configure our environment

In a previous step we installed the [Ruby Development Kit](http://rubyinstaller.org/add-ons/devkit/). This is going to need some configuration. Run the following commands:

```
cd c:\tools\DevKit2
echo - c:/tools/Ruby22 > config.yml
ruby dk.rb install
gem update --system
```

## Installing Rails

Installing Rails is easy. To get the latest version just run:

```sh
gem install rails
```

Now close your administrator command prompt and re-open it as a normal user.

Congratulations on installing Rails! You should probably [get started with the rest of the guide now.](/guides/installfest/getting_started)
