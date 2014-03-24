require 'nd/util'
require 'nd/patient'
require 'nd/serializable'

module Nd
  class Visit
    attr_accessor :date, :patient

    def date
      @date ||= Date.today
    end

    def patient_age
      patient.age_on_date date
    end

    def dir_path
      File.expand_path(date.strftime("%Y_%m_%d"), patient.visits_dir_path)
    end

    def progress_note_md_path
      File.expand_path("progress_note.md",dir_path)
    end

    def initialize_files_if_absent
      create_dir_if_absent
      initialize_file_with_template_if_absent progress_note_md_path, "progress_note.md"
    end

    def create_dir_if_absent
      FileUtils.mkdir_p dir_path unless Dir.exists? dir_path
    end

    private

    def render_file(path)
      ERB.new(File.open(path,'r').read,nil,'<>').result binding
    end

    def template_path(filename)
      File.expand_path("templates/visit/"+filename,BUNDLE_PATH)
    end

    def initialize_file_with_template_if_absent(file_path,template_name)
      text = render_file template_path template_name
      unless File.exists? file_path
        File.open(file_path,'w').write text
      end
    end


  end

end
