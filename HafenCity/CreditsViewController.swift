//
//  CreditsViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 3/5/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

    var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var frame = self.view.frame
        frame.origin.y = 64
        textView = UITextView(frame: frame)
        textView!.text = "Thank you to the following:\n\n\n\n\nhelloooooo"
        self.view.addSubview(textView!)
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
