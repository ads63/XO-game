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
    public var playMode: PlayMode?
    private var inputStates: [Player: InputState] = [:]
    private lazy var referee = Referee(gameboard: self.gameboard)
    private let gameboard = Gameboard()
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

    private func setHumanHumanStates() {
        inputStates[Player.first] = PlayerInputState(player: .first,
                                                     markViewPrototype: Player.first.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
        inputStates[Player.second] = PlayerInputState(player: .second,
                                                      markViewPrototype: Player.second.markViewPrototype,
                                                      gameViewController: self,
                                                      gameboard: gameboard,
                                                      gameboardView: gameboardView)
    }

    private func setHumanComputerStates() {
        inputStates[Player.first] = PlayerInputState(player: .first,
                                                     markViewPrototype: Player.first.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
        inputStates[Player.second] = ComputerInputState(player: .second,
                                                        markViewPrototype: Player.second.markViewPrototype,
                                                        gameViewController: self,
                                                        gameboard: gameboard,
                                                        gameboardView: gameboardView)
    }

    private func setInputStates() {
        if playMode == .computer {
            setHumanComputerStates()
        } else {
            setHumanHumanStates()
        }
    }

    private func startNewGame() {
        gameboardView.clear()
        gameboard.clear()
        goToFirstState()
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }

    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner, gameViewController: self)
            return
        }
        if let currentInputState = currentState as? InputState {
            currentState = inputStates[currentInputState.player.next]
            currentState.isCompleted = false
            if currentState is ComputerInputState {
                gameboardView.onSelectPosition = nil
                currentState.addMark(at: nil)
                if currentState.isCompleted {
                    goToNextState()
                }
            } else {
                gameboardView.onSelectPosition = { [weak self] position in
                    guard let self = self else { return }
                    self.currentState.addMark(at: position)
                    if self.currentState.isCompleted {
                        self.goToNextState()
                    }
                }
            }
        }
    }

    private func goToFirstState() {
        currentState = inputStates[.first]
        currentState.isCompleted = false
    }
}
