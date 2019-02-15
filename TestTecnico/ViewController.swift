//
//  ViewController.swift
//  TestTecnico
//
//  Created by Mario Matrone on 12/02/2019.
//  Copyright © 2019 Mario Matrone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var text = String()
    private var words = [String]()
    
    private let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    let optionsWords: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
        // MARK: .filter method
        let startTimeFilter = CFAbsoluteTimeGetCurrent()

        self.words = retrieveWordsFilering(in: text)
        print(words)
        evaluateWordsOccurrences(in: words)

        let timeElapsedFilter = CFAbsoluteTimeGetCurrent() - startTimeFilter
        print("Time elapsed for .filter method: \(timeElapsedFilter) s.") // ~ 0.00281
        
        
        // MARK: .enumerateSubstring method
        let startTimeEnumerate = CFAbsoluteTimeGetCurrent()
        
        self.words = retrieveWordsEnumerating(in: text)
        print(words)
        evaluateWordsOccurrences(in: words)
        
        let timeElapsedEnumerate = CFAbsoluteTimeGetCurrent() - startTimeEnumerate
        print("Time elapsed for .enumerateSubstrings method: \(timeElapsedEnumerate) s.") // ~ 0.00688
        
        
        // MARK: Natural Language Processing method (linguistic tagger)
        let startTimeNLP = CFAbsoluteTimeGetCurrent()
        
        self.words = tokenization(for: text)
        print(words)
        evaluateWordsOccurrences(in: words)
        
        let timeElapsedNLP = CFAbsoluteTimeGetCurrent() - startTimeNLP
        print("Time elapsed for .filter method: \(timeElapsedNLP) s.") // ~ 0.07298
        
    }
    
    private func initialize() {
        
        guard let textPath = Bundle.main.path(forResource: "Hemingway", ofType: "txt") else {
            return
        } // File path for file "Hemingway.txt"
        
        do {
            self.text = try String(contentsOfFile: textPath, encoding: String.Encoding.macOSRoman).lowercased() // retrieve lowercased text (Ignore Uppercased characters)
        }
        catch {
            print(error)
        }
    }
    
    // MARK: Enumerate words using .enumerateSubstrings method (.byWords)
    private func retrieveWordsEnumerating(in text: String) -> [String] {
        var words = [String]()

        let range = text.startIndex..<text.endIndex
        text.enumerateSubstrings(in: range, options: [.byWords]) { (substring, _, _, _) in
            if let substring = substring {
                words.append(substring)
            }
        }
        
        return words
    }
    
    // MARK: Enumerate words using .filter method
    private func retrieveWordsFilering(in text: String) -> [String] {
        var words = [String]()
        
        let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = text.components(separatedBy: characterSet)
        words = components.filter { !$0.isEmpty }
        
        return words
    }
    
    // MARK: TOKENIZATION Splitting words.
    func tokenization(for text: String) -> [String] {
        var tokenizedText: [String] = []

        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count) //range of characters the API should tokenize (il numero di caratteri del testo)
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: optionsWords) { tag, tokenRange, stop in
            let word = (text as NSString).substring(with: tokenRange)
            tokenizedText.append(word)
        }
        return tokenizedText
    }
    
    // MARK: Evaluate words occurrences
    func evaluateWordsOccurrences(in array: [String]) {
        var counts: [String: Int] = [:]
        
        for word in array {
            //            //If value != nil
            //            if counts[word] != nil {
            //                counts[word] = counts[word]! + 1 // valore corrispondente alla chiave item +=1
            //            } else {
            //                counts[word] = 0 + 1 // valore corrispondente alla chiave item = 0 + 1
            //            }
            //
            //            counts[word] = (counts[word] != nil ? counts[word]! : 0) + 1
            
            counts[word] = (counts[word] ?? 0) + 1
        }
        
        for (key, value) in counts {
            print("\(key) occurs \(value) time(s)")
            if isPrime(value) {
                print("...and \(value) is a prime")
            }
        }
    }
    
    // MARK: Evaluate a prime
    private func isPrime(_ number: Int) -> Bool {
        return number > 1 && !(2..<number).contains { number % $0 == 0 } // if number > 1 and the sequence doesn't contain a number that satisfies the predicate in the closure, then return true
    }
    
}

