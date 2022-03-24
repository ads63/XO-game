//
//  InputState.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

protocol InputState: GameState {
    var player: Player { get }
}
