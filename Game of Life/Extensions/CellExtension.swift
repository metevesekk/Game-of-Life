//
//  CellExtension.swift
//  Game of Life
//
//  Created by Mete Vesek on 2.11.2023.
//

import Foundation
import UIKit

extension Cell {
    func copy(isAlive: Bool) -> Cell {
        return Cell(isAlive: isAlive, x: self.x, y: self.y)
    }
}
