//
//  GameCommand.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 25.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

final class GameCommand: Equatable {
    private let gameViewController: GameViewController?
    public let gameboard: Gameboard?
    public let gameboardView: GameboardView?
    public let player: Player
    public let position: GameboardPosition
    init(player: Player,
         position: GameboardPosition,
         gameViewController: GameViewController?,
         gameboard: Gameboard?,
         gameboardView: GameboardView?)
    {
        self.player = player
        self.position = position
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.gameViewController = gameViewController
    }

    static func == (lhs: GameCommand, rhs: GameCommand) -> Bool {
        lhs.player == rhs.player && lhs.position == rhs.position
    }

    public func execute() {
        self.gameViewController?.winnerLabel.isHidden = true
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        self.gameboard?.setPlayer(self.player, at: self.position)
        self.gameboardView?.removeMarkView(at: self.position)
        self.gameboardView?.placeMarkView(self.player.markViewPrototype,
                                          at: self.position)
    }
}
