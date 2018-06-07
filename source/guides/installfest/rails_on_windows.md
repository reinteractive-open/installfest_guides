# Getting started on Windows

## Step One: Install Ruby, Rails, and other necessary tools

Go to [Rails Installer](http://railsinstaller.org/en), scroll down to the bottom to the Downloads section, and click on the second button `WINDOWS RUBY 2.3`

Click on `Run` and wait for it to install and then run.

Click on `I accept all of the Licenses`

Click `Next`

Accept the default location and click `Install`

When it has finished, click on `Finish`

## Step Two: Check the Installation

To check that Ruby was installed correctly, run the following command:

```sh
ruby -v
```

This will tell you what version of Ruby was installed.

To check that Rails was installed correctly, run the following command:

```sh
rails -v
```

This will tell you what version of Rails was installed.

If you see something like `rails 5.1.6` (or any version 5.x.x of Rails), then you can move onto the next step.

If you get an error saying `The system cannot find the path specified`, try running the following command to install Rails manually:

```sh
gem install rails -v 5.1.6 --no-ri --no-rdoc
```

This might take a while to run, so sit back and relax!

## Step Three: Install Sublime Text Editor (Optional)

This step is optional. If you already have a text editor that you use for writing code, you are welcome to use that.

If you do not, or you would like to try something new, feel free to install Sublime Text which is a popular text editor for Ruby developers.

Go to the [Sublime Text downloads page](https://www.sublimetext.com/3) and select the appropriate download for your machine (in most cases it will be the second option, 'Windows').

Click on `Run`

If a popup appears asking permission to make changes, click on `Yes`

Follow the installation wizard, accepting all the defaults.

## Step Four: Finish!

Close your administrator command prompt and re-open it (Click Start, type: cmd, and press Enter).

Congratulations on installing Rails! You should probably [get started with the rest of the guide now.](/guides/installfest/getting_started)
