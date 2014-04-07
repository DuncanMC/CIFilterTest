#How the CIFilterTest app works


-------
##Data structure classes
-------
CIFilterTest has a set of 3 classes that keep track of information about the list of available filters: `FiltersList`, `FilterCategoryInfo`, and `FilterRecord`.

All 3 classes implement a `-description` method that returns a string describing the contents of the object. Calling `[FiltersList sharedFiltersList] description` returns a formatted log of information about all available filters, grouped by category. Click [**here to see a discussion on using the `-description` method to create debugger-friendly classes**](Creating debugger-friendly classes.md).

###FiltersList 

The `FiltersList` class is the top-level class for collecting information about available Core Image filters. It's a singleton object. Use the class method `+sharedFiltersList` to get a pointer to the shared FiltersList object.

When it is first loaded, the FiltersList object loops through a hard-coded list of filter category name strings and calls the CIFilter class method `+filterNamesInCategory` for each category. It creates a `FilterCategoryInfo` object for each category and populates it with a list of FilterRecord objects that belong to that category.

The `FiltersList` singleton keeps an array unique filter names called `uniqueFilterNames`. Each time it finds a filter that hasn't been seen before, it adds it to the `uniqueFilterNames` array. When it is looping through the filter categories, it marks a filter as unique in the first category in which it is found, and sets the `filterIsDuplicate` flag to YES each time it finds the filter listed in an additional filter category. This enables the program to only list each filter once in the grouped `UITableView` of filters

The FiltersList singleton also conforms to the `TableViewDataSource` protocol to feed a grouped table view of filter names. 

###FilterCategoryInfo

A FilterCategoryInfo object holds an info about a single category of filters. A FilterCategoryInfo object keeps an array `filterRecords` of all FilterRecord objects belonging to the category. It also maintains a separate array `filterRecordsWithNoDuplicates` of unique filter records (A given filter record will be listed in the filterRecords array of every filter category it belongs to, but it will only appear in the `filterRecordsWithNoDuplicates` array of the first category in which that filter is found.)

The `FilterCategoryInfo` also has a boolean property `expandThisCategory` which is used to remember which filter categories should list their filters in a grouped table view of filter categories.


###FilterRecord

A FilterRecord is a very simple objet that saves information about a single filter. FilterRecord objects are duplicated in the FilterCategoryInfo object for each category to which they belong.

A `FilterRecord` object saves the "programmatic" filter name (The named used to load the filter object from Core Image) as well as a user-readable filter display name.

The `FilterRecord` object also has a flag `filterIsDuplicate`. When true, the particular filter is already listed as a unique filter in a `FilterCategoryInfo` record other than it's owning `FilterCategoryInfo` object.
<br>
<br>

----
##Program flow
-------
CIFilterTest is a single-view app. All program logic is controlled by the `ViewController` class.

In it's `viewDidLoad` method, the `ViewController` class loads the primary sample image used by most filtes, and then 
sets up notfication handlers for keyboard show/hide events to shift the content view up to make room for the keyboard. Click [**here to read an article on shifting a view controller's content view up to make room for the keyboard**](Shifting text views for the keyboard.md).

In it's `viewWillAppear` method, the `ViewController` class loads the FiltersList singleton. It then loads the last-used filter name from UserDefaults, calls the method `doSetup` to configure that filter using default settings, and then calls the `showImage` method to display an image using the current filter settings.

The `ViewController` has a programmer utility method `- (void) listCIFiltersAndShowInputKeys: (BOOL) listFilterKeys` that will generate a formatted list of all available filters to the debug console. If you set listFilterKeys = YES, it will also display all the input keys for each filter. The output of this method is saved in the project for quick reference. Click [**here to view the list of filters and their input keys**](CIFilters and input keys.txt).


###The `doSetup` method:

This method loads a CIFilter object named in `currentFilterName` into an instance variable 'currentFilter`. It sets default settings on the filter, and then configures the app's user interface to display settings for this filter.

It loads an attributes dictionary for the currentFilter object and uses the information in the attributes dictionary to configure the filter and it's user interface.

A filter may contain input keys "InputImage", "InputTargetImage", "InputBackgroundImage" and "InputMaskImageKey". CIFilterTest  loads stock images for each of these keys that it finds in the attributes dictionary.

CIFilterTest has special-case code to load sample data for a few filter types for which it does not have a user interface. For example, it loads a static 3x3 convolution matrix into the `CIConvolution3X3` and `CIConvolution5x5` filters,  and it loads a fixed URL string into the CIQRCodeGenerator filter.

CIFilterTest builds a user interface for the following settings:

* Up to 6 floating point values which are set using a slider (and a UITextField for entering values with the keyboard)

* Up to 2 color values, which are handled using a custom colorwell button that displays a color picker popup. Handled by a custom subclass of UIButton called WTPickerButton, which uses a popup containing a `WTColorPickerVC` object. The WTColorPickerVC uses an open-source color picker class called `NKOColorPickerView`, which is in the workspace as a CocoaPod.

* Up to 2 x/y positions, which are handled by a custom subclass of UIButton called PointButton.

* A set of 4 x/y postions for topLeft/topRight/bottomLeft/bottomRight positions. Used for perspective filters. Handled using a custom subclasss of PointButton called FourCornersButton.

* A rectangle, which is handled by a custom subclass of FourCornersButton called FourCornersButton. This class subclas of FourCornersButton forces the 4 input points to form a rectangle, and also has a `CGRect` property for reading/writing the rectangle property.

The storyboard for the app has UI elements for all of these values. It looks for keys in the `CIFilter`s attributes dictionary that are marked with types and classes it recognizes, and shows the appropriate UI element for matching attributes. It displays a label containing the name of each input attribute it finds.

Sliders have `IBAction`s linked to valueChanged. Each slider has a different tag, and the program uses the tag to look up the setting name for that attribute and set the value for that attribute in the current filter.

Likewise colorwell buttons are linked to a colorwellChanged IBAction. That action uses the colorwell buttons' tag to index into an array of attribute keys, and sets the value for that key in the current filter.

The PointButton class and it's subclasses instead have code blocks that they invoke when the user enables the control and moves it's point(s) around on the screen. The code for these blocks update the appropriate attribute in the current filter.

The code for each of the UI Elements calls the showImage method (described below) to update the filter output image on the screen. 

###The `showImage` method:

This method loads the output image from the current filter and displays it to the screen. It contains a fair amount of special-case code to handle the special needs of different filters. 

For example, the CIGaussianBlur filter  needs to have the "extent" of the source image set to infinite so the output of the filter looks correct at the edges. There is special-case code to first apply the "CIAffineClamp" filter to the source image before applying the user-selected filter.

Certain filters like the CIQRCodeGenerator generate images that are smaller than the source image. The showImage method has code that increases the image size if the output of the filter is smaller than the input image. It Creates a CGContext sized for the output image and uses nearest-neighbor interpolation so the output QR code is not blurred when its size is increased.

Certain other filters cause the size of the output image to increase (for example the blur filter and distortion filters cause teh output image to extend outside the original image rectangle.) There is code to crop the output image to it's original size in that case.
 


