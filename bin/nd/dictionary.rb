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

    def reload
      @table = nil
    end

    def key_row_match_score(key,row)
      self.class.string_matcher.getDistance(key.downcase,row[0].downcase)
    end

    def best_row_for_key(key)
      table.max_by do |row|
        key_row_match_score(key,row)
      end
    end

    def index_for_key(key)
      table.find_index {|row| row[0].downcase == key.downcase}
    end

    def insert(key,values)
      if values.kind_of? Array
        row = CSV::Row.new table.headers, [key] + values
      elsif values.kind_of? Hash
        return insert(key, table.headers.drop(1).map {|h| values[h]})
      end

      index = index_for_key(key)
      if index.nil?
        append(row)
      else
        replace(index,row)
      end

    end

    private
    def replace(index,row)
      table[index] = row
      CSV.open(table_path,"w") do |csv|
        csv << table.headers
        table.each do |row|
          csv << row
        end
      end
    end

    def append(row)
      table << row
      File.open(table_path, 'a') {|f| f.write("\r#{row.fields.join ','}")}
    end

  end

end