//
//  Post.swift
//  FirebaseTest
//
//  Created by SHAILENDRA KUSHWAHA on 24/06/21.
//

import Foundation

class Post : Decodable {
    var userId: String?
    var imgURL:String?
    var likecount:Int?
    var isLiked:Bool? = false
}
