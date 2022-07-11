//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Ilya Vasilev on 13.05.2022.
//

import UIKit

class InfoViewController: UIViewController {
    //MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textInfoView: UITextView!

    //MARK: - Let/var
    let heightScreen : CGFloat = UIScreen.main.bounds.height
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
