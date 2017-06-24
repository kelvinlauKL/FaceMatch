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
  @IBOutlet fileprivate var emotionViewLeft: UIImageView!
  @IBOutlet fileprivate var emotionViewCenter: UIImageView!
  @IBOutlet fileprivate var emotionViewRight: UIImageView!
  
  @IBOutlet fileprivate var bottomConstraintLeft: NSLayoutConstraint!
  @IBOutlet fileprivate var bottomConstraintCenter: NSLayoutConstraint!
  @IBOutlet fileprivate var bottomConstraintRight: NSLayoutConstraint!
  
  @IBOutlet fileprivate var finishLineView: UIView!
  
  // constraint constants
  fileprivate let finishConstant: CGFloat = -50
  fileprivate let startConstant: CGFloat = 800
  
  @IBOutlet fileprivate var previewView: PreviewView! {
    didSet {
      previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      previewView.clipsToBounds = true
    }
  }
  
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
    
    let frontCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
    guard let input = try? AVCaptureDeviceInput(device: frontCamera) else { fatalError("back camera not available.") }
    session.addInput(input)
    session.addOutput(output)
    previewView.session = session
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    session.startRunning()
    move(view: emotionViewLeft, from: CGPoint(x: 1000, y: 1000), to: finishLineView.center)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session.stopRunning()
  }
  
  func moveToFinish(_ constraint: NSLayoutConstraint, completion: @escaping () -> ()) {
    UIView.animate(withDuration: 10, animations: {
      constraint.constant = self.finishConstant
      self.view.layoutIfNeeded()
    }, completion: { _ in
      constraint.constant = self.startConstant
      completion()
    })
  }
  
  func move(view: UIView, from startPoint: CGPoint, to endPoint: CGPoint) {
    let move = CABasicAnimation(keyPath: "position")
    move.fromValue = [startPoint.x, startPoint.y]
    move.toValue = [endPoint.x, endPoint.y]
    move.duration = 2
    view.layer.add(move, forKey: nil)
  }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension GameViewController: AVCapturePhotoCaptureDelegate {
  func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    
    guard let sampleBuffer = photoSampleBuffer else { fatalError("sample buffer was nil") }
    
    guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil) else { fatalError("could not get image data from sample buffer.") }

    // TODO: - imageData
  }
}
