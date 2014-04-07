##Creating debugger-friendly classes
----

If you're going to develop for iOS, you should spend some time learning how to use the excellent debugger built into Xcode. Learn how to set breakpoints, examine variables, and learn how to enter simple commands into the debugger command-line.

Even if you never get that far, you should learn how to use the `NSLog()` function. This function takes a format string and a variable number of parameters, and sends the output to the debug console.

The string format specifier syntax has been extended with the "%@" specifier to display objects. As you probably know, you can use code like this:



	NSLog(@"date = %@", anNSDate);
	
	NSLog(@"array = %@", myArray);
	
	NSLog(@"view = %@", aUIView);
	
	NSLog(@"resultString = %@", resultString);


If you set a breakpoint, you can also examine variables by using the debugger command expression, or "expr" for short:

	expr anNSDate

and you can even invoke code in your expressions:

	expr (void) NSLog(@"date = %@", anNSDate);


For most of Apple-defined classes, this generates pretty useful information about the object.

Under the covers, the "%@" string specifier tries to invoke a `description` method on the object you are trying to log. The description method looks like this:

	- (NSString *) description;

If you don't define a description method in your class, the system calls your object's superclass's description method. That might be useful, but probably not.

Since the system tries to call the `description` method in your subclass first, you can define a description method that returns useful information about the properties of the object you're debugging.

The description method builds and returns an `NSString` containing information about the object being described.

The CIFilterTest program uses a singleton class `FiltersList` that hold information about all the different filters, grouped by the category of filter.

I then defined a class `FilterCategoryInfo` that hold information about a specific category, and finally a class FilterRecord that includes very basic information about a specific filter.

The FiltersList class maintains an array of `FilterCategoryInfo` objects, which in turn maintain arrays of `FilterRecord` objects.

I implemented the `description` method in all 3 classes. The top-level `FiltersList` method generates some summary information about the list of filters, and then loops through the array of filter categories, calling the description method for the `FilterCategoryInfo` object for each category, and combining the top-level summary info with descriptions of each category of filter.

Likewise, the `description` method for `FilterCategoryInfo` creates a string containing summary info about that category, and then calls the `description` method on each entry in it's array of `FilterRecord` objects, and adds the description info for each `FilterRecord` to a single string witch it returns to it's caller.

By adding description methods to all 3 of these classes, it becomes trivial to log the contents of the entire list of filters, a single category, or a single filter. You can display this information in an `NSLog` statement, in a debugger command line command, or you can even add a "breakpoint action" to a debugger breakpoint. The action gets executed any time the breakpoint is triggered.
