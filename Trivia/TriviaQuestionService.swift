//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Salma Ziadi on 3/27/25.
//


import Foundation

class TriviaQuestionService {
  func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]) -> Void) {
    let urlString = "https://opentdb.com/api.php?amount=10&type=multiple"
    guard let url = URL(string: urlString) else {
      completion([])
      return
    }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        error == nil,
        let data = data,
        let decodedResponse = try? JSONDecoder().decode(TriviaResponse.self, from: data)
      else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }

      let questions = decodedResponse.results.map { apiQuestion in
        TriviaQuestion(
          category: apiQuestion.category,
          question: Self.htmlUnescape(apiQuestion.question),
          correctAnswer: Self.htmlUnescape(apiQuestion.correct_answer),
          incorrectAnswers: apiQuestion.incorrect_answers.map { Self.htmlUnescape($0) }
        )
      }

      DispatchQueue.main.async {
        completion(questions)
      }
    }

    task.resume()
  }

    private static func htmlUnescape(_ string: String) -> String {
      guard let data = string.data(using: .utf8) else { return string }
      let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
        NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
        NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
      ]
      return (try? NSAttributedString(data: data, options: options, documentAttributes: nil).string) ?? string
    }

}
