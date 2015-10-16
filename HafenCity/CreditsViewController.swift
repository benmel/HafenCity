//
//  CreditsViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 3/5/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    var textView: UITextView!
    private let text = "This project was made possible thanks to support from the following organizations:\n\u{2022} Hamburg University\n\u{2022} Hamburgisches Architekturarchiv\n\u{2022} Max Kade Foundation\n\u{2022} Northwestern University\n\nLearn more about this project at: https://curricula.mmlc.northwestern.edu/hamburg/2015s6/home-english/\nPlease send comments to: benjaminmeline2015@u.northwestern.edu"
    private let spacing: CGFloat = 10
    private let systemVersion = NSString(string: UIDevice.currentDevice().systemVersion).doubleValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTextView()
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
    }
    
    func setupTextView() {
        textView = UITextView()
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(textView)
        
        let top: NSLayoutConstraint
        if systemVersion >= 9 {
            top = NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0)
        } else {
            top = NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0)
        }
        let bottom = NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: textView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: spacing)
        let trailing = NSLayoutConstraint(item: textView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -spacing)
        view.addConstraints([top, bottom, leading, trailing])
        
        textView.font = UIFont.systemFontOfSize(18)
        textView.editable = false
        textView.dataDetectorTypes = .Link
        textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        textView.text = text
    }
}
