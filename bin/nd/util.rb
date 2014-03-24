module Nd
  def self.parse_date(d,relative_date=nil)
    relative_date ||= Date.today
    #Accept dates

    formats = ["%Y_%m_%d","%Y/%m/%d","%Y-%m-%d","%Y%m%d","%m/%d/%Y","%m-%d-%Y"]
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
        date = Date.new(relative_date.year,mday.month,mday.day)
        if date - relative_date > 180
          date = Date.new(relative_date.year-1,mday.month,mday.day)
        elsif relative_date - date > 180
          date = Date.new(relative_date.year+1,mday.month,mday.day)
        end
        return date
      rescue
      end
    end

    nil
  end
end