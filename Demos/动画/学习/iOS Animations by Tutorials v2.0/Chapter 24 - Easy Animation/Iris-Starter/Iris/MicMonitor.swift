//
//  MicMonitor.swift
//  Siri
//
//  Created by Marin Todorov on 6/23/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import Foundation
import AVFoundation

class MicMonitor: NSObject {
    
    private var recorder: AVAudioRecorder!
    private var timer: NSTimer?
    private var levelsHandler: ((Float)->Void)?
    
    override init() {
        
        let url = NSURL(fileURLWithPath: "/dev/null", isDirectory: true)
        let settings: [String: AnyObject] = [
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        if audioSession.recordPermission() != .Granted {
            audioSession.requestRecordPermission({success in print("microphone permission: \(success)")})
        }
        
        do {
            try recorder = AVAudioRecorder(URL: url, settings: settings)
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            print("Couldn't initialize the mic input")
        }
        
        if let recorder = recorder {
            //start observing mic levels
            recorder.prepareToRecord()
            recorder.meteringEnabled = true
        }
    }
    
    func startMonitoringWithHandler(handler: (Float)->Void) {
        levelsHandler = handler
        
        //start meters
        timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: "handleMicLevel:", userInfo: nil, repeats: true)
        recorder.record()
    }
    
    func stopMonitoring() {
        levelsHandler = nil
        timer?.invalidate()
        recorder.stop()
    }
    
    func handleMicLevel(timer: NSTimer) {
        recorder.updateMeters()
        levelsHandler?(recorder.averagePowerForChannel(0))
    }
    
    deinit {
        stopMonitoring()
    }
    
}