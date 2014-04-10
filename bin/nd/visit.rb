require 'nd/util'
require 'nd/patient'
require 'nd/serializable'
require 'kramdown'
require 'pathname'
require 'shellwords'
require 'fileutils'

module Kramdown::Options

  define(:visit, Object, 55, "Visit") do |val|
    unless val.kind_of? Nd::Visit
      raise "\n\n Our parser variant needs a visit!!! \n\n"
    end
    val
  end

end

class Kramdown::Converter::Latex

  def convert_header(el, opts)
    # Make text follow headers wit only one line break
    type = @options[:latex_headers][output_header_level(el.options[:level]) - 1]
    "\\#{type}{#{inner(el, opts)}}\n"
  end

  def convert_hr(el, opts)
    "\\pagebreak\n\\sectionoverlinefalse\n"
  end

  def convert_standalone_image(el, opts, img)
      attrs = attribute_list(el)
      <<-str.gsub /^\s+/, ""
      \\begin{figure}[h!]
      \\begin{center}
      #{img}
      \\caption{#{escape(el.children.first.attr['alt'])}}
      \\end{center}
      \\end{figure}#{attrs}
      str
  end

  def convert_img(el, opts)
    if el.attr['src'] =~ /^(https?|ftps?):\/\//
      warning("Cannot include non-local image")
      ''
    elsif !el.attr['src'].empty?
      @data[:packages] << 'graphicx'
      # Include multiple images on one line
      optarg, imagearg = el.attr['src'].split "::"
      unless imagearg
        images = optarg.split ","
        options = "width=#{0.96/images.count}\\textwidth"
      else
        images = imagearg.split ","
        options = optarg
      end
      images.map do |name|
        path = "\"#{@options[:visit].dir_path}/#{name.gsub(/\.\w+$/,"")}\""
        "\\includegraphics[#{options}]{#{path}}"
      end.join("\n")
    else
      warning("Cannot include image with empty path")
      ''
    end
  end

end

module Nd
  class Visit < Serializable
    attr_accessor :date, :patient

    def preview_progress_note
      create_dir_if_absent
      File.write progress_note_tex_path, progress_note_tex
      pdflatex progress_note_tex_path
      #open_file_with_preview progress_note_pdf_path
    end

    def finalize_progress_note
      if File.exists? final_progress_note_pdf_path
        raise "\n\nA finalized progress note (#{final_progress_note_pdf_path}) already exists!\n\n"
      end

      create_dir_if_absent
      unless File.exists? progress_note_tex_path
        File.write progress_note_tex_path, progress_note_tex
        pdflatex progress_note_tex_path
      end
      pdflatex progress_note_tex_path
      FileUtils.cp(progress_note_pdf_path, final_progress_note_pdf_path)
    end

    def final_progress_note_pdf_path
      File.expand_path(date.strftime("%Y_%m_%d") + "_note.pdf", patient.dir_path)
    end

    def date
      @date ||= Date.today
    end

    def previous_visit
      return @previous_visit if @previous_visit
      prevdate = nil
      patient.visit_dates.sort.each do |d|
        if d < date
          prevdate = d
        else
          break
        end
      end
      if prevdate
        vdir = File.expand_path(prevdate.strftime("%Y_%m_%d"), patient.visits_dir_path)
        @previous_visit = self.class.initialize_from_dir(vdir)
        return @previous_visit
      end
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

    def progress_note_tex_path
      File.expand_path("progress_note.tex",tex_dir_path)
    end

    def progress_note_pdf_path
      File.expand_path("progress_note.pdf",tex_dir_path)
    end

    def progress_note_body_tex
      opts = {auto_ids: false, visit: self}
      Kramdown::Document.new(File.read(progress_note_body_path), opts).to_latex
    end

    def progress_note_tex
      render_file(template_path "progress_note.tex")
    end

    def initialize_files_if_absent
      create_dir_if_absent
      initialize_file_with_template_if_absent progress_note_body_path, "progress_note_body.md"
    end

    def create_dir_if_absent
      [dir_path,snapshot_dir_path,tex_dir_path,image_dir_path].each do |path|
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

    def tex_dir_path
      File.expand_path("tex",dir_path)
    end

    def snapshot_dir_path
      File.expand_path(".snapshot",dir_path)
    end

    def image_dir_path
      File.expand_path("img",dir_path)
    end

    def image_file_names
      Dir[image_dir_path+"/*"].map {|s| s.gsub(/.*\//,"")}
    end

    def render_template(filename)
      render_file template_path(filename)
    end

    protected

    def template_path(filename)
      File.expand_path("templates/visit/"+filename,BUNDLE_PATH)
    end

    def open_file_with_preview(path)
      cmd = <<-cmd
      osascript -e "tell application \\"Preview\\" to open \\"#{path}\\""
      cmd
      `#{cmd}`
    end

    def pdflatex(path)
      path = Pathname.new(path)
      `cd #{Shellwords.escape path.dirname} && pdflatex #{Shellwords.escape path.basename}`
    end

  end

end
