
class Passenger
  attr_accessor :raw_attrs, :arr, :survived, :pclass, :name, :sex, :age, :sibsp, :parch, :ticket, :fare, :cabin, :embarked

  def initialize(arr)
    @arr = arr
    @raw_attrs = Hash[headers.zip(arr)]
    @raw_attrs.each do |k, v|
      send("#{k}=", v)
    end
  end

  def headers
    headers = ["survived", "pclass", "name", "sex", "age", "sibsp", "parch", "ticket", "fare", "cabin", "embarked"]
  end

  def survived?
    survived == '1'
  end

  def age=(val)
    @age = case val.to_i
           when 0..10
             0
           when 11..20
             1
           when 21..30
             2
           when 31..40
             3
           when 41..50
             4
           when 51..60
             5
           when 61..70
             6
           when 71..80
             7
           when 81..90
             8
           when 90..100
             9
           when 101..1000
             10
           else
             -1
           end
  end

  def cabin=(val)
    @cabin = case val
             when /a/i
               0
             when /b/i
               1
             when /c/i
               2
             when /d/i
               3
             when /e/i
               4
             when /f/i
               5
             when /g/i
               6
             else
               -1
             end
  end

  def cabin_letter
    @raw_attrs[:cabin].match(/\D/)[0]
  end

  def cabin_number
    @raw_attrs[:cabin].match(/\d+/)[0]
  end

  def sex=(val)
    @sex = case val
           when "male"
             0
           when 'female'
             1
           else
             -1
           end
  end

  def embarked=(val)
    @embarked = case val
                when 'Q'
                  0
                when 'C'
                  1
                when 'S'
                  2
                else
                  -1
                end
  end

  def gimme(ar)
    ar.map do |k|
      send(k)
    end
  end

end
