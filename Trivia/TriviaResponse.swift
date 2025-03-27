//
//  TriviaResponse.swift
//  Trivia
//
//  Created by Salma Ziadi on 3/27/25.
//


import Foundation

struct TriviaResponse: Decodable {
  let results: [TriviaQuestionAPIModel]
}

struct TriviaQuestionAPIModel: Decodable {
  let category: String
  let question: String
  let correct_answer: String
  let incorrect_answers: [String]
}
