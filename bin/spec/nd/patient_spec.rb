require_relative "../spec_helper.rb"
require "ostruct"

describe Nd::Patient do
  subject(:patient){
    Nd::Patient.new.tap do |p|
      p.first_name = "Horatio"
      p.last_name = "Alger"
    end
  }

  its(:name){ should eq 'Alger, Horatio'}
  its(:dob){ should be_nil}
  its(:age){ should be_nil}

  context "after patient.dob = '1899_10_12'" do
    before(:each){ patient.dob = '1899_10_12' }
    its(:dob){ should eq '1899_10_12'}
    its(:date_of_birth){ should eq Date.new(1899,10,12)}
    its(:age){ should eq patient.age_on_date Date.today }

    describe ".age_on_date" do
      subject(:age){ patient.age_on_date Date.strptime(datestring, "%Y_%m_%d")}
      context "2014_12_10" do
        let(:datestring){ "2014_12_10" }
        it{ should eq 115}
      end
      context "1999_10_5" do
        let(:datestring){ "1999_10_5" }
        it{ should eq 99}
      end

    end

  end

  describe "Nd::Patient.from_yaml" do
    subject(:patient) { Nd::Patient.from_yaml yaml }

    context "with simple attributes" do
      let(:yaml){<<-YAML.gsub('^\s+','')
        first_name: Marge
        last_name: Simpson
        dob: 1962/6/12
      YAML
      }

      its(:name){ should eq "Simpson, Marge"}
      its(:dob){ should eq "1962_06_12"}

    end


    context "with simple attributes" do
      let(:yaml){<<-YAML.gsub('^\s{8}','')
        first_name: Marge
        last_name: Simpson
        dob: 1962/6/12

        allergies:
          -
            item: lidocain
            reaction: hives
          -
            item: sulfa
            reaction: hallucinations

      YAML
      }

      its(:name){ should eq "Simpson, Marge"}
      its(:dob){ should eq "1962_06_12"}

      it "has 2 allergies" do
        expect(patient.allergies.map {|a| a.class}).to eq [Nd::Allergy, Nd::Allergy]
      end

    end


  end

end