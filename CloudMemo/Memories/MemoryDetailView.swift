import SwiftUI
import CloudKit

struct MemoryDetailView: View {
    let date: Date
    
    @State private var moodText: String = ""
    @State private var mood: Int = -1
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    private let dataKey = "dailyEntries"
    
    var body: some View {
        VStack(spacing: 20) {
            if mood >= 0 {
                Image(moodImageName(for: mood))
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Text(formattedDate(from: date))
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(.primary)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                Text(moodDescription(for: mood))
                    .font(.title)
                    .foregroundColor(moodColor(for: mood))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            VStack{
                if !moodText.isEmpty {
                    Text(moodText)
                        .font(.title3)
                        .foregroundColor(moodColor(for: mood))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 2)
            )
            Spacer()
        }
        .padding(20)
        .cornerRadius(10)
        .padding()
        .onAppear {
            loadMoodData(for: date)
        }
    }
    
    private func loadMoodData(for date: Date) {
        let formattedDate = formattedDate(from: date)
        let dailyEntries = UserDefaults.standard.dictionary(forKey: dataKey) as? [String: [String: Any]] ?? [:]
        
        if let entry = dailyEntries[formattedDate] {
            mood = entry["mood"] as? Int ?? -1
            moodText = entry["text"] as? String ?? ""
        }
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func moodDescription(for mood: Int) -> String {
        switch mood {
        case 0:
            return "Awesome"
        case 1:
            return "Happy"
        case 2:
            return "Okay"
        case 3:
            return "Sad"
        case 4:
            return "Angry"
        case 5:
            return "Terrible"
        default:
            return "Unknown"
        }
    }
    
    private func moodColor(for mood: Int) -> Color {
        switch mood {
        case 0:
            return .green
        case 1:
            return .yellow
        case 2:
            return .gray
        case 3:
            return .blue
        case 4:
            return .red
        case 5:
            return .purple
        default:
            return .black
        }
    }
    
    private func moodImageName(for mood: Int) -> String {
        switch mood {
        case 0:
            return "awesomecloud"
        case 1:
            return "happycloud"
        case 2:
            return "okaycloud"
        case 3:
            return "sadcloud"
        case 4:
            return "angrycloud"
        case 5:
            return "terriblecloud"
        default:
            return "cloud"
        }
    }
}

struct MemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryDetailView(date: Date())
    }
}
