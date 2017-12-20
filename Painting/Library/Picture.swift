//
//  Picture.swift
//  Painting
//
//  Created by 黃珮鈞 on 2017/12/19.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import PocketSVG

// MARK: - Picture

public struct Picture {

    // MARK: Property

    public let name: String

    public let imageURL: URL

//    public let creatorID: ProductID

    // MARK: Init

    public init(
        name: String
    ) {

        self.name = name

        self.imageURL = Bundle.main.url(forResource: "\(name)", withExtension: "svg")!

    }

}

//fake picture

public let pictures = [
    Picture(name: "robot"),
    Picture(name: "sketch"),
    Picture(name: "snowman")
]
