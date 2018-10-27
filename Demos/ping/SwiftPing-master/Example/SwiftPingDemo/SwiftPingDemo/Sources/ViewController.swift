import UIKit
import SwiftPing

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.red
		verifyPing()
  }

	func verifyPing() {

		let config:PingConfiguration = PingConfiguration(interval: 1)

		SwiftPing.ping(host: "google.com",
		               configuration: config, queue: DispatchQueue.global()) { (ping, error) in
										print(ping)
										print(error)
                        
                        // start the ping.
                        ping?.observer = {(ping: SwiftPing, response: PingResponse) -> Void in
                            ping.stop()
                            ping.observer = nil
                            
                        }
                        ping?.start()
		}
        
        let url = URL(string: "http://localhost:8080/bird")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "bird=daka&pwd=123".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("🍀")
        }
        task.resume()

//        SwiftPing.pingOnce(host: "www.baidu.com",
//                           configuration: config,
//                           queue: DispatchQueue.main){ (response) in
//                            
//                            print(response)
//                            print(response.duration, "✈️")
//                            print(response.ipAddress, "🍀")
//                            print(response.error, "😆")
//                            print(response.identifier)
//        }
	}
}

