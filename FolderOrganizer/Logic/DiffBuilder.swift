//
// Logic/DiffBuilder.swift
//
import Foundation

struct DiffBuilder {

    static func build(old: String, new: String) -> [DiffSegment] {
        var segments: [DiffSegment] = []

        let oldChars = Array(old)
        let newChars = Array(new)

        var i = 0
        var j = 0

        while j < newChars.count {
            if i < oldChars.count, oldChars[i] == newChars[j] {
                segments.append(.same(String(newChars[j])))
                i += 1
                j += 1
            } else {
                segments.append(.added(String(newChars[j])))
                j += 1
            }
        }

        return segments
    }
}
