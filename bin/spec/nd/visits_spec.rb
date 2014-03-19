require_relative "../spec_helper.rb"
require "ostruct"

describe Nd::Visit do
  let(:patient){
    p = Nd::Patient.new
    p.first_name = "Horatio"
    p.last_name = "Alger"
    p.dob = Date.new(1945,10,25)
    p
  }


  it{should respond_to :date}
  it{should respond_to :patient}

  describe ".new_from_struct" do
    subject(:visit){ Nd::Visit.new_from_struct options }
    let(:options){
      options = OpenStruct.new
      options.date = Date.new(2013,11,2)
      options.patient = patient
      options
    }

    its(:date_string){ should eq '2013_11_02'}
    its(:patient_dir_path){ should eq patient.dir_path }
    its(:dir_path){ should eq patient.dir_path + "/visits/2013_11_02"}

    describe "after .save" do
      before(:each) { visit.save }

      it ".dir_path exits" do
        expect(File.exists? visit.dir_path).to be true
      end

      it ".snapshot_dir_path exits" do
        expect(File.exists? visit.snapshot_dir_path).to be true
      end

      it ".progress_note_md_path exits" do
        expect(File.exists? visit.progress_note_md_path).to be true
      end

    end

  end

end