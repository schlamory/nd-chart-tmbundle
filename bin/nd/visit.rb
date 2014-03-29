require 'nd/util'
require 'nd/patient'
require 'nd/serializable'
require 'kramdown'

class Kramdown::Converter::Latex

  def convert_header(el, opts)
    type = @options[:latex_headers][output_header_level(el.options[:level]) - 1]
    "\\#{type}{#{inner(el, opts)}}\n"
  end

end

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

    def progress_note_body_path
      File.expand_path("progress_note_body.md",dir_path)
    end

    def progress_note_html_path
      File.expand_path("progress_note.html",dir_path)
    end

    def progress_note_tex_path
      File.expand_path("progress_note.tex",dir_path)
    end

    def progress_note_body_html
      Kramdown::Document.new(File.read(progress_note_body_path)).to_html
    end

    def progress_note_body_tex
      Kramdown::Document.new(File.read(progress_note_body_path)).to_latex
    end

    def progress_note_html
      render_file(template_path "progress_note.html")
    end

    def progress_note_tex
      render_file(template_path "progress_note.tex")
    end

    def initialize_files_if_absent
      create_dir_if_absent
      initialize_file_with_template_if_absent progress_note_body_path, "progress_note_body.md"
    end

    def create_dir_if_absent
      [dir_path,snapshot_dir_path,preview_dir_path,final_dir_path].each do |path|
        FileUtils.mkdir_p path unless Dir.exists? path
      end
    end

    def self.initialize_from_dir(dir_path)
      begin
        Visit.new.tap do |v|
          v.date = Date.strptime(dir_path.gsub(/.*\//,''), "%Y_%m_%d")
          patient_dir = Nd::Patient.patient_dir_containing_dir dir_path
          v.patient = Nd::Patient.initialize_from_dir patient_dir
        end
      rescue
        raise "\n\nThe working directory (#{dir_path}) is not a patient visit directory. Please try again from a patient visit directory.\n\n"
      end
    end

    def snapshot_dir_path
      File.expand_path(".snapshot",dir_path)
    end

    def preview_dir_path
      File.expand_path(".preview",dir_path)
    end

    def final_dir_path
      File.expand_path(".final",dir_path)
    end

    def image_dir_path
      File.expand_path("img",dir_path)
    end

    def image_file_names
      Dir[image_dir_path+"/*"].map {|s| s.gsub(/.*\//,"")}
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
