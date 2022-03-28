//
//  GameCommandReceiver.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 25.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

final class GameCommandReceiver {
    public func execute(command: GameCommand?, deadline: Int,
                        dispatchGroup: DispatchGroup)
    {
        dispatchGroup.enter()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(deadline)) {
            command?.execute()
            dispatchGroup.leave()
        }
    }
}
