require_relative "../spec_helper.rb"
require "ostruct"


describe Nd do

  describe "Dictionary" do
    subject(:dict) do
      Nd::Dictionary.new.tap do |d|
        d.table_path = File.expand_path("../../tmp/foo.csv",__FILE__)
        File.open(d.table_path,'w') {|f| f.write "key,value\rfooKey,fooValue\rbarKey,barValue"}
      end
    end

    it{ should be_kind_of Nd::Dictionary }

    it "has the right number of rows" do
      expect(dict.table.length).to be 2
    end

    it ".expand_key 'foo' is correct" do
      expect(dict.expand_key 'fooKey').to eq 'fooKey (fooValue)'
    end

    context "after .add_key_value 'bazKey', 'bazValue' " do
      before(:each) do
        dict.add_key_value 'bazKey', 'bazValue'
      end

      it "has the right number of rows" do
        expect(dict.table.length).to be 3
      end

    end

  end

  describe ".Icd9Dictionary" do
    subject(:dict) { Nd.Icd9Dictionary }
    its(:table_name){ should eq 'icd9_dictionary'}

    it ".expand_key 'stress' is correct" do
      expect(dict.expand_key 'stress').to eq 'stress (308.9)'
    end

    it ".expand_key 'StrEss' is correct" do
      expect(dict.expand_key 'stress').to eq 'stress (308.9)'
    end

    it ".expand_key 'foobar' is correct" do
      expect(dict.expand_key 'foobar').to eq 'foobar (no match found)'
    end

    it ".best_row_for_key 'depression' is correct" do
      expect(dict.best_row_for_key('depression')[0]).to eq "depression"
    end

  end

end