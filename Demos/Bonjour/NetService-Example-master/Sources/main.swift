import struct Foundation.Date
import class Foundation.NSNumber
import class Foundation.RunLoop
import NetService
import Socket

// MARK: - Browse for services

class MyBrowserDelegate: NetServiceBrowserDelegate {
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        print("Will search: \(browser)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch error: Error) {
        print("Did not search: \(error)")
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("Did find: \(service)")
    }
    
    public func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        print("Did remove: \(service)")
    }
    
    public func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        print("Did stop: \(browser)")
    }
}

let browser0 = NetServiceBrowser()
browser0.searchForServices(ofType: "_airplay._tcp.", inDomain: "local.")

let browser1 = NetServiceBrowser()
browser1.searchForServices(ofType: "_airport._tcp.", inDomain: "local.")

let browserDelegate = MyBrowserDelegate()
browser0.delegate = browserDelegate
browser1.delegate = browserDelegate


// MARK: - Publish a service

class MyServiceDelegate: NetServiceDelegate {
    func netServiceWillPublish(_ sender: NetService) {
        print("Will publish: \(sender)")
    }
    
    func netServiceDidPublish(_ sender: NetService) {
        print("Did publish: \(sender)")
    }
    
    func netService(_ sender: NetService, didNotPublish error: Error) {
        print("Did not publish: \(sender), because: \(error)")
    }
    
    func netServiceDidStop(_ sender: NetService) {
        print("Did stop: \(sender)")
    }
    
    func netService(_ sender: NetService, didAcceptConnectionWith socket: Socket) {
        print("Did accept connection: \(sender), from: \(socket.remoteHostname)")
        print(try! socket.readString() ?? "")
        try! socket.write(from: "HTTP/1.1 200 OK\r\nContent-Length: 13\r\n\r\nHello, world!")
        socket.close()
    }
}

let ns = NetService(domain: "local.", type: "_airplay._tcp.", name: "example", port: 8000)
precondition(ns.setTXTRecord([
    "pv": "1.0", // state
    "id": "11:22:33:44:55:66:77:99", // identifier
    "c#": "1", // version
    "s#": "1", // state
    "sf": "1", // discoverable
    "ff": "0", // mfi compliant
    "md": "Swift", // name
    "ci": "1" // category identifier
    ]))
let serviceDelegate = MyServiceDelegate()
ns.delegate = serviceDelegate

let ns2 = NetService(domain: "local.", type: "_airplay._tcp.", name: "example2", port: 0)
ns2.delegate = serviceDelegate

if CommandLine.arguments.contains("--publish") {
    // Publish example HomeKit device.
    ns.publish(options: [.listenForConnections])
    ns2.publish(options: [.listenForConnections])
}


// MARK: - Manage runloop

withExtendedLifetime((browser0, browser1, browserDelegate, ns, ns2, serviceDelegate)) {
    if CommandLine.arguments.contains("--test") {
        print("Running runloop for 10 seconds...")
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))
    } else {
        RunLoop.main.run()
    }

    if CommandLine.arguments.contains("--publish") {
        print("Stopping...")
        ns.stop()
        ns2.stop()
    }
}
