# SRGNovelGameTexts
SRGNovelGameTexts can show text view like a novel game texts, its easily and simple.
##Screenshot
![](https://dl.dropboxusercontent.com/u/461628/SRGNovelGameTextsPreview.gif)
##Examples
---------
```objc
    // initialize novel text view
    SRGNovelGameTexts *novelGameText = [SRGNovelGameTexts new];
    novelGameText.frame = CGRectMake(0,0,100,100);
    novelGameText.textColor = [UIColor blackColor];
    [self.view addSubview:novelGameText];
    
    // set display
    [novelGameText setText:@"Hello Novel Texts View"];
    
    // start effect
    [novelGameText startDisplayingText];
```
See the demo project for more examples.
##Setup Instructions
Install with [CocoaPods](http://cocoapods.org) by adding the following to your Podfile:

``` ruby
platform :ios, '7.0'
pod 'SRGNovelGameTexts', '~> 0.0.1'
```

or add manually: 

Add `SRGNovelGameTexts.h` & `SRGNovelGameTexts.m` to your project.



