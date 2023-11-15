//
//  Buttons.swift
//  Game of Life
//
//  Created by Mete Vesek on 15.11.2023.
//

import Foundation
import UIKit

class Buttons : UIButton {
    func setupButton(_ button: UIButton, title: String, selector: Selector, target: Any) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.75, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 3
     /* button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.6 */

        // Butona tıklanıldığında renginin koyulaşmasını sağlayacak fonksiyonları ekle
      //  button.addTarget(target, action: selector, for: .touchDown)
        button.addTarget(target, action: selector, for: [.touchUpInside, .touchUpOutside])
        button.addTarget(target, action: selector, for: .touchUpInside)
    }

    
    func disenableButton(_ button: UIButton){
        button.isEnabled = false
        button.backgroundColor = .systemGray
        button.alpha = 0.45
    }
    
    func enableButton(_ button: UIButton){
        button.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.75, alpha: 1.0)
        button.alpha = 1.0
        button.isEnabled = true
    }
    
    @objc func didTapButton(_ button: UIButton) {
        button.alpha = 0.7 // Koyulaşma efekti
    }

    @objc func didReleaseButton(_ button: UIButton) {
        button.alpha = 1.0 // Normal şeffaflık
    }
}
