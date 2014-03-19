require_relative "../spec_helper.rb"
require "ostruct"

describe Nd::Visit do

  it{should respond_to :date}
  it{should respond_to :patient}

  describe ".new_from_struct" do
    subject(:visit){ Nd::Visit.new_from_struct options }
    let(:options){
      options = OpenStruct.new
      options.date = Date.new(2013,11,2)
      options
    }

    its(:date_string){ should eq '2013_11_02'}

  end

end