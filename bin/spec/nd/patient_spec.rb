require_relative "../spec_helper.rb"
require "ostruct"

describe Nd::Patient do

  it {should respond_to :first_name }
  it {should respond_to :last_name}

  describe ".new_from_struct" do
    subject(:patient){ Nd::Patient.new_from_struct(options) }
    let(:options){
      options = OpenStruct.new
      options.first_name = "First"
      options.last_name = "Last"
      options.dob = Date.new(1999,5,17)
      options
    }
    its(:first_name){ should eq "First" }
    its(:last_name){ should eq "Last" }
    its(:dir_path){ should eq ENV["ND_PATIENTS_DIR"] + "/Last, First" }
    its(:dob_string){ should eq '1999_05_17'}

    context "after .save" do
      before(:each) do
        patient.save
      end

      it "creates a patient directory" do
        expect(Dir.exists? patient.dir_path).to be true
      end

      it "creates a patient file" do
        expect(File.exists? patient.patient_file_path).to be true
      end

      it "creates a medications file" do
        expect(File.exists? patient.medications_file_path).to be true
      end

      it "creates a problems file" do
        expect(File.exists? patient.medications_file_path).to be true
      end

      it "creates a visits directory" do
        expect(Dir.exists? patient.visits_dir_path).to be true
      end

      it "creates a labs directory" do
        expect(Dir.exists? patient.labs_dir_path).to be true
      end

      context "after .save_patient_problems_medications(dir)" do
        before(:each) do
          patient.save_patient_problems_medications(dir)
        end
        let(:dir){ patient.dir_path + "/backup"}
        it "saves a patient file to the directory" do
          expect(File.exists? dir + "/patient.yml").to be true
        end
      end

      context "with extra files in the patient, visits, and labs directories" do
        let(:paths) do
          ["dir","visits_dir","labs_dir"].map do |s|
            patient.send(s+"_path") + "/foo.txt"
          end
        end
        before(:each) do
          paths.each do |path|
            File.open(path,"w")
          end
        end

        context "after .save" do
          before(:each){ patient.save }
          it "does nothing to the a file in the patient dir" do
            expect(File.exists?(paths[0])).to be true
          end

          it "does nothing to the a file in the visits dir" do
            expect(File.exists?(paths[1])).to be true
          end

          it "does nothing to the a file in the visits dir" do
            expect(File.exists?(paths[2])).to be true
          end

        end

      end

    end

  end

end