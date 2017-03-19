//
//  PageVC.swift
//  WeatherGift
//
//  Created by CSOM on 2/21/17.
//  Copyright © 2017 CSOM. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
//instance variables: variables available throughout the class. Declare after class definition and before first func
    var currentPage = 0
    var locationsArray = ["Local City",
                          "Sydney, Australia",
                          "Accra, Ghana",
                          "Uglich, Russia"]
    var pageControl: UIPageControl!
    var listButton: UIButton!
    let barButtonWidth: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        //this view source you're creating? Whole class is going to pay attention to it and it will be the source of the data that controls the view controller
        dataSource = self
        
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
        
        configurePageControl()
        configureListButton()
    }

    //MARK: - UI Configuration Methods
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonWidth
        let pageControlWidth: CGFloat = view.frame.width - (barButtonWidth * 2)
        
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: view.frame.height - pageControlHeight, width: pageControlWidth, height: pageControlHeight))
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        
        view.addSubview(pageControl)
    }
    
    func configureListButton() {
        let barButtonHeight = barButtonWidth
        
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: view.frame.height - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        
        listButton.setBackgroundImage(UIImage(named:"listbutton"), for: .normal)
        listButton.setBackgroundImage(UIImage(named:"listbutton-highlighted"), for: .highlighted)
        
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        
        view.addSubview(listButton)
    }
//MARK: - Segues
    
    func segueToListVC(sender: UIButton!){
        performSegue(withIdentifier: "ToListVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListVC" {
            let controller = segue.destination as! ListVC
            controller.locationsArray = locationsArray
            controller.currentPage = currentPage
        }
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
    }

//MARK: - Create View Controller for UIPageViewController
//forPage means you have to create a DetailVC to pass in the page
// -> means pass back
    func createDetailVC(forPage page: Int) -> DetailVC {
        
        currentPage = min(max(0, page), locationsArray.count - 1)
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        
        return detailVC
    }

}

extension PageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // Swipe right to left, create page after that
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
       
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    // Swipe left to right, create a page for one item less than the current page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVC {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVC {
        pageControl.currentPage = currentViewController.currentPage
        }
    }
}
