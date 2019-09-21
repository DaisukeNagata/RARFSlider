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

- Show or hide the UI by tapping the preview screen

### version 0.4.5
```ruby
You can set it to your favorite design.

    @IBOutlet public weak var rARFSlider: UISlider?

    @IBOutlet public weak var rARFTimeLabel: UILabel?
    @IBOutlet public weak var rARFDurationLabel: UILabel?

    @IBOutlet public weak var rARFPicBt: UIButton?
    @IBOutlet public weak var rARFTrimButton: UIButton?
    @IBOutlet public weak var rARFMergeButton: UIButton?
    @IBOutlet public weak var rARFInsideTrimButton: UIButton?

    @IBOutlet public weak var rARFPreView: RARFPreView?
    @IBOutlet public weak var rARFLargePreView: UIImageView?
    @IBOutlet public weak var rARFThumnaiIImageView: UIImageView?

```

## Example
<p align="center">
<img src="https://user-images.githubusercontent.com/16457165/55725191-223bcb80-5a48-11e9-8f96-9a8b6fe59892.gif" width="285" height="680"><img src="https://user-images.githubusercontent.com/16457165/56300661-54001100-6171-11e9-9fff-63cb1b683447.gif" width="285" height="680"><img src="https://user-images.githubusercontent.com/16457165/64950961-a166e280-d8b7-11e9-9de3-fea9a87044f1.png" width="285" height="680">
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

        sliderView.imagePick(vc: self, callBack: callBack)
    }

    func callBack() {
        guard let url = url else  { return }

        sliderView.removeFromSuperview()
        sliderView = RARFSliderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(sliderView)

        sliderView.rARFVc = self
        //DESIGNSET
        sliderView.rARFOpacity = 0.7
        sliderView.rARFSideWhide = 1
        sliderView.rARFBorderWidth = 1
        sliderView.rARFTopDownWhide = 1
        sliderView.rARFBorderColor = .white
        sliderView.rARFSetVideoModel.setURL(url: url, sliderView: sliderView, height: 100, heightY: 100)
    }
}
```

## Author

daisukenagata, dbank0208@gmail.com

## License

RARFSlider is available under the MIT license. See the LICENSE file for more info.
