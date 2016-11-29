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

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, XMSegmentedControlDelegate {

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
    
    let leftImageView = UIImageView()
    let rightImageView = UIImageView()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        textField.inputView = customInputView
        
        var frameRect = textField.frame;
        frameRect.size.height = 40; // <-- Specify the height you want here.
        textField.frame = frameRect
        
        textField.layer.borderColor = UIColor(red: 181.0/250.0, green: 181.0/250.0, blue: 181.0/250.0, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        
        leftImageView.tintColor = UIColor.black
        rightImageView.tintColor = UIColor.black
        
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        
        textField.leftView = leftImageView
        textField.rightView = rightImageView
        

        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        UIView.animate(withDuration: 0.5) {
            
            self.view.frame.origin.y += self.keyBoardheight!
        }
        
        
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
        
        leftImageView.image = UIImage(named: "icon2")!
        rightImageView.image = UIImage(named: "icon4")!
        
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


