//
//  Person.swift
//  SwiftLikedOrNope
//
// Copyright (c) 2014 to present, Richard Burdish @rjburdish
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit



class vidPerson: NSObject {
    
    let companyName: NSString
    let productName: NSString
    let vidPath: NSString
    let cost: NSNumber
    
    
    
    //unnecessary stuff
    let Age: NSNumber
    let NumberOfSharedFriends: NSNumber?
    let NumberOfSharedInterests: NSNumber
    let NumberOfPhotos: NSNumber
    
    override var description: String {
        return "Name: \(companyName), \n Image: \(vidPath), \n Age: \(Age) \n NumberOfSharedFriends: \(NumberOfSharedFriends) \n NumberOfSharedInterests: \(NumberOfSharedInterests) \n NumberOfPhotos/: \(NumberOfPhotos)"
    }
    
    init(cname: NSString?, pname: NSString?, cost: NSNumber?, vidPath: NSString?) {
        self.companyName = cname ?? ""
        self.productName = pname ?? ""
        self.cost = cost!
        self.vidPath = vidPath ?? ""
        
        //useless but has to be here
        self.Age = 0;
        self.NumberOfSharedFriends = 0;
        self.NumberOfPhotos = 0;
        self.NumberOfSharedInterests = 0;
    }
}