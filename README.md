# angular-base-app
Opinionated base application scaffolding and build processes for developing with Angular

## Build Process

We'll walk through the process. 
* First, Install Dependencies
* Next, Setup your Environment
* Then, Build!

### Install Dependencies

* [RVM](https://rvm.io/rvm/install#installation)
* [Node.js](http://nodejs.org/download/)
* [Bower](http://bower.io/#install-bower)

Make sure you install these dependencies before attempting to continue with the build process.


### Setup

We need to fetch all 3rd-party packages needed for our build process.

Move into the front-end source files directory.
```shell
cd /PROJECTDIR/frontend-src
```

Verify RVM is configured with a unique gemdir for your project. This keeps Ruby dependencies from conflicting with other instances of Ruby within your system. Expected output looks something like `~/.rvm/gems/ruby-2.1.2@unique-name-of-my-app`
```shell
rvm gemdir
```

Now fetch the Ruby gems that we need for the build process.
```shell
bundle install
```

Now fetch the Node modules that we need for the build process.
```shell
npm install
```

Now fetch the 3rd party libraries we need for the app to function (this is stuff like Angular, jQuery, Bootstrap, etc).
```shell
bower install
```

### Build

In order to compile your source files to use in a development or production environment, you need to first set your build style preference in `package.json`

Find the environment variable and change its value between `development` or `production`
```js
{
	...
    "environment" : "development",
}
```

Then, to fully execute a build, run:
```shell
grunt
```

To continue watching for changes and re-building as you develop, run:
```shell
grunt watch
```

## Special Thanks To

This repository makes use of techniques learned and borrowed from other people. Use this section to thank them by name.
