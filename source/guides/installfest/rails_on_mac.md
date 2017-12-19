# Getting started on macOS

These instructions are for OS X versions 10.9 and above. If you are running an older version of OS X, please see your event host. We will have USB drives with the files you need to install Rails.

## Step One: Install a Text Editor

This step is optional. If you already have a text editor that you use for writing code, you are welcome to use that.

If you do not, or you would like to try something new, feel free to install Sublime Text which is a popular text editor for Ruby developers.

Go to [the Sublime website](https://www.sublimetext.com/) and click on 'DOWNLOAD FOR MAC'.
It will download a disk image for Sublime Text to your downloads folder.
Locate the file and click on it to install. Follow the instructions.

## Step Two: Set up a gcc/LLVM compiler

If you have Xcode installed, you get the Command-Line tools installed by default. You can check this by running `gcc` in terminal. If it gives you this error: `clang: error: no input files`, then you already have the Command Line Tools installed. If Command-Line Tools are installed you can move to the next section - Installing Homebrew.

If Command Line tools are not installed, proceed with following steps:

1. Open the [Terminal application](https://en.wikipedia.org/wiki/Terminal_(macOS)) (<kbd>⌘</kbd> + <kbd>Space</kbd> (to open [Spotlight](https://support.apple.com/en-au/HT204014)) then type "terminal" in the search bar and press <kbd>Return</kbd>).
2. In the Terminal type: `xcode-select --install` or alternatively `gcc` and press enter. A popup will appear that will install the command-line compilation tools. You may be required to enter your profile password.
![xcode-select-popup](/images/guides/xcode-select-popup.png)
3. You may receive a warning like: "_You have not agreed to the Xcode license agreements, please run 'xcodebuild -license'_". If so, simply run: `sudo xcodebuild -license` and enter your account password then follow the steps.
4. Once that has finished try typing `gcc -v` into your terminal window to check the version. You should see the following message:

```sh
Configured with: --prefix=/Library/Developer/CommandLineTools/usr --with-gxx-include-dir=/usr/include/c++/4.2.1
Apple LLVM version 9.0.0 (clang-900.0.38)
Target: x86_64-apple-darwin16.7.0
Thread model: posix
```

## Step Three: Install homebrew

[Homebrew](http://brew.sh) is a package manager, which is a tool that developers use to install other bits of software. Using homebrew we can easily install things like the Postgres database tool, or even tools that allow us to install other tools.

Installing homebrew is easy. In your terminal window run:

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Once that is complete you can run `brew -v` in the terminal to check the current installed version of homebrew.

## Step Four: Install RVM

[RVM](https://rvm.io/) is a version manager for Ruby. It can be used to manage and switch between different installed versions of Ruby. Here is how to install and configure rvm:

1. Install gpg

	Before installing RVM, we must first install [gpg](https://en.wikipedia.org/wiki/GNU_Privacy_Guard), an encryption program used to check the security of the RVM download. Installing gpg eliminates a warning message which will halt the installation of RVM. Run the following in your terminal prompt:

    ````sh
    brew install gpg
    ````

2. Install the security key for RVM:

    ````sh
    command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
    ````

3. To install RVM, run the following in your terminal prompt:

    ````sh
    \curl -L https://get.rvm.io | bash -s stable
    ````

	If you see a warning about PATH, do not be concerned. :-)

4. Close and reopen the terminal window.

## Step Five: Use RVM to Install Ruby

Run the following command:

````sh
rvm install 2.4.2
````

Installing Ruby may take a little while.

Once it has completed, set this version of Ruby as your default:

```sh
rvm --default use 2.4.2
```

Assuming that all worked properly you can run:

````sh
ruby -v
````

and you should see something like:

````sh
ruby 2.4.2p0 (2016-12-24 revision 57164) [x86_64-darwin16]
````

Importantly you should NOT see:

````sh
ruby 2.0.0p0 (2016-12-24 revision 57164) [universal.x86_64-darwin13]
````

The word __universal__ means that it's the version of Ruby that comes with OS X.

If your Ruby is installed properly you can move onto the next section.

## Step Six: Install Rails

Installing Rails is easy. To get the latest version just run:

```sh
gem install rails
```

When this completes (and it can take a little while), type the following into your terminal to confirm that rails is correctly installed and ready for use:

```sh
rails -v
```

Congratulations on installing Rails! You should probably [get started with the rest of the guide now.](/guides/installfest/getting_started)
