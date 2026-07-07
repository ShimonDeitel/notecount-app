import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: NotecountStore
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    @State private var categoryToggles: [String: Bool] = Dictionary(
        uniqueKeysWithValues: NotecountCategory.allCases.map { ($0.rawValue, true) }
    )
    @State private var showingRestoreAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Categories") {
                    ForEach(NotecountCategory.allCases, id: \.rawValue) { cat in
                        Toggle(cat.rawValue, isOn: Binding(
                            get: { categoryToggles[cat.rawValue] ?? true },
                            set: { categoryToggles[cat.rawValue] = $0 }
                        ))
                        .accessibilityIdentifier("categoryToggle_\(cat.rawValue)")
                    }
                }
                Section("Subscription") {
                    if purchases.isPurchased {
                        Label("Pace Estimator unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pace Estimator") {
                            dismiss()
                        }
                        .accessibilityIdentifier("upgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task {
                            await purchases.restore()
                            showingRestoreAlert = true
                        }
                    }
                    .accessibilityIdentifier("restoreButton")
                }
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/notecount-app/privacy.html")!)
                        .accessibilityIdentifier("privacyPolicyLink")
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/notecount-app/terms.html")!)
                        .accessibilityIdentifier("termsLink")
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(Theme.mutedInk)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
            .alert("Restore Complete", isPresented: $showingRestoreAlert) {
                Button("OK", role: .cancel) {}
            }
        }
        .tint(Theme.accent)
    }
}
