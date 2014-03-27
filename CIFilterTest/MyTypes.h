//
//  MyTypes.h
//  ChromaKey
//
//  Created by Duncan Champney on 10/4/12.
//
//

#ifndef ChromaKey_MyTypes_h
#define ChromaKey_MyTypes_h

#define kPopoverDismissedNotice  @"PopoverDismissedNotice"




typedef enum
{
  kMorphTypePopup = 1,
  kImagePopup = 2
} popupTags;


typedef enum
{
  photoFromLibrary =  1,
  photoFromCamera =   2,
  useVideo =          3,
  sampleImage = 4
} imageSources;


typedef  void (^pickImageCompletionBlock)(imageSources imageSource, UIImage *theImage);

typedef void (^sheetDismissedBlock)(UIActionSheet* theSheet, NSInteger buttonIndex);

typedef void (^alertDismissedBlock)(UIAlertView* theSheet, NSInteger buttonIndex);

#endif
