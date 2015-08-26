//
//  BMPhotoBrowser.swift
//  HafenCity
//
//  Created by Ben Meline on 8/25/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

class BMPhotoBrowser: MWPhotoBrowser {    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
}
