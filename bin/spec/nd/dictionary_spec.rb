require_relative "../spec_helper.rb"
require "ostruct"


describe Nd do

  describe "Dictionary" do
    subject(:dict) do
      Nd::Dictionary.new.tap do |d|
        d.table_path = File.expand_path("../../tmp/foo.csv",__FILE__)
        File.open(d.table_path,"w") do |f|
          f.write "key,v1,v2\n"
          f.write "fooKey,fooV1,fooV2\n"
          f.write "barKey,barV1,barV2\n"
        end
      end
    end

    it "has the right number of rows" do
      expect(dict.table.length).to be 2
    end

    it ".index_for_key returns the right index for an existing row" do
      expect(dict.index_for_key 'fookey').to be 0
    end

    it ".index_for_key returns nil if no matching row" do
      expect(dict.index_for_key 'bazKey').to be_nil
    end

    context "after .insert a new row with values as an array" do
      before(:each) do
        dict.insert "bazKey", ["bazV1","bazV2"]
      end

      it "the table has the right number of rows" do
        expect(dict.table.length).to be 3
      end

      it "the last row of the table has the values array" do
        expect(dict.table[2].fields).to eq ["bazKey", "bazV1", "bazV2"]
      end

      it "the last row of the table has the values hash" do
        expect(dict.table[2].to_hash).to eq "key" => "bazKey", "v1" => "bazV1", "v2" => "bazV2"
      end

      context "after .reload" do
        before(:each){ dict.reload }
        it "the table has the right number of rows" do
          expect(dict.table.length).to be 3
        end
        it "the rows are sorted" do
          expect(dict.table.map {|r| r[0]}).to eq ["barKey","bazKey", "fooKey"]
        end
      end

    end

    context "after .insert a new row with values as a hash" do
      before(:each) do
        dict.insert "bazKey", { "v1" => "bazV1", "v2" => "bazV2" }
      end

      it "the table has the right number of rows" do
        expect(dict.table.length).to be 3
      end

      it "the last row of the table has the values array" do
        expect(dict.table[2].fields).to eq ["bazKey", "bazV1", "bazV2"]
      end

      it "the last row of the table has the values hash" do
        expect(dict.table[2].to_hash).to eq "key" => "bazKey", "v1" => "bazV1", "v2" => "bazV2"
      end

      context "after .reload" do
        before(:each){ dict.reload }
        it "the table has the right number of rows" do
          expect(dict.table.length).to be 3
        end
      end

    end

    context "after .insert a row whose key matches an existing key" do
      before(:each) do
        dict.insert "fookey", { "v1" => "FOOV1", "v2" => "FOOV2" }
      end

      it "the table has the right number of rows" do
        expect(dict.table.length).to be 2
      end

      it "the last row of the table has the values array" do
        expect(dict.table[0].fields).to eq ["fookey", "FOOV1", "FOOV2"]
      end

      context "after .reload" do
        before(:each){ dict.reload }
        it "the table has the right number of rows" do
          expect(dict.table.length).to be 2
        end
        it "the table has right sorted keys" do
          expect(dict.table.map {|r| r[0]}).to eq ["barKey","fookey"]
        end
      end

    end


  end

end