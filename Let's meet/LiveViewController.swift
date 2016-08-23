//
//  LiveViewController.swift
//  Lets meet
//
//  Created by Do Nguyen on 8/23/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import Foundation
import UIKit
import lf
import AVFoundation
import VideoToolbox
import FBSDKCoreKit

class LiveViewController: BaseViewController {
    var rtmpConnection: RTMPConnection = RTMPConnection()
    var rtmpStream: RTMPStream!
    var currentPosition:AVCaptureDevicePosition = AVCaptureDevicePosition.Back
    var streamIdentifier: String!
    @IBOutlet weak var recordButton: UIButton!
    //    let lfView:GLLFView! = GLLFView(frame: CGRectZero)
    let touchView: UIView! = UIView()
    var cameraBackPosition = true
    @IBOutlet weak var changeCameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        streamIdentifier = "1676614055996956?ds=1&a=AaZsWrMP-_EPBoKh"
        rtmpStream = RTMPStream(rtmpConnection: rtmpConnection)
        rtmpStream.captureSettings = [
            "fps": 30, // FPS
            "sessionPreset": AVCaptureSessionPresetMedium, // input video width/height
            "continuousAutofocus": false, // use camera autofocus mode
            "continuousExposure": false, //  use camera exposure mode
        ]
        rtmpStream.audioSettings = [
            "muted": false, // mute audio
            "bitrate": 32 * 1024,
        ]
        rtmpStream.videoSettings = [
            "width": 640, // video output width
            "height": 360, // video output height
            "bitrate": 160 * 1024, // video output bitrate
            // "dataRateLimits": [160 * 1024 / 8, 1], optional kVTCompressionPropertyKey_DataRateLimits property
            "profileLevel": kVTProfileLevel_H264_Baseline_5_2, // H264 Profile require "import VideoToolbox"
            "maxKeyFrameIntervalDuration": 2, // key frame / sec
        ]
        rtmpStream.view.videoGravity = AVLayerVideoGravityResizeAspectFill
        rtmpStream.attachAudio(AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio))
        rtmpStream.attachCamera(AVMixer.deviceWithPosition(.Back))
        view.addSubview(rtmpStream.view)
        view.bringSubviewToFront(recordButton)
        view.bringSubviewToFront(changeCameraButton)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        rtmpStream.view.frame = view.bounds
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RecordButtonTouched(sender: UIButton) {
        if (sender.selected) {
            UIApplication.sharedApplication().idleTimerDisabled = false
            rtmpConnection.close()
            
            sender.setTitle("●", forState: .Normal)
        } else {
            //            self.showError("Our app is asking Facebook permission for create live stream. Right now please create yourself. Thanks you :(")
            
            FBSDKGraphRequest(graphPath: "/\(FBSDKAccessToken.currentAccessToken().userID)/live_videos", parameters: ["published": "true"], HTTPMethod: "POST").startWithCompletionHandler({ (connection, result, error) in
                guard (error == nil) else {
                    return
                }
                
                let streamURL = result["stream_url"] as! String
                UIApplication.sharedApplication().idleTimerDisabled = true
                self.rtmpConnection.connect(RTMP_URL)
                self.streamIdentifier = streamURL.stringByReplacingOccurrencesOfString(RTMP_URL, withString: "")
                self.rtmpStream.publish(self.streamIdentifier)
                sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                sender.setTitle("■", forState: .Normal)
                sender.selected = !sender.selected
                
            })
            
        }
        
    }
    
    @IBAction func buttonChangeCameraTouched(sender: AnyObject) {
        cameraBackPosition = !cameraBackPosition
        if cameraBackPosition {
            rtmpStream.attachCamera(AVMixer.deviceWithPosition(.Back))
        } else {
            rtmpStream.attachCamera(AVMixer.deviceWithPosition(.Front))
            
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
