# SeasideDynamicVariablesDebugger
In short, this project provides a simple Seaside error handler which allows the developer to debug, inspect, and evaluate code that relies on Seaside's current request and session, improving that way the Seaside debugging experience.

*DISCLAIMER*: This tool is aimed for advanced Seaside users that know what they are doing and that they have already faced the `WARequestContextNotFound` kind of error while debugging.



Table of Contents
=================

  * [Table of Contents](#table-of-contents)
    * [Installation](#installation)
    * [The Problem](#the-problem)
    * [WADynamicVariablesErrorHandler in a nutshell](#wadynamicvariableserrorhandler-in-a-nutshell)
    * [Getting Started](#getting-started)
    * [Running the tests](#running-the-tests)
    * [Caveats](#caveats)
    * [Contributing](#contributing)
    * [Authors](#authors)
    * [License](#license)
    * [Acknowledgments](#acknowledgments)
    * [Funding](#funding)




## Installation
We believe it is easier to simply *do not* load Seaside as a dependency of this project. Therefore, you must first install Seaside with their instructions. For example:

```Smalltalk
Gofer new
	url:'http://www.smalltalkhub.com/mc/Seaside/MetacelloConfigurations/main';
 	package: 'ConfigurationOfSeaside3';
 	load.
((Smalltalk at: #ConfigurationOfSeaside3) project version: #stable) load.
```

Once Seaside is installed, execute the following to install SeasideDynamicVariablesDebugger:

```Smalltalk
Metacello new
    baseline: 'SeasideDynamicVariablesDebugger';
    repository: 'github://marianopeck/SeasideDynamicVariablesDebugger:master/repository';
    load.
```

> SeasideDynamicVariablesDebugger was tested only in Pharo 4.0 and 5.0 and using Seaside 3.1


## The Problem
If you are a Smalltalk developer, you probably enjoy your debugger quite a lot. Staying in the debugger feels so comfortable... until you need to debug a Seaside application. How many times did you try to do a do-it or inspect an expression and that failed with a `WACurrentRequestContext`?  Later, you find yourself doing an inspect of the session or any other related object and then immediately after the inspect, you put a halt. Who hasn't done this???

Upon request processing Seaside uses Exceptions mechanism to always have access to the current request, error handler, etc. The way that this is done is via subclasses of `WADynamicVariable`. It does something like this:

```Smalltalk
 WACurrentRequestContext use: self during: aBlock.
```

In this case, `self` is the request instance and `aBlock` the closure that takes care of the request processing. So, inside that closure, everywhere you do `WACurrentRequestContext value` you get the correct request instance.

Once inside the debugger, things get complicated. While you can restart, proceed, etc (because the process you are debugging is inside the scope of the dynamic variables),  you  cannot evaluate any piece of code that ends up using the session  or request because you get a `WARequestContextNotFound` kind of error. The reason is obvious: The evaluation, do-it, print-it, inspect-it, etc etc  you do on a piece of text or via the debugger inspector, creates another closure/context which is not in the scope of the dynamic variables.

You may also have your own subclasses of `WADynamicVariable`, say, CurrentUserContextInformation. And that means that almost every time  in the debugger you really need access to that object.


## WADynamicVariablesErrorHandler in a nutshell

`WADynamicVariablesErrorHandler` solves the previously mentioned issue with a very hackish yet simple idea. `WADynamicVariablesErrorHandler` is a subclass of `WADebugErrorHandler` which overrides ``#handleException:`` in order to simply iterate over all values of all dynamic variables (all `WADynamicVaraible` subclasses) and store those into a dictionary in a class variable of `WADynamicVariablesErrorHandler`.

Then, we simply override (yes, this is a hack) `WADynamicVarible >> #defaultAction`  to be something like this (the code below is a simplified version):

```Smalltalk
WADynamicVarible >> #defaultAction
^ (WADynamicVariablesErrorHandler storedDynamicVariable: self class)
		ifNil: [ self class defaultValue ]
```

That way... when we handle an exception, we save out all values into a class side. And then, in the debugger, whenever we evaluate, inspect, print etc anything that would do a `#value` over a `WADynamicVariable` subclass, it ends up calling `#defaultAction` (because there will be no handler in the stack) and there, we first check if the have the value for that dynamic variable. If we do, we answer that, if not, the `defaultValue` :)

## Getting Started

For you as a user, there is almost nothing you should do. All `WADynamicVariable` subclasses are managed automatically. All you need to do is to register the exception handler in  your Seaside application:

```Smalltalk
app filter configuration at: #exceptionHandler put: WADynamicVariablesErrorHandler.
```

## Running the tests

There are tests/examples in `WACurrentRequestDebuggingTest` which you can try from the browser at `/tests/seasidepharodebugging`. For running these tests we recommend you first open a `Transcript`. You should click in the different buttons and once a debugger is opened, read the comments below the active line in the debugger. Once inside the debugger, try everything you would like to do with the Seaside code that would use the active session or request. You should be able to open inspectors, do-it, print and do whatever you want without getting the `WARequestContextNotFound`. And you can do this **everywhere** in your image, not only in the debugger.


## Caveats

SeasideDynamicVariablesDebugger doesn't work with multiple debuggers as the last debugger will override the class variable values and hence the *old* already opened debuggers will be getting wrong (the latest) values for the dynamic variables. **Therefore, as a workaround, always keep only one Seaside error debugger opened.**


## Contributing
This project is developed with [GitFileTree](https://github.com/dalehenrich/filetree), which, starting in Pharo 5.0, provides what is called `Metadata-less` FileTree. That basically means that there are certain FileTree files (`version` and `methodProperties`) which are not created. **Therefore, you cannot use regular FileTree to contribute to this project. You must use `GitFileTree`.**

The following are the steps to contribute to this project:

* Fork it using Github web interface!
* Clone it to your local machine: `git clone git@github.com:YOUR_NAME/SeasideDynamicVariablesDebugger.git`
* Create your feature branch: `git checkout -b MY_NEW_FEATURE`
* Download latest Pharo 5.0 and load GitFileTree and this project:

```Smalltalk
Metacello new
 	baseline: 'FileTree';
   	repository: 'github://dalehenrich/filetree:issue_171/repository';
   	load: 'Git'.
Metacello new
	baseline: 'SeasideDynamicVariablesDebugger';
 	repository: 'gitfiletree:///path/to/your/local/clone/SeasideDynamicVariablesDebugger/repository';
	onConflict: [ :ex | ex allow ];
	load.
```

* You can now perform the changes you want at Pharo level and commit using the regular Monticello Browser.
* Run all SeasideDynamicVariablesDebugger tests to make sure you did not break anything.
* Push to the branch. Either from MC browser of with `git push origin MY_NEW_FEATURE`
* Submit a pull request from github web interface.


## Authors

* **Mariano Martinez Peck** - *Initial work* - [Mariano Martinez Peck](https://github.com/marianopeck)

See also the list of [contributors](https://github.com/marianopeck/SeasideDynamicVariablesDebugger/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Thanks to [Max Leske](https://github.com/theseion) for helping me out with the design, code review and ideas


## Funding
The initial efforts of this project was gently paid by [Debris Publishing Inc.](http://debrispublishing.com/)
