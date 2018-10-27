//
//  ViewController.swift
//  GBPing
//
//  Created by 黄伯驹 on 2017/9/12.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var service: PingServicer!
    let ipAddresses: Set<String> = [
        "139.196.17.187",
        "115.29.38.186",
        "121.43.173.34",
        "120.76.75.233",
        "47.92.80.116",
        "175.6.7.128",
        "121.196.220.124",
        "211.147.74.226",
        "106.15.42.79",
        "14.215.177.39",
        "14.215.177.38",
        "47.95.49.160",
        "45.113.192.0",
        "45.113.192.1",
        "45.113.192.2",
        "45.113.192.3",
        "45.113.192.4",
        "45.113.192.5",
        "45.113.192.6",
        "45.113.192.7",
        "45.113.192.8",
        "45.113.192.9",
        "45.113.192.11",
        "45.113.192.12",
        "45.113.192.13",
        "45.113.192.14",
        "45.113.192.15",
        "45.113.192.16",
        "45.113.192.17",
        "45.113.192.18",
        "45.113.192.19",
        "45.113.192.20",
        "45.113.192.21",
        "45.113.192.24",
        "45.113.192.25",
        "45.113.192.26",
        "45.113.192.27",
        "45.113.192.28",
        "45.113.192.29",
        "45.113.192.32",
        "45.113.192.33",
        "45.113.192.99",
        "45.113.192.98",
        "45.113.192.97",
        "45.113.192.100",
        "45.113.192.101",
        "45.113.192.102",
        "45.113.192.103",
        "45.113.192.104",
        "45.113.192.105",
        "45.113.192.106",
        "45.113.192.107",
        "45.113.192.108",
        "45.113.192.109",
        "45.113.192.110",
    ]
    
    var result: [PingResult] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "start", style: .plain, target: self, action: #selector(nextAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAction))
        
        let button = UIButton(frame: CGRect(x: 0, y: view.frame.height - 45, width: view.frame.width, height: 45))
        button.setTitle("平均耗时", for: .normal)
        button.addTarget(self, action: #selector(averageConsumeAction), for: .touchUpInside)

        button.backgroundColor = UIColor(red: 30 / 255, green: 144 / 255, blue: 1, alpha: 1)
        UIApplication.shared.keyWindow?.addSubview(button)
    }

    func averageConsumeAction() {
        let v = result.reduce(0) { $0.0 + $0.1.consumimg }
        let alert = UIAlertController(title: nil, message: "\(v / Double(result.count))", preferredStyle: .alert)
        let action = UIAlertAction(title: "好", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func clearAction() {
        let indexPathes = result.enumerated().map { IndexPath(item: $0.offset, section: 0) }
        result.removeAll(keepingCapacity: true)

        tableView.deleteRows(at: indexPathes, with: .none)
    }

    func nextAction() {
        let url = URL(string: "http://localhost:8080/bird")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "bird=daka&pwd=123".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("")
        }
        task.resume()

        service = PingServicer(ipAddresses: ipAddresses, maxTimes: 200, maxConcurrentCount: 24)
        service.start() { [weak self] in
            self?.navigationItem.title = $0.ipAddress
            self?.navigationItem.prompt = $0.minAverage.description
            self?.result.insert($0, at: 0)
            self?.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .bottom)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        (cell as? CustomCell)?.item = result[indexPath.row]
        (cell as? CustomCell)?.indexLabel.text = (result.count - indexPath.row).description
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
