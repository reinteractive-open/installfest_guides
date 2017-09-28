# Getting started on Sierra

Unfortunately macOS Sierra isn't supported by Rails Installer by default. This means we need to do a slightly more "professional" installation of Ruby and of Rails. Here's the basic outline:

1. Setup a [gcc/LLVM compiler](https://developer.apple.com/library/content/documentation/CompilerTools/Conceptual/LLVMCompilerOverview/index.html)
2. Install [homebrew](http://brew.sh)
3. Use homebrew to install [ruby-install](https://github.com/postmodern/ruby-install) and [chruby](https://github.com/postmodern/chruby)
4. Use ruby-install to install a new version of the Ruby
5. Use Ruby to install Rails

## Setting up a gcc/LLVM compiler

With the installation of Xcode 8.1 you get the Command-Line tools installed by default. You can ensure it by running `gcc` in terminal. If it gives you this error: `clang: error: no input files`, then you already have the Command Line Tools installed. You can also check it in the Xcode GUI: Xcode->Preferences->Locations->Command Line Tools. If Command-Line Tools are installed you can move to the next section - [installing homebrew]().

But in case Command Line tools were not installed for some reason proceed with following steps:

1. Open the [Terminal application](https://en.wikipedia.org/wiki/Terminal_(macOS)) (<kbd>⌘</kbd> + <kbd>Space</kbd> (to open [Spotlight](https://support.apple.com/en-au/HT204014)) then type "terminal" in the search bar and press <kbd>Return</kbd>).
2. In the Terminal type: `xcode-select --install` or alternatively `gcc` and press enter. A popup will appear which will install the command-line compilation tools. You may be required to enter your profile password.
3. You may receive a warning like: "_You have not agreed to the Xcode license agreements, please run 'xcodebuild -license'_". If so, simply run: `sudo xcodebuild -license` and enter your account password then follow the steps.
4. Once that has finished try typing `gcc -v` into your terminal window to check the version . You should see the following message:

```sh
Configured with: --prefix=/Applications/Xcode.app/Contents/Developer/usr
Apple LLVM version 5.0 (clang-500.2.79) (based on LLVM 3.3svn)
Target: x86_64-apple-darwin13.0.0
Thread model: posix
```

## Installing homebrew

[Homebrew](http://brew.sh) is a package manager. Using homebrew we can easily install things like the Postgres database tool, or even tools which lets us install other tools.

Installing homebrew is easy. In your terminal window run:

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Once that is complete you can run `brew -v` in the terminal to check the current installed version of homebrew.

## Installing ruby-install and chruby

[ruby-install](https://github.com/postmodern/ruby-install) is a tool which can install multiple versions of the Ruby programming language. Professional Ruby developers will use ruby-install (or similar tools) so they can test their
applications with many different versions of Ruby.

[chruby](https://github.com/postmodern/chruby) is a one of the version managers for Ruby. This manager is used to manage and switch between different installed versions of Ruby.

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
ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-darwin16]
````

Importantly you should NOT see:

````sh
ruby 2.3.0p0 (2015-12-25 revision 53290) [universal.x86_64-darwin16]
````

The word __universal__ means that it's the version of Ruby which comes with OS X.
We don't want to use this.

If your Ruby is installed properly you can move onto the next section.

## Installing Rails

Installing Rails is easy. To get the latest version just run:

```sh
gem install rails
```

If you want to install a different version of Rails (for example, 3.2.13) just type

```sh
gem install rails -v 3.2.13
```

If you install multiple versions of Rails onto your computer you can choose which one
to create an app with as follows:

```sh
rails _3.2.13_ new quick_blog
rails _4.0.1_ new quick_blog_4
```

If you just type

```sh
rails new quick_blog_again
```

it will automatically use the latest version of Rails you have installed.

Congratulations on installing Rails. You should probably [get cracking with the rest of the guide now!](/guides/installfest/getting_started)
