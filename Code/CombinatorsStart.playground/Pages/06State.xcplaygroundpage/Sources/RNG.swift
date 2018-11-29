import Foundation

public let max = 6074

public let initialRNG = RNG(seed: 17)

public struct RNG {
    private let A = 107
    private let C = 1283
    private let M = 6073
    
    public let seed: Int
    
    public init(seed: Int) {
        self.seed = seed
    }
    
    public func nextInt() -> (Int, RNG) {
        let newSeed = (seed * A + C) % M
        let nextRNG = RNG(seed: newSeed)
        return (newSeed, nextRNG)
    }
}
