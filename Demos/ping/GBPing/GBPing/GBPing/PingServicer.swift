//
//  PingServicer.swift
//  GBPing
//
//  Created by 黄伯驹 on 2017/9/12.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

struct PingResult {
    let ipAddress: String
    let minAverage: TimeInterval
    let consumimg: CFAbsoluteTime
}

class PingServicer: NSObject {

    fileprivate let ipAddresses: Set<String>
    fileprivate let maxTimes: Double
    private let maxConcurrentCount: Int

    fileprivate var summaryDict: [String: Set<GBPingSummary>] = [:]
    fileprivate var averageDict: [String: Double] = [:]
    fileprivate var pingerDict: [String: GBPing] = [:]
    
    fileprivate var isHandled = false

    init(ipAddresses: Set<String>, maxTimes: Int = 5, maxConcurrentCount: Int = 5) {
        self.maxTimes = Double(maxTimes) * 1
        self.maxConcurrentCount = maxConcurrentCount
        self.ipAddresses = ipAddresses
        semaphoreLock = DispatchSemaphore(value: maxConcurrentCount)
        super.init()
    }

    fileprivate var startTime: Double = 0
    fileprivate var completionHandle: ((_ result: PingResult) -> Void)!
    fileprivate var semaphoreLock: DispatchSemaphore!
    
    fileprivate let lock = NSLock()

    private func rest() {
        isHandled = false
        startTime = CFAbsoluteTimeGetCurrent()
        pingerDict.forEach { $0.value.stop() }
        pingerDict.removeAll(keepingCapacity: true)
        averageDict.removeAll(keepingCapacity: true)
        summaryDict.removeAll(keepingCapacity: true)
    }

    func start(completionHandle: @escaping (_ result: PingResult) -> Void) {
        rest()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentCount

        for ipAddress in ipAddresses {
            queue.addOperation {
                let ping = GBPing()
                ping.semaphore = DispatchSemaphore(value: 0)
                ping.delegate = self
                ping.debug = true
                //                ping.pingPeriod = 0.1
                ping.payloadSize = 512
                self.lock.lock()
                self.pingerDict[ipAddress] = ping
                self.lock.unlock()
                ping.setup(withIPAddress: ipAddress) { (success, error) in
                    if (success) {
                        ping.startPinging()
                    } else {
                        let summary = GBPingSummary()
                        summary.status = GBPingStatusFail
                        summary.host = ipAddress
                        self.handlSummary(with: summary)
                    }
                }
                _ = ping.semaphore?.wait(timeout: .distantFuture)
            }
        }
        self.completionHandle = completionHandle
    }
}

extension PingServicer: GBPingDelegate {

    func ping(_ pinger: GBPing, didReceiveReplyWith summary: GBPingSummary) {
        handlSummary(with: summary)
    }

    func ping(_ pinger: GBPing, didReceiveUnexpectedReplyWith summary: GBPingSummary) {
        summary.rtt = 1000
        handlSummary(with: summary)
    }

    func ping(_ pinger: GBPing, didFailToSendPingWith summary: GBPingSummary, error: Error) {
        summary.rtt = 1000
        handlSummary(with: summary)
        print(error)
    }

    func ping(_ pinger: GBPing, didTimeoutWith summary: GBPingSummary) {
        summary.rtt = 1000
        handlSummary(with: summary)
    }

    func handlSummary(with summary: GBPingSummary) {
        let host = summary.host
        if host.isEmpty {
            return
        }
        print(summary)

        var summaries = summaryDict[host] ?? []
        if summaries.count == Int(maxTimes)  {

            pingerDict[host]?.stop()
            pingerDict[host]?.semaphore?.signal()

            if ipAddresses.count != pingerDict.count {
                return
            }

            for key in pingerDict.keys {
                if summaryDict[key]?.count != Int(maxTimes) {
                    return
                }
            }

            if isHandled {
                return
            }
            isHandled = true

            var minItem = ("超时", 1000.0)

            for (key, value) in averageDict {
                if value != 0 && value < minItem.1 && !key.isEmpty {
                    minItem = (key, value)
                }
            }
            let minValue = minItem.1
            let minAverage = minValue / Double(self.averageDict.values.count)

            let endTime = CFAbsoluteTimeGetCurrent()
            let result = PingResult(ipAddress: minItem.0, minAverage: minAverage, consumimg: endTime - startTime)
            
            completionHandle(result)
        } else {
            summaries.insert(summary)
            summaryDict[host] = summaries
            averageDict[host] = summaries.reduce(0) { $0.0 + $0.1.rtt }
        }
    }
}
