/*
The MIT License (MIT)

Copyright (c) 2023-present Aerovek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import UIKit
import Lottie

extension UIView {
    
    var isActivityIndicatorActive: Bool { return currentActivityIndicator() != nil }
    
    func showActivityIndicator(style: UIActivityIndicatorView.Style? = nil) {
        // If already showing just bail out
        guard !isActivityIndicatorActive else { return }
        
        DispatchQueue.main.async {
            if let thisButton = self as? ChartrButton {
                
                self.addActivityIndicator()
                
                thisButton.setTitle("", for: .disabled)
                thisButton.setAttributedTitle(NSAttributedString(string: ""), for: .disabled)
                thisButton.isEnabled = false
            } else {
                self.alpha = 0.0
                self.addActivityIndicator()
            }
        }
    }
    
    func hideActivityIndicator(isEnabled: Bool = true) {
        // Mirror dispatch in showActivityIndicator in case hideActivityIndicator is called before the dispatched
        // code is executed. This prevents buttons from remaining disabled and non-button alphas remaining 0.
        DispatchQueue.main.async {
            guard let indicator = self.currentActivityIndicator() else { return }
            
            indicator.removeFromSuperview()
            
            if let thisButton = self as? ChartrButton {
                thisButton.setTitle(nil, for: .disabled)
                thisButton.setAttributedTitle(nil, for: .disabled)
                thisButton.isEnabled = isEnabled
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    private func addActivityIndicator() {
        let indicator = UIActivityIndicatorView(
            frame: CGRect(x: frame.minX + (frame.size.width / 2), y: frame.midY, width: frame.size.height/2, height: frame.size.height/2))
        indicator.style = .medium
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        indicator.startAnimating()
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        indicator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        indicator.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        indicator.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)

        // Prevent indicator from animating in from top left
        layoutIfNeeded()
    }
    
    private func currentActivityIndicator() -> UIActivityIndicatorView? {
        return subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView
    }
}
