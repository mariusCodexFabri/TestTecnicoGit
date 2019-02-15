# HemingwayTest
Test String manipulation

This project takes in input an Hemingway book - The old and the sea - and tests various way to manipulate the book text.
In particular the text is tokenized in words and the algorithm counts the occurrences of every single word.

The project evaluates if the occurrencies value is prime as well.

There are 3 different solutions:

- Using the .filter method

      var words = [String]()
      let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
      let components = text.components(separatedBy: chararacterSet)
      words = components.filter { !$0.isEmpty }

In this case first you define a set of characters to omit white spaces, puctuation, and new lines chars.
Then you get an array of the components of text free of the special characters
finally you filter the array of components.

__PROS__: Most performant implementation.

__CONS__: Not so precise expecially with abbreviations and accents.


- Using the .enumerateSubstring method

      let range = text.startIndex..<text.endIndex
      text.enumerateSubstrings(in: range, options: [.byWords]) { (substring, _, _, _)_ in
        if let substring = substring {
         words.append(substring)
        }
      }

In this case first you define the range of characters of the text.
Then you enumerate the words in that range appending each one into the words array.

__PROS__: Quite prices tokenizing words.

__CONS__: Similar to the linguistic tagger but less possibilities; less performance than .filter method


- Using the Natural Language processing method (linguistic tagger)

      var tokenizedText: [String] = []

      tagger.string = text
      let range = NSRange(location: 0, length: text.utf16.count)

      tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: optionsWords) { tag, tokenRange, stop in
        let word = (text as NSString).substring(with: tokenRange)
        tokenizedText.append(word)
      }

In this case, again, first you define the range of characters of the text.
Then the tagger -that identifies the parts of the text- enumerates the words in that range.
each evaluated word is appended into the tokenizedText array.
N.B. In the options you omit punctuation and white spaces

__PROS__: Easiest since the tagger does all the job and the most useful for other usage like lemmatization.

__CONS__: This is the most resourceful method and the less performing.
