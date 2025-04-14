//
//  DirectionsData.swift
//  iOSFinalProject
//
//  Created by Edgar Ponce on 2025-04-13.
// This was my attempt to make a directions view controller and i couldnt get to it

import UIKit

class DirectionsData: NSObject {
    
    var routeSteps: NSMutableArray?
    var distSteps: NSMutableArray?
    var destinationName: String?
       
    func initWithData(theRouteSteps r: NSMutableArray, theDistSteps d: NSMutableArray, theDestinationName dn: String)
    
    {
        routeSteps = r
        distSteps = d
        destinationName = dn
    }

}
