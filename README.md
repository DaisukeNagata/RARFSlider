# RARFSlider

<p align="center">
<img width="600" height="400" src="https://user-images.githubusercontent.com/16457165/55722918-8eb3cc00-5a42-11e9-96c9-ac0321ad5e14.png">
</p>

[![Version](https://img.shields.io/cocoapods/v/RARFSlider.svg?style=flat)](https://cocoapods.org/pods/RARFSlider)
[![License](https://img.shields.io/cocoapods/l/RARFSlider.svg?style=flat)](https://cocoapods.org/pods/RARFSlider)
[![Platform](https://img.shields.io/cocoapods/p/RARFSlider.svg?style=flat)](https://cocoapods.org/pods/RARFSlider)


## Example
<img src="https://user-images.githubusercontent.com/16457165/55725191-223bcb80-5a48-11e9-8f96-9a8b6fe59892.gif" width="290" height="680">

## Requirements
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation
RARFSlider is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RARFSlider'
```

## operation

picButton opens a video album.

Button saves the edited video.

Merge combines the first and second edit videos.

Reference video
https://twitter.com/dbank0208/status/1116069455174307840?s=20

## Code

```ruby
import UIKit
import RARFSlider

// I have set the picker in the delegate.
class ViewController: RARFPickerViewController {

    var sliderView = RARFSliderView()
    var setVideoModel = RARFMaskVideoModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        // I have set the picker.
        let imagePickerModel = RARFImagePickerModel()
        imagePickerModel.mediaSegue(vc: self, bool: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        //DESIGNSET
        guard let url = url else  { return }
        sliderView.removeFromSuperview()
        sliderView = RARFSliderView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView)
        sliderView.vc = self
        sliderView.slider.isHidden = false
        sliderView.borderWidth = 1; sliderView.borderColor = .red; sliderView.topDownWhide = 4; sliderView.sideWhide = 8
        sliderView.setVideoModel.setURL(url: url, sliderView: sliderView, heightY: 0, height: 100)
    }
}
```

## Author

daisukenagata, dbank0208@gmail.com

## License

RARFSlider is available under the MIT license. See the LICENSE file for more info.
