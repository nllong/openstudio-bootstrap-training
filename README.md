# OpenStudio Bootstrap Training
This repository contains some example files and instructions for the OpenStudio Bootstrap training. 

## System Requirement
- Mac, Windows, or Linux
- Download and Install [SketchUp 8](http://www.sketchup.com/download/all) (not 2014)
- Download and install [EnergyPlus V8.0](www.energyplus.gov).  Make sure you download and install Version 8.0 (NOT 8.1)
- Download [OpenStudio v1.2.5](http://developer.nrel.gov/downloads/buildings/openstudio/builds) for your platform
- Install Ruby 1.8.7 for your system
  - Mac (use [rbenv](https://github.com/sstephenson/rbenv) or [rvm](https://rvm.io/))
    - If using rbenv, make sure to build your ruby with the following flag
    ```
    RUBY_CONFIGURE_OPTS=--enable-shared rbenv install 1.8.7-p374
    ```
  - Windows
    - Install from [RubyInstaller](http://rubyinstaller.org/downloads/)
    - Make sure to add Ruby to your path
- Checkout this repo

## Getting Started
- Test the bindings

  Start a terminal / command and try the following.  The output should be somehting similar.  
  ```
  $ irb
  > require 'openstudio'
  Loading OpenStudio ruby binaries from   /Users/nlong/working/OpenStudio/build/OpenStudioCore-prefix/src/OpenStudioCore-build/Products/ruby/
  Loading OpenStudio shared libraries from /Users/nlong/working/OpenStudio/build/OpenStudioCore-prefix/src/OpenStudioCore-build/Products/
  OpenSSL loaded
  => true
  ```
 


