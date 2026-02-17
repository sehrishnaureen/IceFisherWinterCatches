import Foundation
import SwiftUI

@Observable
final class TipsViewModel {
    var tips: [FishingTip] = []
    var selectedCategory: TipCategory?
    
    var filteredTips: [FishingTip] {
        guard let category = selectedCategory else { return tips }
        return tips.filter { $0.category == category }
    }
    
    init() {
        loadTips()
    }
    
    private func loadTips() {
        tips = [
            FishingTip(
                title: "Check Ice Thickness",
                description: "Always ensure ice is at least 4 inches thick for walking. Use an ice auger or chisel to test. Clear ice is stronger than cloudy ice.",
                category: .safety,
                icon: "ruler"
            ),
            FishingTip(
                title: "Never Fish Alone",
                description: "Always bring a fishing buddy. In case of emergency, having someone nearby can be lifesaving. Share your location with family.",
                category: .safety,
                icon: "person.2"
            ),
            FishingTip(
                title: "Carry Safety Picks",
                description: "Ice picks worn around your neck can help you pull yourself out if you fall through. They're essential ice fishing safety gear.",
                category: .safety,
                icon: "hand.raised"
            ),
            FishingTip(
                title: "Use Proper Auger",
                description: "A quality ice auger makes drilling holes much easier. Hand augers work for thin ice, power augers for thick ice.",
                category: .equipment,
                icon: "gearshape"
            ),
            FishingTip(
                title: "Get a Fish Finder",
                description: "Portable fish finders designed for ice fishing help locate fish under the ice, saving time and increasing catch rates.",
                category: .equipment,
                icon: "antenna.radiowaves.left.and.right"
            ),
            FishingTip(
                title: "Use a Shelter",
                description: "Ice fishing shelters protect from wind and cold. Pop-up shelters are portable and set up quickly.",
                category: .equipment,
                icon: "tent"
            ),
            FishingTip(
                title: "Jig Slowly",
                description: "In cold water, fish are less active. Use slow, subtle jigging motions to attract bites without scaring fish away.",
                category: .technique,
                icon: "arrow.up.arrow.down"
            ),
            FishingTip(
                title: "Try Different Depths",
                description: "Fish may be at different depths throughout the day. Start near bottom and work your way up until you find them.",
                category: .technique,
                icon: "arrow.down.to.line"
            ),
            FishingTip(
                title: "Use Live Bait",
                description: "Live minnows, wax worms, and maggots are excellent ice fishing baits. Keep them warm to stay lively.",
                category: .technique,
                icon: "leaf"
            ),
            FishingTip(
                title: "Watch the Barometer",
                description: "Fish are often more active when barometric pressure is stable or slowly rising. Falling pressure can slow fishing.",
                category: .weather,
                icon: "barometer"
            ),
            FishingTip(
                title: "Fish During Low Light",
                description: "Early morning and late afternoon are often the best times. Many fish feed more actively in low light conditions.",
                category: .weather,
                icon: "sunrise"
            ),
            FishingTip(
                title: "Overcast Days are Good",
                description: "Cloud cover can improve fishing. Fish feel safer and venture into shallower water when it's overcast.",
                category: .weather,
                icon: "cloud"
            ),
            FishingTip(
                title: "Find Structure",
                description: "Look for underwater structures like drop-offs, weed beds, and sunken trees. Fish congregate around structure.",
                category: .location,
                icon: "map"
            ),
            FishingTip(
                title: "Check Depth Changes",
                description: "Areas where depth changes quickly often hold fish. Use a depth finder to locate these transition zones.",
                category: .location,
                icon: "water.waves"
            ),
            FishingTip(
                title: "Avoid Crowded Areas",
                description: "If an area is heavily fished, try moving to less pressured spots. Fish learn to avoid high-traffic areas.",
                category: .location,
                icon: "figure.walk"
            )
        ]
    }
}
