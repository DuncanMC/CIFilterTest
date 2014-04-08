##Using Core Image filters (CIFilter objects)

The `CIFilter` class includes class methods that let you ask for a list of filters, as well as methods that let you ask about the inputs used to configure each filter, and the output(s) it provides.


Core Image filters are devided into categories. Most CIFilters belong to more than one category.

The CIFilterTest app is written to ask the system for a list of supported filters, and then presents a list of those filters in a table view grouped by category.

There are 2 methods that let you get lists of avilable filters that match a specific category or categories: `+[filterNamesInCategories:]`, and `+[filterNamesInCategory:]`

###`+ (NSArray *)filterNamesInCategories:(NSArray *)categories`

This methd takes an array of filter category strings, and returns an array of `CIFilter`s that belong to all the categorys you specify. 

Pass `categories = nil` to get a list of all filters in *all* categories. (In other words, a list of **all** available filters.) However, you can't be sure the resulting list will be grouped by category



###`+ (NSArray *)filterNamesInCategory:(NSString *)category`

This method returns all the filters that belong to a single category.


-----------

Once you have selected a filter by name, you load it using `CIFilter` class method `+filterWithName`

* The `CIFilter` object includes a number of properties that let you find out what inputs and outputs that filter uses.

* The `attributes` property returns a dictionary of key/value pairs with information about the various input and output attributes used with this filter.

* Inside the `attributes` property, The `CIAttributeFilterCategories` key/value pair contains an array of the strings listing the `CIFilter` categories that this filter belongs to.

* The `inputKeys` property returns an array of the keys in the `attributes` dictinoary that describe inputs to the filter.

* The `outputKeys` property returns an array of the keys in the `attributes` dictinoary that describe the filter's outputs. As of this writing, this property always contains a single entry, "OutputImageKey" (The output image from the filter.)

If you use one of the entries in the `inputKeys` array to fetch a value from the `attributes` dictionary, you will get another dictionary containing information about that input parameter for the filter.

Core Image filters use Core Image datatypes like CIImage, CIVector,  and CIColor, as well as NSNumber. The entry for each inputKey in the attributes dictionary includes a key/value pair `CIAttributeClass` that tells you the data type of that input parameter, and another key/value pair `CIAttributeClass` that tells you how the parameter is used. (e.g. the inputKey inputCenter has a `CIAttributeClass` of `CIVector` and a `CIAttributeType` of `CIAttributeTypePosition`.)

The attributes entry for many input Key values includes a default value for that input key, and sometimes also contains minimum and maximum value ranges. Note that sometimes the deafult values listed in the attributes dictionary do not match the default values that are actually contained in the filter, and that sometimes the minimum and maximum value ranges are wrong. For example, the CILightTunnel filters lists a default inputRotation value of 9, a CIAttributeSliderMin (minimum value) of 0, and a CIAttributeSliderMax value of 1.570796326794897 (pi/2). However, the actual rotation setting that is installed in the filter is 100, and values ranging from -100 to +100 are perfectly valid to use.

Also, the settings for the CIBumpDistortion filter list a CIAttributeDefault setting of 150, 150 for the inputCenter attribute (In other words, the default center-point for the bump distortion filter should be (150, 150).) However, the CIBumpDistortion does not have any value set for it's inputCenter property by default, so the filter does nothing. You have to explictly set an inputCenter value before this filter makes any change to the image.

