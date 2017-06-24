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
  @IBOutlet fileprivate var finishLineView: UIView!
  
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
  fileprivate var timer: Timer?
  
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
    timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnEmotion), userInfo: nil, repeats: true)
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
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session.stopRunning()
    timer?.invalidate()
    timer = nil
  }
  
  
  func move(view: UIView, from startPoint: CGPoint, to endPoint: CGPoint, duration: TimeInterval, completion: @escaping (UIView) -> ()) {
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion(view)
    }
    let move = CABasicAnimation(keyPath: "position")
    move.fromValue = [startPoint.x, startPoint.y]
    move.toValue = [endPoint.x, endPoint.y]
    move.duration = duration
    view.layer.add(move, forKey: nil)
    CATransaction.commit()
  }
  
  func spawnEmotion() {
    let imageView = UIImageView(image: Emotion.random.image)
    view.addSubview(imageView)
    
    let randomDuration = TimeInterval(arc4random_uniform(2) + 1)
    let randomX = CGFloat(arc4random_uniform(UInt32(view.bounds.width)))
    move(view: imageView, from: CGPoint(x: randomX, y: view.bounds.height), to: finishLineView.center, duration: randomDuration) { [weak self] view in
      view.removeFromSuperview()
      self?.capturePhoto()
    }
  }
  
  private func capturePhoto() {
    let captureSettings = AVCapturePhotoSettings()
    output.capturePhoto(with: captureSettings, delegate: self)
  }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension GameViewController: AVCapturePhotoCaptureDelegate {
  func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    print("capturing")
    guard let sampleBuffer = photoSampleBuffer else { fatalError("sample buffer was nil") }
    
    guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil) else { fatalError("could not get image data from sample buffer.") }

    guard let image = UIImage(data: imageData) else { fatalError() }
    let resizedImage = UIImage.resizedImage(image: image, targetSize: CGSize(width: 400, height: 400))
    guard let resizedImageData = UIImageJPEGRepresentation(resizedImage, 0.5) else { fatalError() }
    Webservice.send(imageData: resizedImageData) { result in
      switch result {
      case .success: break
      case .failure: break
      }
    }
  }
}
