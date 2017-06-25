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
  enum Result {
    case hit(Emotion)
    case miss(Emotion)
  }
  
  @IBOutlet fileprivate var finishLineView: UIView!
  @IBOutlet fileprivate var scoreLabel: UILabel!
  @IBOutlet fileprivate var hitImageView: UIImageView!
  
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
  
  fileprivate var emotionsQueue = Queue<Emotion>()
  fileprivate var score = 0 {
    didSet {
      scoreLabel.text = "\(score)"
    }
  }
  
  fileprivate var maxSpawns = 10
  fileprivate var numberOfSpawns = 0
  
  fileprivate var correct = 0
  
  fileprivate var webservice: GameplayAPI!
  class func instantiate(service: GameplayAPI) -> GameViewController {
    let storyboard = UIStoryboard(name: "\(GameViewController.self)", bundle: nil)
    let vc = storyboard.instantiateInitialViewController() as! GameViewController
    vc.webservice = service
    return vc
  }
}

// MARK: - Life Cycle
extension GameViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCamera()
    
    resetGame()
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
    view.center = endPoint
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
    guard numberOfSpawns < maxSpawns else {
      let accuracy = Int((Double(correct) / Double(maxSpawns)) * 100)
      let highscoresVC = HighScoresViewController.instantiate(score: score, accuracy: accuracy, webservice: FakeWebservice(), onComplete: { [weak self] vc in
        self?.resetGame()
        vc.dismiss(animated: true, completion: nil)
      })
      
      timer?.invalidate()
      timer = nil
      return present(highscoresVC, animated: true, completion: nil)
    }
    numberOfSpawns += 1
    let emotion = Emotion.random
    let imageView = UIImageView(image: emotion.image)
    emotionsQueue.enqueue(emotion)
    view.addSubview(imageView)
    
    let randomDuration = TimeInterval(arc4random_uniform(2) + 1)
    let randomX = CGFloat(arc4random_uniform(UInt32(view.bounds.width)))
    move(view: imageView, from: CGPoint(x: randomX, y: view.bounds.height), to: finishLineView.center, duration: randomDuration) { [weak self] view in
      self?.capturePhoto()
      self?.rotateAndScaleDown(view: view) { view in
        view.removeFromSuperview()
      }
    }
  }
  
  func resetGame() {
    score = 0
    correct = 0
    numberOfSpawns = 0
    
    timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnEmotion), userInfo: nil, repeats: true)
  }
  
  func rotateAndScaleDown(view: UIView, completion: @escaping (UIView) -> ()) {
    
    
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      completion(view)
    }
    
    let groupAnimation = CAAnimationGroup()
    groupAnimation.beginTime = CACurrentMediaTime() + 0.5
    groupAnimation.duration = 0.5
    groupAnimation.fillMode = kCAFillModeBackwards

    let scale = CABasicAnimation(keyPath: "transform.scale")
    scale.fromValue = 1
    scale.toValue = 0
    scale.duration = 1
    
    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = Double.pi / 4.0
    rotate.toValue = 0.0
    rotate.duration = 1
    
    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 1
    fade.toValue = 0
    
    groupAnimation.animations = [scale, rotate, fade]
    view.layer.add(groupAnimation, forKey: nil)
    CATransaction.commit()
  }
  
  private func capturePhoto() {
    let captureSettings = AVCapturePhotoSettings()
    output.capturePhoto(with: captureSettings, delegate: self)
  }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension GameViewController: AVCapturePhotoCaptureDelegate {
  func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    guard let sampleBuffer = photoSampleBuffer else { return }
    let imageData = UIImage.data(from: sampleBuffer, imageSize: CGSize(width: 400, height: 400))
    
    webservice.send(imageData: imageData) { result in
      switch result {
      case .success(let (emotion, score)):
        guard let emotionMatch = self.emotionsQueue.dequeue() else { return }
        if emotionMatch == emotion {
          self.hitImageView.alpha = 1
          UIView.animate(withDuration: 1.0, animations: {
            self.hitImageView.alpha = 0
          })
          self.correct += 1
        } else {
          print("wrong matcH")
          self.hitImageView.alpha = 0
        }
        self.score += score
      case .failure: self.hitImageView.alpha = 0
      }
    }
  }
}
