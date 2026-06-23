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
        .background(practice.color)
        .clipShape(Capsule())
    }
}

// MARK: - DetailPracticeScreen
struct DetailPracticeView: View {
    @State private var isPresentingSession = false
    let practice: BreathingPractice
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [practice.color, Color.blackGGS]),
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.whiteGGS)
                            .padding(.vertical, 10)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Text(practice.title)
                    .font(.sfRounded(size: 36, weight: .bold))
                    .foregroundColor(.whiteGGS)
                    .padding(.top, 60)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text(practice.duration)
                    Text("•")
                    Text(practice.cycles)
                }
                .font(.sfRounded(size: 16, weight: .medium))
                .foregroundColor(.whiteGGS)
                
                Rectangle()
                    .fill(Color.whiteGGS.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Смысл:")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.whiteGGS)
                        Text(practice.purpose)
                            .font(.sfRounded(size: 16, weight: .regular))
                            .foregroundColor(.whiteGGS.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Техника дыхания:")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.whiteGGS)
                        Text(practice.technique)
                            .font(.sfRounded(size: 16, weight: .regular))
                            .foregroundColor(.whiteGGS.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    isPresentingSession = true
                }) {
                    Text("Дышать")
                        .font(.sfRounded(size: 24, weight: .bold))
                        .foregroundColor(.whiteGGS)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(practice.color)
                        .clipShape(Capsule())
                        .padding(.horizontal, 74)
                }
                .padding(.bottom, 40)
                .fullScreenCover(isPresented: $isPresentingSession) {
                    SessionPracticeView(viewModel: PracticeViewModel(practice: practice))
                }
            }
        }
    }
}
