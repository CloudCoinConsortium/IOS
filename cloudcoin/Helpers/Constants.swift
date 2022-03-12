//
//  Constants.swift
//  cloudcoin
//
//  Created by Moumita China on 01/11/21.
//

import Foundation

struct Constants{
    static let trailing: [UInt8] = [62, 62]
    
    static let hostArray = [
       "https://guardian0.chelgu.cz/host.txt",
       "https://raida-guardian-tx.us/host.txt",
       "https://g2.cloudcoin.asia/host.txt",
       "https://guardian.ladyjade.cc/host.txt",
       "https://watchdog.guardwatch.cc/host.txt",
       "https://g5.raida-guardian.us/host.txt",
       "https://goodguardian.xyz/host.txt",
       "https://g7.ga7.nl/host.txt",
       "https://raidaguardian.nz/host.txt",
       "https://g9.guardian9.net/host.txt",
       "https://g10.guardian25.com/host.txt",
       "https://g11.raidacash.com/host.txt",
       "https://g12.aeroflightcb300.com/host.txt",
       "https://g13.stomarket.co/host.txt",
       "https://guardian14.gsxcover.com/host.txt",
       "https://guardian.keilagd.cc/host.txt",
       "https://g16.guardianstl.us/host.txt",
       "https://raida-guardian.net/host.txt",
       "https://g18.raidaguardian.al/host.txt",
       "https://g19.paolobui.com/host.txt",
       "https://g20.cloudcoins.asia/host.txt",
       "https://guardian21.guardian.al/host.txt",
       "https://rg.encrypting.us/host.txt",
       "https://g23.cuvar.net/host.txt",
       "https://guardian24.rsxcover.com/host.txt",
       "https://g25.mattyd.click/host.txt",
       "https://g26.cloudcoinconsortium.art/host.txt"]
    
    static let maxCoins = 28
}

enum Commands: Int{
    case POWN = 0
    case Detect = 1
    case Find = 2
    case Fix = 3
    case Echo = 4
    case ValidateTicket = 5
    case Put = 6
    case MoveKey = 7
    case Identify = 8
    case RequestMove = 9
    case Recover = 10
    case GetTicket = 11
    case GetKey = 12
    case Version = 13
    
    func magicFunction() -> Int {
        return Int(self.rawValue)
    }
}
