//
//  Player.swift
//  SwiftLab2
//
//  Created by SHREDDING on 24.06.2023.
//

import Foundation

public enum Weapon:Int{
    case ak47 = 50
    case pistol = 30
    case katana = 20
    case knife = 10
    case knuckles = 5
    
    public init?(index: Int) {
        switch index{
        case 0: self = .ak47
        case 1: self = .pistol
        case 2: self = .katana
        case 3: self = .knife
        case 4: self = .knuckles
        default:
            self = .ak47
        }
    }
}

public enum PlayerStatus{
    case live
    case die
}

public class Player{
    let name:String
    var health:Int
    let weapon:Weapon
    var playerStatus:PlayerStatus = .live
    
    init(name:String, health:Int,weapon:Weapon){
        self.name = name
        self.health = health
        self.weapon = weapon
    }
}

public class Team:Equatable{
    
    public let teamName:String
    public let players:[Player]
    
    init(teamNumber:Int, players:[Player]){
        self.teamName = "Team \(teamNumber)"
        self.players = players
    }
    
    public static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.teamName == rhs.teamName
    }
    
}


public class Game{
    var leftSideTeams:[Team] = []
    var rightSideTeams:[Team] = []
    
    var roundNumber = 1
    
    let numberOfTeams:Int = Int(truncating: NSDecimalNumber(decimal: pow(2, Int.random(in: 1...6))))
    
    
    init(){
        
    }
    
    public func generateTeams(){
        
        for team in 1...numberOfTeams{
            
            var players:[Player] = []
            
            for _ in 0..<4{
                let newPlayer = Player(name: PossibleValues.names.randomElement()!, health: Int.random(in: 10...100), weapon: Weapon(index: Int.random(in: 0...4))!)
                players.append(newPlayer)
            }
            
            let newTeam = Team(teamNumber: team, players: players)
            
            team % 2 == 0 ? leftSideTeams.append(newTeam) : rightSideTeams.append(newTeam)
        }
    }
    
    public func play(){
        while leftSideTeams.count != 0 && rightSideTeams.count != 0{
            round()
            roundNumber += 1
        }
        
        if leftSideTeams.count > 0{
            print("\nLeft side teams won")
            for i in leftSideTeams{
                print(i.teamName)
            }
        }else{
            print("\nRight side teams won")
            for i in rightSideTeams{
                print(i.teamName)
            }
        }
    }
    
    public func round(){
        print("round №\(roundNumber)\n")
        let firstTeam = Int.random(in: 0..<leftSideTeams.count)
        let secondTeam = Int.random(in: 0..<rightSideTeams.count)
        print("\(self.leftSideTeams[firstTeam].teamName) vs \(self.rightSideTeams[secondTeam].teamName)\n")
        
        while isTeamLive(team: self.leftSideTeams[firstTeam]) && isTeamLive(team: self.rightSideTeams[secondTeam]){
            let attack = Int.random(in: 0...1)
            Thread.sleep(forTimeInterval: 2)
            print("\tAttack \(attack == 0 ? self.leftSideTeams[firstTeam].teamName : self.rightSideTeams[secondTeam].teamName)\n")
            self.attack(attackTeam: attack == 0 ? self.leftSideTeams[firstTeam] : self.rightSideTeams[secondTeam] , secondTeam: attack == 1 ? self.leftSideTeams[firstTeam] : self.rightSideTeams[secondTeam])
        }
        
        if isTeamLive(team: self.leftSideTeams[firstTeam]){
            print("The \(self.leftSideTeams[firstTeam].teamName) won!\n\n")
            rightSideTeams.remove(at: secondTeam)
        }else{
            print("The \(self.rightSideTeams[secondTeam].teamName) won!\n\n")
            leftSideTeams.remove(at: firstTeam)
        }
        
        Thread.sleep(forTimeInterval: 3)
    }
    
    
    public func attack(attackTeam:Team, secondTeam:Team){
        for player in attackTeam.players{
            let attackedPlayer = Int.random(in: 0..<secondTeam.players.count)
            
            if secondTeam.players[attackedPlayer].health > 0{
                print("\t\(player.name) damaged \(secondTeam.players[attackedPlayer].name) on \(player.weapon.rawValue) health points")
                secondTeam.players[attackedPlayer].health -= player.weapon.rawValue
                print("\t\(secondTeam.players[attackedPlayer].name) has \(secondTeam.players[attackedPlayer].health) health points\n")
                
                if secondTeam.players[attackedPlayer].health <= 0{
                    print("\t\(secondTeam.players[attackedPlayer].name) die!\n")
                    secondTeam.players[attackedPlayer].playerStatus = .die
                }
                
            } else{
                print("\t\(player.name) missed\n")
            }
            
            
            
            Thread.sleep(forTimeInterval: 0.5)
        }
    }
    
    public func isTeamLive(team:Team)->Bool{
        for player in team.players{
            if player.playerStatus == .live{
                return true
            }
        }
        return false
    }
}
