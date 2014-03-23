require 'yaml'
require 'nd/util'

module Nd

  class Serializable

    def self.from_hash(hash)
      self.new.tap do |ob|
        hash.each_pair do |k,v|
          begin
            ob.send(k+"=",v)
          rescue
          end
        end
      end
    end

    def self.from_yaml(yaml)
      hash = YAML.load(yaml)
      from_hash(hash)
    end

    def to_hash

    end

  end

end