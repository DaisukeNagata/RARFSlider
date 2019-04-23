# RARFSlider

<p align="center">
<img width="600" height="400" src="https://user-images.githubusercontent.com/16457165/55722918-8eb3cc00-5a42-11e9-96c9-ac0321ad5e14.png">
</p>

[![Version](https://img.shields.io/cocoapods/v/RARFSlider.svg?style=flat)](https://cocoapods.org/pods/RARFSlider)
[![License](https://img.shields.io/cocoapods/l/RARFSlider.svg?style=flat)](https://cocoapods.org/pods/RARFSlider)
[![Platform](https://img.shields.io/cocoapods/p/RARFSlider.svg?style=flat)](https://cocoapods.org/pods/RARFSlider)

## operation
It is a function to edit Video.

- picButton opens a video album.

- Button saves the edited video.

- Merge combines the first and second edit videos.

- Inside Trim is trims the selected inside.

### version 0.4.3
```ruby
You can set it to your favorite design.

    @IBOutlet public var rARFSlider: UISlider!

    @IBOutlet public var rARFTimeLabel: UILabel!
    @IBOutlet public var rARFDurationLabel: UILabel!

    @IBOutlet public var rARFPicBt: UIButton!
    @IBOutlet public var rARFTrimButton: UIButton!
    @IBOutlet public var rARFMergeButton: UIButton!
    @IBOutlet public var rARFInsideTrimButton: UIButton!

    @IBOutlet public var rARFPreView: RARFPreView!
    @IBOutlet public var rARFLargePreView: UIImageView!
    @IBOutlet public var rARFThumnaiIImageView: UIImageView!
```

## Example
<p align="center">
<img src="https://user-images.githubusercontent.com/16457165/55725191-223bcb80-5a48-11e9-8f96-9a8b6fe59892.gif" width="285" height="680"><img src="https://user-images.githubusercontent.com/16457165/56300661-54001100-6171-11e9-9fff-63cb1b683447.gif" width="285" height="680"><img src="https://user-images.githubusercontent.com/16457165/56594642-29f29700-6628-11e9-8b95-47d25217e83d.jpeg" width="285" height="680">
</p>

## Requirements
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation
RARFSlider is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RARFSlider'
```

## Code

```ruby
import UIKit
import RARFSlider

class ViewController: RARFPickerViewController {

    @IBOutlet private var sliderView: RARFSliderView!


    override func viewDidLoad() {
        super.viewDidLoad()

        sliderView.imagePick(vc: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        guard let url = url else  { return }

        sliderView.removeFromSuperview()
        sliderView = RARFSliderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView)

        sliderView.rARFVc = self
        //DESIGNSET
        sliderView.rARFBorderWidth = 1; sliderView.rARFBorderColor = .white; sliderView.rARFTopDownWhide = 4; sliderView.rARFSideWhide = 8; sliderView.rARFOpacity = 0.7;
        sliderView.rARFSetVideoModel.setURL(url: url, sliderView: sliderView, height: 100, heightY: 100)
    }
}
```

## Author

daisukenagata, dbank0208@gmail.com

## License

RARFSlider is available under the MIT license. See the LICENSE file for more info.
