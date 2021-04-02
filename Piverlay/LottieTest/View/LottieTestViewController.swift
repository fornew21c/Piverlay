//
//  LottieTestViewController.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/04/02.
//

import UIKit
import Lottie

class LottieTestViewController: UIViewController {
    let animationView = AnimationView()
    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let animation = Animation.named("LottieLogo1", subdirectory: "TestAnimations")

        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)

        slider.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        view.addSubview(slider)
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        animationView.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -12).isActive = true
        animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)

        /// *** Keypath Setting

        let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
        animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Switch Outline Outlines.**.Fill 1.Color"))
        animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Checkmark Outlines 2.**.Stroke 1.Color"))

        /// Slider
        slider.heightAnchor.constraint(equalToConstant: 40).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        slider.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -12).isActive = true
        slider.addTarget(self, action: #selector(updateAnimation(sender:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderFinished), for: .touchUpInside)

        /// Play Animation

        /// Create a display link to make slider track with animation progress.
        displayLink = CADisplayLink(target: self, selector: #selector(animationCallback))
        displayLink?.add(to: .current,
                        forMode: RunLoop.Mode.default)

        
    }

    var displayLink: CADisplayLink?
    
    @objc func updateAnimation(sender: UISlider) {
      animationView.currentProgress = CGFloat(sender.value)
    }
    
    @objc func sliderFinished() {
  //    animationView.play(fromProgress: 0,
  //                       toProgress: 1,
  //                       loopMode: LottieLoopMode.playOnce,
  //                       completion: { (finished) in
  //                        if finished {
  //                          print("Animation Complete")
  //                        } else {
  //                          print("Animation cancelled")
  //                        }
  //    })
    }
    
    @objc func animationCallback() {
      if animationView.isAnimationPlaying {
        slider.value = Float(animationView.realtimeAnimationProgress)
      }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      animationView.play(fromProgress: 0,
                         toProgress: 1,
                         loopMode: LottieLoopMode.playOnce,
                         completion: { (finished) in
                          if finished {
                            print("Animation Complete")
                          } else {
                            print("Animation cancelled")
                          }
      })
      
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      
      // Dispose of any resources that can be recreated.
    }

}
