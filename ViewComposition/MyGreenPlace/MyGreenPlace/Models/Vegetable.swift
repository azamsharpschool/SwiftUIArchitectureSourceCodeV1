//
//  Vegetable.swift
//  MyGreenPlace
//
//  Created by Mohammad Azam on 1/23/26.
//

import Foundation

struct Vegetable: Identifiable, Codable {
    let id: Int
    let vegetableCode: String
    let catalogId: Int
    let name: String
    let description: String
    let thumbnailImage: URL
    let seedDepth: String
    let germinationSoilTemp: String
    let daysToGermination: Int
    let sowIndoors: String
    let sowOutdoors: String
    let phRange: String
    let growingSoilTemp: String
    let spacingBeds: String
    let watering: String
    let light: String
    let goodCompanions: String
    let badCompanions: String
    let sowingDescription: String
    let growingDescription: String
    let harvestDescription: String
    let active: Bool?
    let season: String
    let daysToHarvestSeeds: Int
    let daysToHarvestSeedlings: Int
    let healthBenefits: String
   
    enum CodingKeys: String, CodingKey {
        case id = "VegetableId"
        case vegetableCode = "VegetableCode"
        case catalogId = "CatalogId"
        case name = "Name"
        case description = "Description"
        case thumbnailImage = "ThumbnailImage"
        case seedDepth = "SeedDepth"
        case germinationSoilTemp = "GerminationSoilTemp"
        case daysToGermination = "DaysToGermination"
        case sowIndoors = "SowIndoors"
        case sowOutdoors = "SowOutdoors"
        case phRange = "PhRange"
        case growingSoilTemp = "GrowingSoilTemp"
        case spacingBeds = "SpacingBeds"
        case watering = "Watering"
        case light = "Light"
        case goodCompanions = "GoodCompanions"
        case badCompanions = "BadCompanions"
        case sowingDescription = "SowingDescription"
        case growingDescription = "GrowingDescription"
        case harvestDescription = "HarvestDescription"
        case active = "Active"
        case season = "Season"
        case daysToHarvestSeeds = "DaysToHarvestSeeds"
        case daysToHarvestSeedlings = "DaysToHarvestSeedlings"
        case healthBenefits = "HealthBenefits"
      
    }
}


