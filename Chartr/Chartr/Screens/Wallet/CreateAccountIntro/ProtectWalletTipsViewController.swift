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

class ProtectWalletTipsViewController: UIPageViewController {
    private var pageControl: UIPageControl!
    
    private lazy var viewControllerList: [UIViewController] = {
        return createViewControllers()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstView = viewControllerList.first {
            setViewControllers([firstView], direction: .forward, animated: true)
        }
        
        setupPager()
    }
    
    private func setupPager() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 265, width: UIScreen.main.bounds.width, height: 50 ))
        pageControl.numberOfPages = viewControllerList.count
        pageControl.currentPage = 0
        pageControl.tintColor = AppColor.disabledGrey.color
        pageControl.pageIndicatorTintColor = AppColor.disabledGrey.color
        pageControl.currentPageIndicatorTintColor = AppColor.aeroBlue.color
        view.addSubview(pageControl)
    }
    
    private func createViewControllers() -> [UIViewController] {
        let keyToAccountView = UIStoryboard(name: "ProtectWalletTips", bundle: nil)
            .instantiateViewController(withIdentifier: "KeyToAccountInfo")
        let keepPhraseSafeView = UIStoryboard(name: "ProtectWalletTips", bundle: nil)
            .instantiateViewController(withIdentifier: "KeepPhraseSafeInfo")
        
        return [keyToAccountView, keepPhraseSafeView]
    }
}

extension ProtectWalletTipsViewController: UIPageViewControllerDelegate {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if completed {
                let currentView = pageViewController.viewControllers![0]
                self.pageControl.currentPage = viewControllerList.firstIndex(of: currentView)!
            }
        }
}

extension ProtectWalletTipsViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // Validate previousIndex is within range otherwise bail
        guard previousIndex >= 0 else {
            return nil
        }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        // Validate nextIndex is within range otherwise bail
        guard nextIndex < viewControllerList.count else {
            return nil
        }
        
        return viewControllerList[nextIndex]
    }
}
