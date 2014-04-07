#CoreImage Filter Demo

This project lets you explore the CoreImage filters offered by the current version of iOS.

At launch it interrogates the system for a list of supported filters and adds them to a popup list of filters.

It attempts to set reasonable values for the different parameters, and looks for settings that specify slider settings. When it finds settings that specify slider settings it configures up to 6 sliders with the name of the attribute and its maximum, minimum, and default value.

It will also add UI controls to set input points, colors, rectangles, and points for pespective projections.

It has hard-coded settings for a few filters like the QR code generator and the 3x3 and 5x5 convolution filters that use special input types.

This project now uses a Cocoapod to add support for iOS color pickers. 

###**NOTE: Be sure to open the Xcode workspace file, not the project**.


Note the the project is for iPad only, and runs **MUCH** bettter on an actual device. (Apparently the simulator implementation of Core Image is quite slow.)

This project includes a method, `listCIFiltersAndShowInputKeys:`, which queries the CIFilter class and write a formatted list of available filters to the debug console. If you pass in YES for the listFilterKeys parameter then it also logs information about the input parameters for each filter. Click [this link](CIFilters and input keys.txt) to see the output from this function from iOS 7.1.


Click [**this link for an explanation on using Core Image filters**](using_core_image_filters.md).

Click [**This link for a overview of the program**](how_cifiltertest_works.md)

Click [**here to read an article on shifting a view controller's content view up to make room for the keyboard**](Shifting text views for the keyboard.md).


Click [**here for an article on creating debugger-friendly classes**](Creating debugger-friendly classes.md)