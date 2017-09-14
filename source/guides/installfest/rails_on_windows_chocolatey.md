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
choco install ruby -y -version 2.4.1.2
```

We also need to add Ruby to PATH so our operating system knows about it.

Run the following command:

```
PATH=%PATH%;C:\tools\Ruby24\bin
```

Assuming that worked properly you can run:

```sh
ruby -v
```

and you should see something like:

```sh
ruby 2.4.1p111 (2017-03-22 revision 58053) [x64-mingw32]
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

First we need to install the ruby build tools. Run the following command from Command Prompt (Administrator):

```sh
ridk install
```

Type `1` and press Enter to start installing MSYS.

1. Click **Next**
1. Change the installation folder to `C:\tools\msys32` or `C:\tools\msys64` depending on your operating system and click **Next**
1. Click **Next**
1. Uncheck "Run MSYS now" and click **Finish**
1. Once completed the MSYS installer will be waiting for another selection, type `2` and press Enter to install MSYS updates.
1. Once this step is complete, type `3` and press Enter to install the MSYS and MINGW development toolchain.

Once finished, if the MSYS prompt is waiting for another option, simply press Enter to exit the MSYS installer. If this doesn't work, `ctrl-c` followed by `Y` should do it.

Fetch the latest rubygems:

```sh
wget https://rubygems.org/downloads/rubygems-update-2.6.12.gem
```

And install them:

```
gem install --local C:\rubygems-update-2.6.12.gem --no-ri --no-rdoc
```

And then run an update to ensure everything matches:

```sh
update_rubygems --no-ri --no-rdoc
```

```
gem update --system
```


## Step Five: Install Rails

Installing Rails is easy. To get the latest version just run:

```sh
gem install rails --no-ri --no-rdoc
```

Depending on your internet connection, this may take a while so sit back and relax. :-)

When it is complete, run the following:

```sh
rails -v
```

You should see the following output:

```
Rails 5.1.3
```

Close your administrator command prompt and re-open it as a normal user (Click Start, type: cmd, and press Enter).

Congratulations on installing Rails! You should probably [get started with the rest of the guide now.](/guides/installfest/getting_started)
