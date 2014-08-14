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

    def self.load_yaml_from_path(path)
      begin
        YAML.load(File.read(path))
      rescue Exception => e
        raise "\n\nError loading YAML file:\n #{path}:\n\n#{e}"
      end
    end

    def load_yaml_from_path(path)
      self.class.load_yaml_from_path path
    end

    protected

    def render_file(path)
      begin
        ERB.new(File.open(path,'r').read,nil,'<>').result binding
      rescue Exception => e
        raise "\n\nError rendering file:\n #{path}:\n\n#{e}"
      end
    end

    def initialize_file_with_template_if_absent(file_path,template_name)
      unless File.exists? file_path
        text = render_file template_path template_name
        File.write(file_path, text)
      end
    end

  end

end