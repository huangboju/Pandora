//
//  ViewController.swift
//  ios-bonjour
//
//  Created by Ugur Temiz on 27/08/15.
//  Copyright (c) 2015 Ugur Temiz. All rights reserved.
//

import CocoaAsyncSocket
import UIKit

enum TAG: Int {
    case header = 1
    case body   = 2
}

class ViewController: UIViewController, NetServiceDelegate, NetServiceBrowserDelegate, GCDAsyncSocketDelegate {

    var service : NetService!
    var socket  : GCDAsyncSocket!
    
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var receiverTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTalking()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func parseHeader(_ data: Data) -> UInt {
        var out: UInt8 = 0
        data.copyBytes(to: &out, count: data.count)
        return UInt(out)
    }

    func handleResponseBody(_ data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            receiverTextField.text = message
        }
    }

    @IBAction func sendText() {
        if let data = self.senderTextField.text?.data(using: .utf8) {
            var header = data.count
            let headerData = Data(bytes: &header, count: MemoryLayout<UInt>.size)
            socket.write(headerData, withTimeout: -1.0, tag: TAG.header.rawValue)
            socket.write(data, withTimeout: -1.0, tag: TAG.body.rawValue)
        }
    }

    func startTalking () {
        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)

        do {
            try socket.accept(onPort: 0)
            service = NetService(domain: "local.", type: "_probonjore._tcp.", name: UIDevice.current.name, port: Int32(socket.localPort))
            service.delegate = self
            service.publish()
        } catch let error {
            print("Error occured with acceptOnPort. Error \(error)")
        }
    }

    /*
    *  Delegates of NSNetService
    **/
    
    func netServiceDidPublish(_ sender: NetService) {
        print("Bonjour service published. domain: \(sender.domain), type: \(sender.type), name: \(sender.name), port: \(sender.port)")
    }
    
    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("Unable to create socket. domain: \(sender.domain), type: \(sender.type), name: \(sender.name), port: \(sender.port), Error \(errorDict)")
    }
    
    /*
    *  END OF Delegates
    **/
    
    /*
    *  Delegates of GCDAsyncSokcket
    **/

    func socket(_ sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        print("Did accept new socket")
        socket = newSocket
        
        socket.readData(toLength: UInt(MemoryLayout<UInt64>.size), withTimeout: -1.0, tag: 0)
        print("Connected to " + service.name)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket!, withError err: Error!) {
        print("Socket disconnected: error \(err)")
        if self.socket == socket {
            print("Disconnected from " + self.service.name)
        }
    }

    func socket(_ sock: GCDAsyncSocket!, didRead data: Data!, withTag tag: Int) {
        if data.count == MemoryLayout<UInt>.size {
            let bodyLength = parseHeader(data)
            sock.readData(toLength: bodyLength, withTimeout: -1, tag: TAG.body.rawValue)
        } else {
            handleResponseBody(data)
            sock.readData(toLength: UInt(MemoryLayout<UInt>.size), withTimeout: -1, tag: TAG.header.rawValue)
        }
    }

    func socket(_ sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        print("Write data with tag of \(tag)")
    }

    /*
    *  END OF Delegates
    **/
}

