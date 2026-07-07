import XCTest
@testable import Notecount

@MainActor
final class NotecountStoreTests: XCTestCase {

    func makeFreshStore() -> NotecountStore {
        // Use a fresh store; it will load persisted state or seed data.
        let store = NotecountStore()
        return store
    }

    func testSeedDataLoadsBelowFreeLimit() {
        let store = makeFreshStore()
        XCTAssertLessThan(store.items.count, NotecountStore.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = makeFreshStore()
        let before = store.items.count
        let added = store.add(title: "Test Entry", category: "Textbook", value: 1.0)
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testCanAddMoreWhenBelowLimit() {
        let store = makeFreshStore()
        XCTAssertTrue(store.canAddMore)
    }

    func testFreeLimitBlocksAdditionalAdds() {
        let store = makeFreshStore()
        while store.items.count < NotecountStore.freeLimit {
            _ = store.add(title: "Filler", category: "Textbook", value: 1.0)
        }
        let added = store.add(title: "Overflow", category: "Textbook", value: 1.0)
        XCTAssertFalse(added)
        XCTAssertEqual(store.items.count, NotecountStore.freeLimit)
    }

    func testProBypassesFreeLimit() {
        let store = makeFreshStore()
        store.isPro = true
        while store.items.count < NotecountStore.freeLimit {
            _ = store.add(title: "Filler", category: "Textbook", value: 1.0)
        }
        let added = store.add(title: "Extra", category: "Textbook", value: 1.0)
        XCTAssertTrue(added)
    }

    func testDeleteRemovesItem() {
        let store = makeFreshStore()
        _ = store.add(title: "ToDelete", category: "Textbook", value: 1.0)
        guard let item = store.items.first(where: { $0.title == "ToDelete" }) else {
            return XCTFail("item not found")
        }
        store.delete(item)
        XCTAssertNil(store.items.first(where: { $0.id == item.id }))
    }

    func testTotalValueSumsItems() {
        let store = makeFreshStore()
        let before = store.totalValue
        _ = store.add(title: "SumTest", category: "Textbook", value: 5.0)
        XCTAssertEqual(store.totalValue, before + 5.0, accuracy: 0.001)
    }

    func testToggleResolvedFlipsFlag() {
        let store = makeFreshStore()
        _ = store.add(title: "ResolveMe", category: "Textbook", value: 1.0)
        guard let item = store.items.first(where: { $0.title == "ResolveMe" }) else {
            return XCTFail("item not found")
        }
        XCTAssertFalse(item.isResolved)
        store.toggleResolved(item)
        XCTAssertTrue(store.items.first(where: { $0.id == item.id })!.isResolved)
    }
}
