//
//  CreateWalletViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

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
