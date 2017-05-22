# Getting started on macOS

These instructions are for OS X versions 10.9 and above. If you are running an older version of OS X, please see your event host. We will have USB drives with the files you need to install Rails.

## Step One: Install a Text Editor

Go to [the Sublime website](https://www.sublimetext.com/2) and click on the link for OS X.
It will download a disk image for Sublime 2 to your downloads folder.
Locate the file and click on it to install. Follow the instructions.

## Step Two: Set up a gcc/LLVM compiler

With the installation of Xcode 8.1 you get the Command-Line tools installed by default. You can check this by running `gcc` in terminal. If it gives you this error: `clang: error: no input files`, then you already have the Command Line Tools installed. You can also check it in the Xcode GUI: Xcode->Preferences->Locations->Command Line Tools. If Command-Line Tools are installed you can move to the next section - Installing Homebrew.

If Command Line tools were not installed for some reason proceed with following steps:

1. Open the [Terminal application](https://en.wikipedia.org/wiki/Terminal_(macOS)) (<kbd>⌘</kbd> + <kbd>Space</kbd> (to open [Spotlight](https://support.apple.com/en-au/HT204014)) then type "terminal" in the search bar and press <kbd>Return</kbd>).
2. In the Terminal type: `xcode-select --install` or alternatively `gcc` and press enter. A popup will appear that will install the command-line compilation tools. You may be required to enter your profile password.
3. You may receive a warning like: "_You have not agreed to the Xcode license agreements, please run 'xcodebuild -license'_". If so, simply run: `sudo xcodebuild -license` and enter your account password then follow the steps.
4. Once that has finished try typing `gcc -v` into your terminal window to check the version. You should see the following message:

```sh
Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr
Apple LLVM version 5.0 (clang-500.2.79) (based on LLVM 3.3svn)
Target: x86_64-apple-darwin13.0.0
Thread model: posix
```

## Step Three: Install homebrew

[Homebrew](http://brew.sh) is a package manager, which is a tool that developers use to install other bits of software. Using homebrew we can easily install things like the Postgres database tool, or even tools that allow us to install other tools.

Installing homebrew is easy. In your terminal window run:

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Once that is complete you can run `brew -v` in the terminal to check the current installed version of homebrew.

## Step Four: Install ruby-install

[ruby-install](https://github.com/postmodern/ruby-install) is a tool that can install multiple versions of the Ruby programming language. Professional Ruby developers will use ruby-install (or similar tools) so they can test their applications with many different versions of Ruby.

Run all the the following commands step by step:

1. First install openssl: `brew install openssl`
2. Next install ruby-install: `brew install ruby-install`

## Step Five: Use ruby-install to Install Ruby

Run the following command: `ruby-install ruby 2.4.0`

Installing Ruby may take a little while.

## Step Six: Install rbenv

[rbenv](https://github.com/rbenv/rbenv) is a version manager for Ruby. It can be used to manage and switch between different installed versions of Ruby.

Here is how to install and configure rbenv:

1. Install rbenv with homebrew:

    ````sh
    brew install rbenv
    ````

2. Set up rbenv:

    ````sh
    rbenv init
    ````

Assuming that all worked properly you can run:

````sh
ruby -v
````

and you should see something like:

````sh
ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-darwin16]
````

Importantly you should NOT see:

````sh
ruby 2.4.0p0 (2016-12-24 revision 57164) [universal.x86_64-darwin13]
````

The word __universal__ means that it's the version of Ruby that comes with OS X.
We don't want to use this.

If your Ruby is installed properly you can move onto the next section.

## Step Seven: Install Rails

Installing Rails is easy. To get the latest version just run:

```sh
gem install rails
```

Congratulations on installing Rails! You should probably [get started with the rest of the guide now.](/guides/installfest/getting_started)
