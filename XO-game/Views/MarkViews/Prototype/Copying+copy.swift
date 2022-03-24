//
//  Copying+copy.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 23.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import Foundation

extension Copying {
    func copy() -> Self {
        return type(of: self).init(self)
    }
}
