//
//  ColorUICollectionViewCell.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit

protocol ColorUICollectionViewCellDelegate {
    
}

class ColorUICollectionViewCell: UICollectionViewCell {
    
    var delegate: ColorUICollectionViewCellDelegate!
    var textLabel: UILabel!
    var checkImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
        addCheck()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel() {
        // add label
        textLabel = UILabel(frame: CGRect(x: self.frame.size.width * 0.03, y: self.frame.size.height * 0.80, width: self.frame.size.width, height: self.frame.size.height / 4))
        textLabel.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        textLabel.textAlignment = .Left
        textLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(textLabel)
    }
    
    func addCheck() {
        // create check image
        let checkImage = UIImage(named: "checkmark")
        checkImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.size.height / 4, height: bounds.size.height / 4))
        checkImageView.image = checkImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        checkImageView.tintColor = UIColor.whiteColor()
        
        // add the views
        addSubview(checkImageView)
    }
    
    func hideCheck() {
        checkImageView.hidden = true
    }
    
    func showCheck() {
        checkImageView.hidden = false
    }
}