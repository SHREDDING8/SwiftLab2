//
//  main.swift
//  SwiftLab2
//
//  Created by SHREDDING on 24.06.2023.
//

import Foundation

print("Hello! Today we are playing 'battle of the titans.'")
Thread.sleep(forTimeInterval: 1)
print("Creating Teams...")
Thread.sleep(forTimeInterval: 3)

let game = Game()
game.generateTeams()
print("Today we have \(game.numberOfTeams) teams\n")
game.play()

