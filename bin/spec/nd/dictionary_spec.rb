require_relative "../spec_helper.rb"
require "ostruct"

describe Nd::Dictionary do

  it "DICTIONARY_DIR is correct" do
    expect(Nd::Dictionary::DICTIONARY_DIR).to eq Nd::BUNDLE_PATH + "/Dictionaries"
  end

  describe "best_match" do
    subject(:row){ Nd::Dictionary.best_match(string,rows,min_closeness)}
    let(:min_closeness){ 0 }
    let(:rows) do
      ["foo","bar","baz","foo bar baz"].map {|s| [s]}
    end

    context "when a row matches exactly" do
      let(:string){ "foo" }
      it{ should include string}
    end

    context "when a row matches exactly" do
      let(:string){ "fo" }
      it{ should include "foo"}
    end

    context "with an exact match, except for its case" do
      let(:string){ "FoO" }
      it{ should include "foo"}
    end

    context "when there is a partial match" do
      let(:string){ "foobar" }
      it{ should include "foo bar baz"}
      context "when the matching threshold is very high" do
        let(:min_closeness){ 0.97 }
        it{ should be_nil }
      end
    end

  end

end

describe Nd::Dictionary::Icd9 do

  it{ should respond_to :search }

end