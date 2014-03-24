require_relative "../spec_helper.rb"

DATE = Date.new 2010, 3, 23

describe ".date_parser" do
  context "short format with (current year) month, day" do

    let(:date){ Date.new(DATE.year,6,20) }

    it "6/20" do
       expect(Nd.parse_date "6/20",DATE).to eq date
    end

    it "06/20" do
       expect(Nd.parse_date "06/20",DATE).to eq date
    end

    it "06-20" do
       expect(Nd.parse_date "06-20",DATE).to eq date
    end

    it "06_20" do
       expect(Nd.parse_date "06_20",DATE).to eq date
    end

  end


  context "short format with (previous year) month, day" do

    let(:date){ Date.new(DATE.year-1,12,20) }

    it "12/20" do
       expect(Nd.parse_date "12/20",DATE).to eq date
    end

    it "12/20" do
       expect(Nd.parse_date "12/20",DATE).to eq date
    end

    it "12-20" do
       expect(Nd.parse_date "12-20",DATE).to eq date
    end

    it "12_20" do
       expect(Nd.parse_date "12_20",DATE).to eq date
    end

  end


  context "long format with year, month, day" do
    let(:date){ Date.new(2001,6,20) }

    it "2001/6/20" do
       expect(Nd.parse_date "2001/6/20").to eq date
    end

    it "2001/06/20" do
       expect(Nd.parse_date "2001/06/20").to eq date
    end

    it "2001-06-20" do
       expect(Nd.parse_date "2001-06-20").to eq date
    end

    it "2001_06_20" do
       expect(Nd.parse_date "2001_06_20").to eq date
    end

    it "2001_6_20" do
       expect(Nd.parse_date "2001_6_20").to eq date
    end

    it "20010620" do
       expect(Nd.parse_date "20010620").to eq date
    end

  end

  context "long format with month, day, year" do
    let(:date){ Date.new(2001,6,20) }

    it "6/20/2001" do
       expect(Nd.parse_date "6/20/2001").to eq date
    end

    it "06/20/2001" do
       expect(Nd.parse_date "06/20/2001").to eq date
    end

    it "06-20-200" do
       expect(Nd.parse_date "06-20-2001").to eq date
    end

  end

end