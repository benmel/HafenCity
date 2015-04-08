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
        self.edgesForExtendedLayout = .Top
        
        textView = UITextView()
        textView.font = UIFont.systemFontOfSize(18)
        textView.selectable = false
        textView.editable = false
        textView.text = "This project was made possible thanks to the support from the following organizations:\nHamburg University\nMax Kade Foundation\nNorthwestern University\nHamburgisches Architekturarchiv\n\nIcons are licensed under Creative Commons 3.0 from:\nMenu icon from Freepik\nGPS icon from Icons8\n\nBuilt by Ben Meline in March 2015\nSend comments to benjaminmeline2015@u.northwestern.edu"
        
        self.view.addSubview(textView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var frame = self.view.frame
//        frame.origin.y = 64
        textView.frame = frame
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
