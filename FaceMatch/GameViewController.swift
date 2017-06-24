//
//  GameViewController.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit
import AVFoundation

final class GameViewController: UIViewController {
  @IBOutlet fileprivate var previewView: PreviewView!
  
  fileprivate let session: AVCaptureSession = {
    let session = AVCaptureSession()
    session.sessionPreset = AVCaptureSessionPresetPhoto
    return session
  }()
  
  fileprivate let output = AVCapturePhotoOutput()
  
  class func instantiate() -> GameViewController {
    let storyboard = UIStoryboard(name: "\(GameViewController.self)", bundle: nil)
    return storyboard.instantiateInitialViewController() as! GameViewController
  }
}

// MARK: - Life Cycle
extension GameViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCamera()
  }
  
  private func setupCamera() {
    
    let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    guard let input = try? AVCaptureDeviceInput(device: backCamera) else { fatalError("back camera not available.") }
    session.addInput(input)
    session.addOutput(output)
    previewView.session = session
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    session.startRunning()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session.stopRunning()
  }
}
