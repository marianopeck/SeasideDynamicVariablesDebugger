For those that have used Seaside, and you try to use the debugger, you know that upon request processing seaside uses Exceptions mechanism to always have access to the current request, error handler, etc. The way that this is done is via subclasses of WADynamicVariable. It does something like this:

 WACurrentRequestContext use: self during: aBlock

In that case, "self" is the request instance and "aBlock" the closure that takes care of the request processing. So, inside that closure, everywhere you do "WACurrentRequestContext value" you get the correct request instance.

Once inside the debugger, things get complicated. While you can restart, proceed, etc (because the process you are debugging is inside the scope of the dynamic variables),  you  cannot evaluate any piece of code that ends up using the session  or request because you get a WARequestContextNotFound kind of error. The reason is obvious: The evaluation, do-it, print-it, inspect-it, etc etc  you do on a piece of text or via the debugger inspector, creates another closure/context which is not in the scope of the dynamic variables.

You may also have your own subclasses of WADynamicVariable, say, CurrentUserContextInformation. And that means that almost every time  in the debugger I really need access to that object. 

WADynamicVariablesErrorHandler solves this issue. The idea is very simple. WADynamicVariablesErrorHandler is a subclass of WADebugErrorHandler which overrides #handleException: in order to simply iterate all values of all dynamic variables (all WADynamicVaraible subclasses) and store those into a dictionary in a class variable of WADynamicVariablesErrorHandler. 

Then, we simply override (yes, this is a hack) WADynamicVarible >> #defaultAction  to be something like this (the code below is a simplfied version):

WADynamicVarible >> #defaultAction 
^ (WADynamicVariablesErrorHandler storedDynamicVariable: self class)
		ifNil: [ self class defaultValue ]

That way... when we handle an exception, we save out all values into a class side. And then, in the debugger, whenever we evaluate, inspect, print etc anything that would do a #value over a WADynamicVariable subclass, it ends up calling #defaultAction (because there will be no handler in the stack) and there, we first check if the have the value for that dynamic variable. If we do, we answer that, if not, the defaultValue :)

There are tests too. There is WACurrentRequestDebuggingTest which you can try from /tests/seasidepharodebugging

For the user, there is almost nothing to do. All WADynamicVariable subclasses are managed automatically. All you need is to register the exception handler:

app filter configuration at: #exceptionHandler put: WADynamicVariablesErrorHandler.

The only drawback here is that this doesn't work with multiple debuggers as the last debugger will override the class variable values and hence the OLD already opened debuggers will be getting a wrong (the latest) value for the dynamic variables. 
