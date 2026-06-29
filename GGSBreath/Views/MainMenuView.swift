import SwiftUI

// MARK: - MainScreen
struct MainMenuView: View {
    @State private var selectedPractice: BreathingPractice? = nil
    
    let practices = [
        BreathingPractice(
            title: "Спокойствие", duration: "5 мин", cycles: "16 циклов",
            purpose: "Помогает быстро снять тревогу и успокоить нервную систему",
            technique: "Вдох на 4 сек, задержка на 7 сек, медленный выдох на 8 сек.",
            color: .blueGGS
        ),
        BreathingPractice(
            title: "Энергия", duration: "3 мин", cycles: "60 циклов",
            purpose: "Вместо второй чашки кофе. Помогает проснуться или взбодриться.",
            technique: "Активное дыхание (2 сек вдох — 1 сек выдох, быстрый цикл).",
            color: .redGGS
        ),
        BreathingPractice(
            title: "Фокус", duration: "4 мин", cycles: "15 циклов",
            purpose: "Стабилизирует внимание, улучшает концентрацию",
            technique: "Равный вдох, задержка, выдох и задержка — всё по 4 секунды.",
            color: .purpleGGS
        ),
        BreathingPractice(
            title: "Сон", duration: "10 мин", cycles: "50 циклов",
            purpose: "Глубоко расслабляет тело и ум, отключает мысли и подготавливает ко сну.",
            technique: "Равный вдох на 4 сек и удлиненный, медленный выдох на 8 сек.",
            color: .darkBlueGGS
        )
    ]
    
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
                    ForEach(practices) { practice in
                        Button(action: {
                            selectedPractice = practice
                        }) {
                            PracticeRowView(practice: practice)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blackGGS.ignoresSafeArea())
        .sheet(item: $selectedPractice) { practice in
            DetailPracticeView(practice: practice)
        }
    }
}

struct PracticeRowView: View {
    let practice: BreathingPractice
    
    var body: some View {
        HStack {
            Spacer()
            Text(practice.title)
                .font(.sfRounded(size: 24, weight: .bold))
                .foregroundColor(.whiteGGS)
            Spacer()
        }
        .frame(height: 120)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    practice.color,
                    practice.color.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(Capsule())
        .shadow(color: practice.color.opacity(0.15), radius: 10, x: 0, y: 6)
    }
}
