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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavBar()
        textView = UITextView()
        textView.font = UIFont.systemFontOfSize(18)
        textView.selectable = false
        textView.editable = false
        textView.text = "This project was made possible thanks to support from the following organizations:\n\u{2022} Hamburg University\n\u{2022} Hamburgisches Architekturarchiv\n\u{2022} Max Kade Foundation\n\u{2022} Northwestern University\n\nPlease send comments to benjaminmeline2015@u.northwestern.edu"
        
        self.view.addSubview(textView)
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textView.frame = self.view.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
