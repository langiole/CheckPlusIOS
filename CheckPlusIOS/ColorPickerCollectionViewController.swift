//
//  ColorPickerCollectionViewController.swift
//  CheckPlusIOS
//
//  Created by Lee Angioletti on 7/13/16.
//  Copyright © 2016 Lee Angioletti. All rights reserved.
//

import UIKit

class ColorPickerCollectionViewController: UICollectionViewController, ColorUICollectionViewCellDelegate {
    
    var colorList = [Colors]()
    var selectedColor: UIColor!
    var selectedIndex: Int!
    var deselectedIndex: Int!
    
    let settings = SettingVariables.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation back button to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
        
        // set title
        self.navigationController?.visibleViewController?.title = "Choose color"
        
        // set colorList to a set of colors
        colorList.append(Colors(name: "Turquoise", red: 0.10, green: 0.74, blue: 0.61, selected: false))
        colorList.append(Colors(name: "Green Sea", red: 0.09, green: 0.63, blue: 0.52, selected: false))
        colorList.append(Colors(name: "Sun Flower", red: 0.95, green: 0.77, blue: 0.06, selected: false))
        colorList.append(Colors(name: "Orange", red: 0.95, green: 0.61, blue: 0.07, selected: false))
        colorList.append(Colors(name: "Emerald", red: 0.18, green: 0.80, blue: 0.44, selected: false))
        colorList.append(Colors(name: "Nephritis", red: 0.15, green: 0.68, blue: 0.38, selected: false))
        colorList.append(Colors(name: "Carrot", red:0.90, green:0.49, blue:0.13, selected: false))
        colorList.append(Colors(name: "Pumpkin", red:0.83, green:0.33, blue:0.00, selected: false))
        colorList.append(Colors(name: "Peter River", red:0.20, green:0.60, blue:0.86, selected: false))
        colorList.append(Colors(name: "Belize Hole", red:0.16, green:0.50, blue:0.73, selected: false))
        colorList.append(Colors(name: "Alizarin", red:0.91, green:0.30, blue:0.24, selected: false))
        colorList.append(Colors(name: "Pomegranate", red:0.75, green:0.22, blue:0.17, selected: false))
        colorList.append(Colors(name: "Amethyst", red:0.61, green:0.35, blue:0.71, selected: false))
        colorList.append(Colors(name: "Wisteria", red:0.56, green:0.27, blue:0.68, selected: false))
        colorList.append(Colors(name: "Wet Asphalt", red:0.20, green:0.29, blue:0.37, selected: false))
        colorList.append(Colors(name: "Midnight Blue", red:0.17, green:0.24, blue:0.31, selected: false))
        colorList.append(Colors(name: "Concrete", red:0.58, green:0.65, blue:0.65, selected: false))
        colorList.append(Colors(name: "Asbestos", red:0.50, green:0.55, blue:0.55, selected: false))
        
        // set initial selected color
        collectionView?.allowsMultipleSelection = false
        
        let rgb1 = CGColorGetComponents(settings.backgroundColor.CGColor)
        let r1 = round((rgb1[0]) * 100.0) / 100.0
        let r2 = round((rgb1[1]) * 100.0) / 100.0
        let r3 = round((rgb1[2]) * 100.0) / 100.0
        
        for color in colorList {
            let rgb2 = CGColorGetComponents(color.color.CGColor)
            if r1 == rgb2[0] && r2 == rgb2[1] && r3 == rgb2[2] {
                color.selected = true
            }
        }
        
        // set delegates
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.registerClass(ColorUICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hide status bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return colorList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ColorUICollectionViewCell
        
        // Configure the cell
        let color = colorList[(indexPath as NSIndexPath).row]
        cell.delegate = self
        cell.textLabel.text = color.name
        cell.backgroundColor = color.color
        
        if color.selected {
            cell.showCheck()
        }
        else {
            cell.hideCheck()
        }
        
        return cell
    }
    
    // size of each cell
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = UIScreen.mainScreen().bounds.width
        let width = Int((screenWidth - 2.0) / 3.0)
        let size = CGSize(width: width, height: width)
        return size
    }
    
    // horizontal spacing
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    // vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    // user selects item
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // set colors to false for selection
        for (index, color) in colorList.enumerate() {
            if index == indexPath.row {
                color.selected = true
                settings.backgroundColor = color.color
            }
            else {
                color.selected = false
            }
        }
        collectionView.reloadData()
    }
    
    // user desects item
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        deselectedIndex = (indexPath as NSIndexPath).row
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
        
        if parent == nil{
            if selectedColor != nil {
                // backgroundColor = selectedColor
                settings.backgroundColor = selectedColor
            }
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}