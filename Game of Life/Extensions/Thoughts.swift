/*    if aliveCells.contains(where: { cell in
 cell.x == Int((bounds.width/cellSize) - 1)
 }){
 newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
 neighbor.x == Int(bounds.width/cellSize) && neighbor.y == cell.y
 } , x: 0, y: cell.y))
 }
 
 if aliveCells.contains(where: { cell in
 cell.x == 0
 }){
 newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
 neighbor.x == -1 && neighbor.y == cell.y
 } , x: Int((bounds.width/cellSize) - 1), y: cell.y))
 }
 
 if aliveCells.contains(where: { cell in
 cell.y == Int((bounds.height/cellSize) - 1)
 }){
 newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
 neighbor.y == Int(bounds.height/cellSize) && neighbor.x == cell.x
 } , x: cell.x, y: 0))
 }
 
 if aliveCells.contains(where: { cell in
 cell.y == 0
 }){
 newAliveCells.insert(Cell(isAlive: cell.neighbors.contains { neighbor in
 neighbor.y == -1 && neighbor.x == cell.x
 } , x: cell.x, y: Int((bounds.height/cellSize) - 1)))
 } */
