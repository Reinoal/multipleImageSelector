//
//  ImageSelectCell.swift
//  Discover
//
//  Created by lansoft on 2021/9/17.
//

import Foundation
import UIKit

class ImageSelectCell: BaseCollectionViewCell{
    
    lazy var numberLabel: UILabel = {
        let l = UILabel.init()
        l.font = UIFont._12
        l.textColor = .white
        l.layer.borderColor = UIColor.white.cgColor
        l.layer.borderWidth = 0.5
        l.textAlignment = .center
        return l
    }()
    
    lazy var imageV: UIImageView = {
        let v = UIImageView.init()
        v.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var selectBtn: UIButton = {
        let selectB = UIButton.init()
        selectB.setImage(UIImage.init(named: "ic_has_input"), for: .normal)
        selectB.setImage(UIImage.init(named: "checked_round"), for: .selected)
        return selectB
    }()
    
    lazy var coverView: UIView = {
        let cv = UIView()
        cv.backgroundColor = UIColor.transformGreyColor
        return cv
    }()
    
    override func initCell() {
        contentView.addSubview(imageV)
        imageV.addSubview(coverView)
        imageV.addSubview(numberLabel)
        imageV.addSubview(selectBtn)
    }
    
    override func layoutSubviews() {
        imageV.size = size
        let imageSize = selectBtn.currentImage!.size
        selectBtn.frame = CGRect.init(x: width - imageSize.width - 5, y: 5, width: imageSize.width, height: imageSize.height)
        coverView.size = size
        numberLabel.frame = CGRect.init(x: 5, y: 5, width: 20, height: 20)
        numberLabel.cornerRadius(10)
    }
}
