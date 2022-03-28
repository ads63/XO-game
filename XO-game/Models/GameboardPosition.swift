//
//  GameBoardPosition.swift
//  XO-game
//
//  Created by Evgeny Kireev on 26/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

public struct GameboardPosition: Hashable, Equatable {
    public let column: Int
    public let row: Int

    public static func == (lhs: GameboardPosition, rhs: GameboardPosition) -> Bool {
        lhs.column == rhs.column && lhs.row == rhs.row
    }
}
