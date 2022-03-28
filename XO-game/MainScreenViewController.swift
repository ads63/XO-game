//
//  MainScreenViewController.swift
//  XO-game
//
//  Created by Алексей Шинкарев on 24.03.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

enum PlayMode { case human, computer }

class MainScreenViewController: UIViewController {
    var playMode: PlayMode?
    @IBAction func onPlayAgainstHuman(_ sender: UIButton) {
        playMode = .human
    }

    @IBAction func onPlayAgainstComputer(_ sender: UIButton) {
        playMode = .computer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameViewController = segue.destination
            as? GameViewController else { return }
        gameViewController.playMode = playMode
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
