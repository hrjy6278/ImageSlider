//
//  ViewController.swift
//  ImageSlider
//
//  Created by 김재윤 on 2023/06/05.
//

import UIKit

final class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    private var images = [
        UIImage(systemName: "cross.case.circle")!,
        UIImage(systemName: "handbag.fill")!,
        UIImage(systemName: "house.lodge")!,
        UIImage(systemName: "windshield.rear.and.spray")!,
    ]
    private var currentIndex = 0
    private var nextIndex = 0
    private var nextImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
    }
    
    private func configureImageView() {
        self.imageView.image = images.first
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.black.cgColor
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let percentX = translation.x / view.bounds.width
        
        switch gesture.state {
        case .began:
            imageView.alpha = 1.0
            
            nextIndex = (currentIndex + 1) % images.count
            let nextImage = images[nextIndex]
            
            // 다음 이미지를 보여줄 이미지 뷰 생성 및 초기 설정
            nextImageView = UIImageView(frame: imageView.frame)
            nextImageView?.contentMode = .scaleAspectFit
            nextImageView?.image = nextImage
            nextImageView?.alpha = 0.0
            
            // 다음 이미지 뷰를 현재 이미지 뷰 위에 추가
            if let nextImageView = nextImageView {
                view.addSubview(nextImageView)
            }
            
        case .changed:
            let nextImageAlpha = abs(percentX)
            
            // 알파 값 적용
            imageView.alpha = 1.0 - abs(percentX)
            nextImageView.alpha = nextImageAlpha
            
        case .ended, .cancelled, .failed:
            if abs(percentX) >= 0.35 {
                // 이미지 전환
                if percentX > 0 {
                    transitionToPreviousImage()
                } else {
                    transitionToNextImage()
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.imageView.alpha = 1.0
                    self.nextImageView?.alpha = 0.0
                } completion: { _ in
                    self.nextImageView?.removeFromSuperview()
                    self.nextImageView = nil
                }
            }
            
        default:
            break
        }
      }
    
    func transitionToNextImage() {
        currentIndex = (currentIndex + 1) % images.count
        self.imageView.alpha = 1.0
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.images[self.currentIndex]
            self.imageView.layoutIfNeeded()
        }, completion: { _ in
            self.nextImageView.removeFromSuperview()
        })
        
    }
    
    func transitionToPreviousImage() {
        currentIndex = nextIndex
        
        self.imageView.alpha = 1.0
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.images[self.currentIndex]
            self.imageView.layoutIfNeeded()
        }, completion: { _ in
            self.nextImageView?.removeFromSuperview()
        })
    }
}
