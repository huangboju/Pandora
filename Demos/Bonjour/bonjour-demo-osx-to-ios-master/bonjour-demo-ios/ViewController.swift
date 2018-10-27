//
//  ViewController.swift
//
//  Created by James Zaghini on 6/05/2015.
//  Copyright (c) 2015 James Zaghini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BonjourClientDelegate {
    
    var bonjourClient: BonjourClient!
    
    @IBOutlet var toSendTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var receivedTextField: UITextField!
    @IBOutlet var connectedToLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bonjourClient = BonjourClient()
        self.bonjourClient.delegate = self
    }
    
    func connectedTo(_ socket: GCDAsyncSocket!) {
        connectedToLabel.text = "Connected to " + socket.connectedHost
    }
    
    func disconnected() {
        connectedToLabel.text = "Disconnected"
    }
    
    func handleBody(_ body: String?) {
        receivedTextField.text = body
    }

    func handleHeader(_ header: UInt) {
        
    }

    @IBAction func sendText() {
        if let data = toSendTextField.text?.data(using: .utf8) {
            bonjourClient.send(data)
        }
    }
}

