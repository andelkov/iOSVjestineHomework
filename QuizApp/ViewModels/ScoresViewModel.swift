// Struktura koja sluzi da se ScoreTableCellView napuni njenim podacima

struct ScoreCellModel {
    
    let number: String
    let username: String
    let score: String
    
    init(number: Int, score: Score) {
        self.number = "\(number)"
        self.username = score.username
        self.score = String(format: "%.3f", score.score)
    }
}

// ScoreViewModel je razred koji je veza izmedu ScoreViewController-a i modela,
// ovaj razred pruza metode preko kojih ScoreViewController dohvaca informacije o modelu ili kroz koje propagira promjene modela (konkretno model je lista Score-ova)

class ScoresViewModel {
        // viewModel sadrzi referencu prema modelu (ako je to potrebno)
    private var quizId: Int
    private var scores: [Score]?
    
    init(quizId: Int) {
        self.quizId = quizId
    }
    
    public var numberOfScores: Int {
        return scores?.count ?? 0
    }
    //     metoda viewModela koja vraca informacije o modelu
    public func score(forRow row: Int) -> ScoreCellModel? {
        guard let scores = scores else {
            return nil
        }
        return ScoreCellModel(number: row + 1, score: scores[row])
    }
    //     Metoda fetchScore sada dohvaca Score sa servera i sprema ih u bazu podataka
    
    public func fetchScores(completion: @escaping () -> Void) {
        QuizService().fetchScores(forQuiz: quizId, completion: { [weak self] (scores) in
            self?.scores = scores
            self?.scores?.sort{ $0.score > $1.score }
            completion()
        })
    }
}
