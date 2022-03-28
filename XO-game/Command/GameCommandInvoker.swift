//
//  GameStepInvoker.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 25.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

final class GameCommandInvoker {
    private let delayMilliSeconds = 200
    private var batchSize: Int
    private let receiver = GameCommandReceiver()
    private var commands: [GameCommand] = []

    init(batchSize: Int = 5) {
        self.batchSize = batchSize
    }

    internal func addGameCommand(command: GameCommand) {
        let playerCommands = commands.filter { $0.player == command.player }
        let playerPositions = playerCommands.map { $0.position }
        if playerCommands.count < batchSize,
           !playerPositions.contains(command.position) { commands.append(command) }
    }

    public func isBatchFilled(player: Player) -> Bool {
        commands.filter { $0.player == player }.count >= batchSize
    }

    public func clear() {
        commands.removeAll()
    }

    public func executeCommands(completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        commands.enumerated().forEach {
            self.receiver.execute(command: $0.element,
                                  deadline: $0.offset * delayMilliSeconds,
                                  dispatchGroup: group)
        }
        group.notify(queue: .main) {
            completion(true)
        }
    }
}
