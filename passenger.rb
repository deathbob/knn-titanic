
class Passenger

  @@user_distances = {}
  @@count = 0

  NO_VAL= -1



  attr_accessor :raw_attrs, :arr, :survived, :pclass, :name, :sex, :age, :sibsp, :parch, :ticket, :fare, :cabin, :embarked, :predicted
  attr_accessor :my_key

  def initialize(arr)
    @arr = arr
    @raw_attrs = Hash[headers.zip(arr)]
    @raw_attrs.each do |k, v|
      send("#{k}=", v)
    end
    @answers = {}
  end

  def pclass=(val)
    @pclass = val.to_i
  end

  def sibsp=(val)
    @sibsp = val.to_i
  end

  def parch=(val)
    @parch = val.to_i
  end

  def headers
    headers = ["survived", "pclass", "name", "sex", "age", "sibsp", "parch", "ticket", "fare", "cabin", "embarked"]
  end

  def survived?
    survived == '1'
  end

  def fare=(val)
    return NO_VAL unless val
    @fare = case val.to_i
            when 0..10
              1
            when 10..20
              2
            when 20..30
              3
            when 30..40
              4
            when 40..50
              5
            when 50..60
              6
            when 60..70
              7
            when 70..80
              8
            when 80..90
              9
            when 90..100
              10
            when 100..200
              12
            when 200..1000
              15
            end
  end


  def age=(val)
    @age = case val.to_i
           when 0..10
             0
           when 10..20
             1
           when 20..30
             2
           when 30..40
             3
           when 40..50
             4
           when 50..60
             5
           when 60..70
             6
           when 70..80
             7
           when 80..90
             8
           when 90..100
             9
           when 100..1000
             10
           else
             NO_VAL
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
               NO_VAL
             end
  end

  def cabin_letter
    @cabin_letter ||= if @raw_attrs['cabin']
            foo = @raw_attrs['cabin'].match(/\D/)
            foo[0] if foo
          end
  end

  def cabin_number
    return @cabin_number if @cabin_number
    bar = if @raw_attrs['cabin']
            foo = @raw_attrs['cabin'].match(/\d+/)
            foo[0] if foo
          end

    return @cabin_number = NO_VAL unless bar
    @cabin_number = case bar.to_i
    when 0..10
      0
    when 10..20
      1
    when 20..30
      2
    when 30..40
      3
    when 40..50
      4
    when 50..60
      5
    when 60..70
      6
    when 70..80
      7
    when 80..90
      8
    when 90..100
      9
    when 100..1000
      10
    else
      NO_VAL
    end

  end


  def sex=(val)
    @sex = case val
           when "male"
             0
           when 'female'
             1
           else
             NO_VAL
           end
  end

  def embarked=(val)
    @embarked = case val
                when 'Q'
                  1
                when 'C'
                  2
                when 'S'
                  3
                else
                  NO_VAL
                end
  end

  def gimme(ar)
#    return @answers[ar] if @answers[ar]

#    @answers[ar] = ar.map{|k| send(k) }
    ar.map{|k| send(k) }
  end

  def precompute_gimme(ar)
    # (2..ar.count).each do |int|
    #   ar.combination(int).to_a.each do |foo|
    #     @answers[foo] = foo.map{|x| send(x) }
    #   end
    # end
  end

  def distance_to(user, arr)
    mine = gimme(arr)
    theirs = user.gimme(arr)

    # key = mine.join.to_i
    # t_k = theirs.join.to_i
    # if @@user_distances[arr].nil?
    #   @@user_distances[arr] = []
    # end
    # if @@user_distances[arr][key].nil?
    #   @@user_distances[arr][key] = []
    # end
    # if @@user_distances[arr][key][t_k]
    #   return @@user_distances[arr][key][t_k]
    # end

    sum_of_squares = mine.zip(theirs).map{|x| x[0] - x[1]}.map{|x| x ** 2}.reduce(:+)
    ans = Math.sqrt(sum_of_squares)

#    @@user_distances[arr][key][t_k] = ans
  end

  def predicted=(val)
    if [true, '1', 1].include?(val)
      @predicted = 1
    else
      @predicted = 0
    end
  end

end
