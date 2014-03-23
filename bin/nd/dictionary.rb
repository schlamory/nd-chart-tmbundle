require 'csv'
require 'fuzzystringmatch'

module Nd
  class Dictionary
    DICTIONARY_DIR = File.expand_path "dictionaries", Nd::BUNDLE_PATH
    attr_accessor :table_name, :table_path, :min_match_score, :table

    def min_match_score
      @min_match_score ||= 0.8
    end

    def table_path
      @table_path ||= DICTIONARY_DIR + "/#{table_name}.csv"
    end

    def self.string_matcher
      @@matcher ||= FuzzyStringMatch::JaroWinkler.create( :pure )
    end

    def table
      @table ||= CSV.parse(File.read(table_path), :headers => true)
    end

    def key_row_match_score(key,row)
      self.class.string_matcher.getDistance(key.downcase,row[0].downcase)
    end

    def best_row_for_key(key)
      table.max_by do |row|
        key_row_match_score(key,row)
      end
    end

    def row_to_string(row)
      "#{row[0]} (#{row[1]})"
    end

    def expand_key(key)
      row = best_row_for_key(key)
      if key_row_match_score(key,row) >= min_match_score
        row_to_string(row)
      else
        "#{key} (no match found)"
      end
    end

    def add_key_value(key,value)
      row = CSV::Row.new table.headers, [key] + value_to_fields(value)
      table << row
      File.open(table_path, 'a') {|f| f.write("\r#{row.fields.join ','}")}
    end

    def value_to_fields(value)
      [value]
    end

  end

  def self.Icd9Dictionary
    @@icd9 ||= Dictionary.new.tap do |d|
      d.table_name = "icd9_dictionary"
    end
  end

end