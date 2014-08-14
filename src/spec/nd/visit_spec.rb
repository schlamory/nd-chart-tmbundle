require_relative "../spec_helper.rb"

describe Nd::Visit do
  subject(:visit) do
    Nd::Visit.new.tap do |v|
      v.patient = patient
      v.date = Date.new(2014,3,3)
    end
  end

  let(:patient){
    p = Nd::Patient.new
    p.first_name = "Horatio"
    p.last_name = "Alger"
    p.date_of_birth = Date.new(1945,10,25)
    p.initialize_files_if_absent
    p
  }

  it{should respond_to :date}
  it{should respond_to :patient}

  describe "after .initialize_files_if_absent" do
    before(:each) do
      visit.initialize_files_if_absent
    end
    after(:each) do
      clear_patients
    end

    it "has made progress_note.md" do
      expect(File.exists? visit.progress_note_body_path).to be true
    end

    it "progress note md includes the date and the patient name" do
      expect(File.read(visit.progress_note_body_path)).to include patient.name
    end

    it "has made an img/ folder" do
      expect(Dir.exists? visit.image_dir_path).to be true
    end

    it "has made an tex/ folder" do
      expect(Dir.exists? visit.tex_dir_path).to be true
    end

    it "has made a .snapshot/ folder" do
      expect(Dir.exists? visit.snapshot_dir_path).to be true
    end

    it ".patient.visit_dates includes the date" do
      expect(patient.visit_dates).to eq [visit.date]
    end

    it ".previous_visit is nil" do
      expect(visit.previous_visit).to be nil
    end

    describe "After writing in the chart note body" do
      before(:each) do
        File.open(visit.progress_note_body_path,'a') do |f| f.write "Foo Bar" end
      end

      describe "a new visit" do
        subject(:new_visit) do
          Nd::Visit.new.tap do |v|
            v.patient = patient
            v.date = visit.date+10
            v.initialize_files_if_absent
          end
        end

        it ".previous_visit is not nil" do
          expect(new_visit.previous_visit).to_not be nil
        end

        it "incldes the old visit's progress note" do
          expect(File.read(new_visit.progress_note_body_path) ).to include "Foo Bar"
        end

      end

    end

  end

end