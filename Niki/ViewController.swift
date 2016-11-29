//
//  ViewController.swift
//  Niki
//
//  Created by Arjun Kodur on 11/28/16.
//  Copyright © 2016 Arjun Kodur. All rights reserved.
//

import UIKit
import XMSegmentedControl
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, XMSegmentedControlDelegate, UITextFieldDelegate {

    @IBOutlet var customInputView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: XMSegmentedControl!
    
    let url = URL(string: "http://private-b2371-mobiletest2.apiary-mock.com/domains")
    var json: JSON?
    var keyBoardheight: CGFloat?
    var icons1:[UIImage]?
    var domain = [String:String]()
    var suggestions = [String]()
    
    let leftbutton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let rightImageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 20, height: 20))
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //textField.inputView = customInputView
        textField.inputView = nil
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        leftImageView.isUserInteractionEnabled = true
        leftImageView.addGestureRecognizer(tapGestureRecognizer)
        leftbutton.isEnabled = true
        leftbutton.addGestureRecognizer(tapGestureRecognizer)
        
        
        textField.layer.borderColor = UIColor(red: 181.0/250.0, green: 181.0/250.0, blue: 181.0/250.0, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        
        textField.leftView = leftbutton
        textField.rightView = rightImageView
        textField.rightView?.tintColor = UIColor.blue
        

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
         let icons2:[UIImage] = [UIImage(named: "recharge_144")!, UIImage(named: "bus_144")!, UIImage(named: "icon5")!, UIImage(named: "hotel_144")!, UIImage(named: "icon1")!]
        segmentedControl.segmentIcon = icons2
        segmentedControl.selectedItemHighlightStyle = .BottomEdge
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.highlightColor = UIColor(red: 60.0/255.0, green: 120.0/255.0, blue: 216.0/255.0, alpha: 1.0)
        segmentedControl.highlightTint = UIColor.black
        segmentedControl.tint = UIColor.black
        segmentedControl.delegate = self
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
                keyBoardheight = keyboardSize.height
            }
        }
        
    }
    
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        print("SegmentedControl Selected Segment: \(selectedSegment)")
        
        tableView.reloadData()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textField.inputView = nil
//        UIView.animate(withDuration: 0.5) {
//            
//            self.view.frame.origin.y += self.keyBoardheight!
//        }
        
        
    }
    
    func imageTapped(img: AnyObject) {
        textField.inputView = customInputView
        textField.reloadInputViews()
    
        print("call")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = (self.json?[0]["domains"][segmentedControl.selectedSegment]["suggestions"].count) {
            return count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = self.json?[0]["domains"][segmentedControl.selectedSegment]["suggestions"][indexPath.row].stringValue
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont(name: "avenir", size: 21)!]
        self.navigationItem.title = "Niki"
        
        
        
        //Setting right bar button item
        let hamburger = UIImage(named: "hamburger")
        
        let composeButton = UIBarButtonItem(image: hamburger, style: .plain, target: self, action: nil)
        
        self.navigationController?.navigationItem.leftBarButtonItem = composeButton
        
        let leftImage = UIImage(named: "icon2")
        
        leftbutton.setBackgroundImage(leftImage, for: .normal)
        leftbutton.setTitleColor(UIColor.lightGray, for: .normal)
        
        leftImageView.image = leftImage
        
        let rightImage = UIImage(named: "icon4")!

        rightImageView.image = rightImage
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            self.json = JSON(data: data)
            
        }
        
        task.resume()

    }
    
    
    

}


