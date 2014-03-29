#CoreImage Filter Demo

This project lets you explore the CoreImage filters offered by the current version of iOS.

At launch it interrogates the system for a list of supported filters and adds them to a popup list of filters.

It attempts to set reasonable values for the different parameters, and looks for settings that specify slider settings. When it finds settings that specify slider settings it configures up to 5 sliders with the name of the attribute and its maximum, minimum, and default value.

This project now uses a Cocoapod to add support for iOS color pickers. 

###**NOTE: Be sure to open the Xcode workspace file, not the project**.


Note the the project is for iPad only, and runs **MUCH** bettter on an actual device. (Apparently the simulator implementation of Core Image is quite slow.)