module Nd
  def self.parse_date(d)
    formats = ["%Y_%m_%d","%Y/%m/%d","%Y-%m-%d","%Y%m%d","%%m_%d_Y","%m/%d/%Y","%m-%d-%Y"]
    formats.each do |f|
      begin
        return Date.strptime(d.to_s,f)
      rescue
      end
    end

    formats = ["%m_%d","%m/%d","%m-%d"]
    formats.each do |f|
      begin
        mday = Date.strptime(d.to_s,f)
        return Date.new(Date.today.year,mday.month,mday.day)
      rescue
      end
    end
    nil
  end
end