//
//  UIImageView+Extension.swift
//  Painting
//
//  Created by Nick Lee on 2017/12/29.
//  Copyright © 2017年 黃珮鈞. All rights reserved.
//

import UIKit

protocol CustomImageViewTouchEventDelegate: class {
    func didTouchesBegan(touches: Set<UITouch>)
    func didTouchesMoved(touches: Set<UITouch>)
    func didTouchesEnd()
}

class CustomImageView: UIImageView {

    weak var delegate: CustomImageViewTouchEventDelegate?

    override init(frame: CGRect = CGRect.init()) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouchesBegan(touches: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouchesMoved(touches: touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTouchesEnd()
    }

}
