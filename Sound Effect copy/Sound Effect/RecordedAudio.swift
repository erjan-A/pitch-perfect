//
//  RecordedAudio.swift
//  Sound Effect
//
//  Created by Yerzhan Assanov on 3/21/15.
//  Copyright (c) 2015 EA. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
