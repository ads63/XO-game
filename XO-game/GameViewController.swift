//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    private var inputStates: [Player: InputState] = [:]
    private lazy var referee = Referee(gameboard: self.gameboard)
    private let gameboard = Gameboard()
    private let gameCommandInvoker = GameCommandInvoker()
    private var currentState: GameState! {
        didSet { self.currentState.begin()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setInputStates()
        startNewGame()
    }

    @IBAction func restartButtonTapped(_ sender: UIButton) {
        startNewGame()
    }

    private func setInputStates() {
        inputStates[Player.first] = PlayerInputState(player: .first,
                                                     markViewPrototype: Player.first.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView,
                                                     gameCommandInvoker: gameCommandInvoker)
        inputStates[Player.second] = PlayerInputState(player: .second,
                                                      markViewPrototype: Player.second.markViewPrototype,
                                                      gameViewController: self,
                                                      gameboard: gameboard,
                                                      gameboardView: gameboardView,
                                                      gameCommandInvoker: gameCommandInvoker)
    }

    private func startNewGame() {
        gameCommandInvoker.clear()
        gameboardView.clear()
        gameboard.clear()
        goToFirstState()
    }

    private func goToNextState() {
        if let currentInputState = currentState as? InputState {
            switch currentInputState.player {
            case .first:
                currentState = inputStates[currentInputState.player.next]
                currentState.isCompleted = false
                gameboardView.onSelectPosition = { [weak self] position in
                    guard let self = self else { return }
                    self.currentState.addMark(at: position)
                    if self.currentState.isCompleted {
                        self.goToNextState()
                    }
                }
            case .second:
                if currentState.isCompleted {
                    gameboardView.onSelectPosition = nil
                    let nextState = DisplayStepsState(gameViewController: self,
                                                      gameCommandInvoker: gameCommandInvoker)
                    nextState.onCommandsDisplayed = { [weak self] isDisplayed in
                        if isDisplayed {
                            let winner = self?.referee.determineWinner()
                            self?.currentState = GameEndedState(winner: winner, gameViewController: self)
                        }
                    }
                    currentState = nextState
                }
            }
        }
    }

    private func goToFirstState() {
        currentState = inputStates[.first]
        currentState.isCompleted = false
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
}
