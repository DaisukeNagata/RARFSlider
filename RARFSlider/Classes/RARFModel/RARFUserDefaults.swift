//
//  RARFUserDefaults.swift
//  Nimble
//
//  Created by 永田大祐 on 2019/04/10.
//

import Foundation

final class RARFUserDefaults {

    var defo = UserDefaults.standard


    func saveMethod(url: URL? = nil) {
        guard defo.object(forKey: "pathFileNameOne") == nil else {
            defo.set(url, forKey: "pathFileNameSecound")
            return
        }
        defo.set(url, forKey: "pathFileNameOne")
    }

    func loadMethod(st: String) -> URL! {
        guard defo.object(forKey:st) != nil else { return nil }
        return defo.url(forKey: st)!
    }

    func removeMethod(st: String) {  defo.removeObject(forKey: st) }
}
