//
//  CustomAnnotation.swift
//  HafenCity
//
//  Created by Ben Meline on 2/18/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String = ""
    var subtitle: String = ""
    var imagePath: String = ""
    var text: String = ""
    var directory: String = ""
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }
}
