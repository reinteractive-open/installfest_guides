# Getting started on macOS

These instructions are for OS X versions 10.9 and above. If you are running an older version of OS X, please see your event host. We will have USB drives with the files you need to install Rails.

Here is the basic outline of what we will do:

1. Install a text editor (Sublime)
2. Set up a compiler
3. Install [homebrew](http://brew.sh)
4. Use homebrew to install [ruby-install](https://github.com/postmodern/ruby-install) and [chruby](https://github.com/postmodern/chruby)
5. Use ruby-install to install a new version of the Ruby programming language
6. Use Ruby to install Rails

## Install a Text Editor

Go to [the Sublime website](https://www.sublimetext.com/2) and click on the link for OS X.
It will download a disk image for Sublime 2 to your downloads folder.
Locate the file and click on it to install. Follow the instructions.

## Setting up a gcc/LLVM compiler
 
With the installation of Xcode 8.1 you get the Command-Line tools installed by default. You can check this by running `gcc` in terminal. If it gives you this error: `clang: error: no input files`, then you already have the Command Line Tools installed. You can also check it in the Xcode GUI: Xcode->Preferences->Locations->Command Line Tools. If Command-Line Tools are installed you can move to the next section - [installing homebrew]().

If Command Line tools were not installed for some reason proceed with following steps:

1. Open the [Terminal application](https://en.wikipedia.org/wiki/Terminal_(macOS)) (<kbd>⌘</kbd> + <kbd>Space</kbd> (to open [Spotlight](https://support.apple.com/en-au/HT204014)) then type "terminal" in the search bar and press <kbd>Return</kbd>).
2. In the Terminal type: `xcode-select --install` or alternatively `gcc` and press enter. A popup will appear which will install the command-line compilation tools. You may be required to enter your profile password.
3. You may receive a warning like: "_You have not agreed to the Xcode license agreements, please run 'xcodebuild -license'_". If so, simply run: `sudo xcodebuild -license` and enter your account password then follow the steps.
4. Once that has finished try typing `gcc -v` into your terminal window to check the version. You should see the following message:

```sh
Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr
Apple LLVM version 5.0 (clang-500.2.79) (based on LLVM 3.3svn)
Target: x86_64-apple-darwin13.0.0
Thread model: posix
```

## Installing homebrew

[Homebrew](http://brew.sh) is a package manager, which is a tool that developers use to install other bits of software. Using homebrew we can easily install things like the Postgres database tool, or even tools that allow us to install other tools.

Installing homebrew is easy. In your terminal window run:

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Once that is complete you can run `brew -v` in the terminal to check the current installed version of homebrew.

## Installing ruby-install and chruby


[ruby-install](https://github.com/postmodern/ruby-install) is a tool that can install multiple versions of the Ruby programming language. Professional Ruby developers will use ruby-install (or similar tools) so they can test their applications with many different versions of Ruby.

[chruby](https://github.com/postmodern/chruby) is a version manager for Ruby. It can be used to manage and switch between different installed versions of Ruby.

Run all the the following commands step by step:

1. First install openssl: `brew install openssl`
2. Next install ruby-install: `brew install ruby-install`
3. Now use ruby-install to install Ruby: `ruby-install ruby 2.3.0`

Installing Ruby may take a little while.

Next we'll install and configure chruby:

1. Install chruby with homebrew: 

    ````sh
    brew install chruby
    ````

2. Configure chruby to start when you open your terminal: 

    ````sh 
    echo "source '/usr/local/share/chruby/chruby.sh'" >> ~/.bash_profile
    ````

3. Start chruby in your current terminal: 

    ````sh
    source '/usr/local/share/chruby/chruby.sh'
    ````

4. Tell chruby to use the latest version of ruby when your start your terminal: 

    ````sh
    echo "chruby `chruby | grep 2.3.0 | sed 's/\* //'`" >> ~/.bash_profile`
    ````

5. Tell chruby to use the latest version of ruby in your current terminal: 

    ````sh
    chruby `chruby | grep 2.3.0 | sed 's/\* //'`
    ````

Assuming that all worked properly you can run:

````sh
ruby -v
````

and you should see something like:

````sh
ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-darwin13]
````

Importantly you should NOT see:

````sh
ruby 2.3.0p0 (2015-12-25 revision 53290) [universal.x86_64-darwin13]
````

The word __universal__ means that it's the version of Ruby that comes with OS X.
We don't want to use this.

If your Ruby is installed properly you can move onto the next section.

## Installing Rails

Installing Rails is easy. To get the latest version just run:

```sh
gem install rails
```

Congratulations on installing Rails! You should probably [get started with the rest of the guide now.](/guides/installfest/getting_started)
