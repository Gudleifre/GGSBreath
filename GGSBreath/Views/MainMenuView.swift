import SwiftUI

struct MainMenuView: View {
    @State private var selectedPractice: PracticeKind?

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                Text("G.G.S").font(.sfRounded(size: 20, weight: .bold)).foregroundColor(.whiteGGS)
                Text("|").font(.sfRounded(size: 20, weight: .bold)).foregroundColor(.blueGGS)
                Text("Breath").font(.sfRounded(size: 20, weight: .bold)).foregroundColor(.whiteGGS)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(PracticeKind.allCases) { kind in
                        Button {
                            selectedPractice = kind
                        } label: {
                            PracticeRowView(kind: kind)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blackGGS.ignoresSafeArea())
        .sheet(item: $selectedPractice) { kind in
            DetailPracticeView(kind: kind)
        }
    }
}

struct PracticeRowView: View {
    let kind: PracticeKind

    var body: some View {
        HStack {
            Spacer()
            Text(kind.title)
                .font(.sfRounded(size: 24, weight: .bold))
                .foregroundColor(.whiteGGS)
            Spacer()
        }
        .frame(height: 120)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    kind.color,
                    kind.color.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(Capsule())
        .shadow(color: kind.color.opacity(0.15), radius: 10, x: 0, y: 6)
    }
}
