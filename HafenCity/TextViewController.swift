//
//  TextViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 4/4/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    var text: String?
    var textList: [String?] = []
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView = UITextView()
        
        // attributes
        if text != nil {
            textView.text = text
        } else {
            textView.text = textList[0]
        }
                
        textView.font = UIFont.systemFontOfSize(18)
        textView.textColor = UIColor.whiteColor()
        textView.selectable = false
        textView.editable = false
        
        // background
        textView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        textView.layer.cornerRadius = 5
        textView.clipsToBounds = true
        
        self.view.addSubview(textView!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // set frame
        let frame = self.view.frame
        let x: CGFloat = 10
        let width = frame.size.width - frame.origin.x - 2*x
        let height: CGFloat = 170
        let y = frame.size.height - frame.origin.y - height - 46
        let frameText = CGRectMake(x, y, width, height)
        textView.frame = frameText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeTextFromList(index: Int) {
        textView.text = textList[index]
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