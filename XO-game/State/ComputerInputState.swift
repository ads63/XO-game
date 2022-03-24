//
//  ComputerInputState.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

public class ComputerInputState: InputState {
    public let markViewPrototype: MarkView
    public var isCompleted = false
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?

    init(player: Player, markViewPrototype: MarkView,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView)
    {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }

    public func begin() { switch self.player { case .first:
        self.gameViewController?.firstPlayerTurnLabel.isHidden = false
        self.gameViewController?.secondPlayerTurnLabel.isHidden = true case .second:
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = false }
    self.gameViewController?.winnerLabel.isHidden = true
    }

    public func addMark(at position: GameboardPosition?) {
        guard let position = self.calcPosition() else {
            return
        }
        guard let gameboardView = self.gameboardView,
              gameboardView.canPlaceMarkView(at: position) else { return }
        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(self.markViewPrototype.copy(),
                                          at: position)
        self.isCompleted = true
    }

    private func calcPosition() -> GameboardPosition? {
        if let emptyPositions = gameboard?.getPositions()
            .map({ $0.enumerated()
                    .filter { $0.element == nil }
                    .map { $0.offset }
            }),
            let column = emptyPositions
            .enumerated()
            .filter({ !$0.element.isEmpty })
            .map({ $0.offset })
            .randomElement(),
            let row = emptyPositions[column].randomElement()
        {
            return GameboardPosition(column: column, row: row)
        }

        return nil
    }
}
