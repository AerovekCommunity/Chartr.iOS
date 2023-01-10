//
//  CreatePinViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 6/7/22.
//

import UIKit

class OnboardingViewController: UIPageViewController {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navController = self.navigationController as? ChartrNavigationController else { return }
        navController.updateNavigationBar()
    }
    
    private func setupPager() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 160, width: UIScreen.main.bounds.width, height: 50 ))
        pageControl.numberOfPages = viewControllerList.count
        pageControl.currentPage = 0
        pageControl.tintColor = AppColor.disabledGrey.color
        pageControl.pageIndicatorTintColor = AppColor.disabledGrey.color
        pageControl.currentPageIndicatorTintColor = AppColor.aeroBlue.color
        view.addSubview(pageControl)
    }
    
    private func createViewControllers() -> [UIViewController] {
        let welcomeView = UIStoryboard(name: "Onboarding", bundle: nil)
            .instantiateViewController(withIdentifier: "WelcomeView")
        let blockchainInfoView = UIStoryboard(name: "Onboarding", bundle: nil)
            .instantiateViewController(withIdentifier: "BlockchainInfoView")
        let payWithAeroView = UIStoryboard(name: "Onboarding", bundle: nil)
            .instantiateViewController(withIdentifier: "PayWithAeroView")
        let decentralizedInfoView = UIStoryboard(name: "Onboarding", bundle: nil)
            .instantiateViewController(withIdentifier: "DecentralizedInfoView")
        
        return [welcomeView, blockchainInfoView, payWithAeroView, decentralizedInfoView]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    
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

extension OnboardingViewController: UIPageViewControllerDataSource {
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

extension OnboardingViewController: NavigableViewController {
    var navBarStyle: NavigationBarStyle { return .hidden }
}
