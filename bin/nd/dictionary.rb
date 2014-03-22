require 'csv'
require 'fuzzystringmatch'

module Nd::Dictionary
  DICTIONARY_DIR = File.expand_path "Dictionaries", Nd::BUNDLE_PATH

  def self.string_matcher
    @@matcher ||= FuzzyStringMatch::JaroWinkler.create( :pure )
  end

  def self.load_table(path)
    CSV.parse(File.read(path))
  end

  def self.best_match(string,rows,min_score=0)
    row,score = rows.reduce([nil,0]) do |(best_row,best_score),row|
      score = string_matcher.getDistance(string,row[0])
      if score > best_score
        [row,score]
      else
        [best_row,best_score]
      end
    end
    if score > min_score
      row
    end
  end

  module Icd9
    PATH = File.expand_path "icd9_dictionary.csv", DICTIONARY_DIR

    def self.table
      @@table ||= Nd::Dictionary.load_table(PATH)
    end

    def self.search(string)

    end

    def self.append(key,value)

    end

  end

end