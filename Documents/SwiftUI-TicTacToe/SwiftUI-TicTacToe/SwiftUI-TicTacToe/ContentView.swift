//  Created by Ernesto Diaz.
//

import SwiftUI

enum Player: String {
    case x = "X"
    case o = "O"
}

struct ContentView: View {
    @State private var currentPlayer: Player = .x
    @State private var cells: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @State private var winner: Player?
    @State private var isDraw: Bool = false
    @State private var winningCells: Set<[Int]> = []
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Tic Tac Toe")
                .font(.largeTitle)
                .padding(.vertical)
            
            Spacer()
            
            if winner == nil && isDraw == false{
                Text("Player \(currentPlayer.rawValue)'s turn")
                    .foregroundColor(currentPlayer == .x ? .red : .blue)
            }
            
            
            ForEach(0..<3) { row in
                HStack(spacing: 20) {
                    ForEach(0..<3) { column in
                        Button(action: {
                            if cells[row][column] == nil {
                                cells[row][column] = currentPlayer
                                currentPlayer = currentPlayer == .x ? .o : .x
                                checkWinner()
                            }
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(currectColor(row, column))
                                    .frame(width: 80, height: 80)
                                    .shadow(radius: 5)
                                Text(cells[row][column]?.rawValue ?? "")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                        })
                        .disabled(winner == nil ? false : true)
                        .scaleEffect(winningCells.contains([row, column]) ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.5))
                    }
                }
            }
            
            Spacer()
            
            if let winner = winner {
                Text("Player \(winner.rawValue) wins!")
                    .foregroundColor(.green)
                    .scaleEffect(2.0)
                    .animation(.linear(duration: 0.5))
                    .padding(.vertical)
            } else if isDraw {
                Text("It's a draw!")
                    .foregroundColor(.orange)
                    .scaleEffect(2.0)
                    .animation(.linear(duration: 0.5))
                    .padding(.vertical)
            }
            
            Spacer()
            
            Button("Reset Game", action: resetGame)
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
    
    func currectColor(_ row:Int,_ column:Int)->Color{
        if cells[row][column] == .x {
            return .red
        }else if cells[row][column] == .o {
            return .blue
        }
        return .gray
    }
    
    private func checkWinner() {
        // Check rows
        for row in 0..<3 {
            if let player = cells[row][0], cells[row][1] == player, cells[row][2] == player {
                winner = player
                winningCells = Set([[row, 0], [row, 1], [row, 2]])
                return
            }
        }
        
        // Check columns
        for column in 0..<3 {
            if let player = cells[0][column], cells[1][column] == player, cells[2][column] == player {
                winner = player
                winningCells = Set([[0, column], [1, column], [2, column]])
                return
            }
        }
        
        // Check diagonal
        if let player = cells[0][0], cells[1][1] == player, cells[2][2] == player {
            winner = player
            winningCells = Set([[0, 0], [1, 1], [2, 2]])
            return
        }
        
        if let player = cells[0][2], cells[1][1] == player, cells[2][0] == player {
            winner = player
            winningCells = Set([[0, 2], [1, 1], [2, 0]])
            return
        }
        
        // Check draw
        if !cells.flatMap({ $0 }).contains(nil) {
            isDraw = true
        }
    }
    
    private func resetGame() {
        currentPlayer = .x
        cells = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        winner = nil
        isDraw = false
        winningCells = Set()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
