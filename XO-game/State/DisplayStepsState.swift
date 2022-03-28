//
//  DisplayStepsState.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 27.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit
public class DisplayStepsState: GameState {
    public var onCommandsDisplayed: ((Bool) -> Void)?
    public var isCompleted = false
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameCommandInvoker: GameCommandInvoker?

    init(gameViewController: GameViewController,
         gameCommandInvoker: GameCommandInvoker)
    {
        self.gameCommandInvoker = gameCommandInvoker
        self.gameViewController = gameViewController
    }

    public func begin() {
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
        gameCommandInvoker?.executeCommands {
            [weak self] result in
            self?.isCompleted = result
            self?.onCommandsDisplayed?(result)
        }
    }

    public func addMark(at position: GameboardPosition?) {}
}
