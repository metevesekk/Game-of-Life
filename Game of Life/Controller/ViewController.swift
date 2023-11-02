//
//  ViewController.swift
//  Game of Life
//
//  Created by Mete Vesek on 1.11.2023.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameOfLifeGrid = Grid()
  //    gameOfLifeGrid.layer.borderColor = CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
  //    gameOfLifeGrid.layer.borderWidth = 3
        
       
        
        gameOfLifeGrid.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameOfLifeGrid)
        
        gameOfLifeGrid.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameOfLifeGrid.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        gameOfLifeGrid.widthAnchor.constraint(equalToConstant: 390).isActive = true
        gameOfLifeGrid.heightAnchor.constraint(equalToConstant: 435).isActive = true
            
       
    }

}




/*     NSLayoutConstraint.activate([
       gameOfLifeGrid.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
       gameOfLifeGrid.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
       gameOfLifeGrid.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
       gameOfLifeGrid.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
       gameOfLifeGrid.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
       gameOfLifeGrid.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
   ])  */
