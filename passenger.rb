
class Passenger

  @@user_distances = {}
  @@count = 0

  NO_VAL= -1


  class<< self
    def headers
    @headers ||= ["survived", "pclass", "name", "sex", "age", "sibsp", "parch", "ticket", "fare", "cabin", "embarked"]
    end
    def headers=(array)
      @headers = array
    end
  end

  attr_accessor :raw_attrs, :arr, :survived, :pclass, :name, :sex, :age, :sibsp, :parch, :ticket, :fare, :cabin, :embarked, :predicted
  attr_accessor :my_key

  def initialize(hash)
    @raw_attrs = hash
    hash.each do |k, v|
      send("#{k}=", v)
    end
    @answers = {}
  end

  def pclass=(val)
    @pclass = val.to_i
    @pclass = NO_VAL unless val
  end

  def sibsp=(val)
    @sibsp = val.to_i
    @sibsp = NO_VAL unless val
  end

  def parch=(val)
    @parch = val.to_i
    @parch = NO_VAL unless val
  end

  def survived?
    survived == '1'
  end

  def fare=(val)
    @fare = val.to_f
    @fare = NO_VAL unless val
  end


  def age=(val)
    @age = val.to_f
    @age = NO_VAL unless val
  end

  def sex=(val)
    @sex = case val
           when "male"
             0
           when 'female'
             1
           end
    @sex = NO_VAL unless val
  end

  def embarked=(val)
    @embarked = case val
                when 'Q'
                  0
                when 'C'
                  1
                when 'S'
                  2
                end
    @embarked = NO_VAL unless val
  end

  def cabin=(val)
    @cabin = val
  end








  def normalized_fare
    case @fare.to_f
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

  def normalized_age
    case @age
    when 1..10
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



  def gimme(ar)
    # return @answers[ar] if @answers[ar]
    # @answers[ar] = ar.map{|k| send(k) }
    ar.map{|k| send(k) }
  end


  def distance_to(user, arr)
    mine = gimme(arr)
    theirs = user.gimme(arr)
    begin
      sum_of_squares = mine.zip(theirs).map{|x| x[0] - x[1]}.map{|x| x ** 2}.reduce(:+)
    rescue
      debugger
    end
    ans = Math.sqrt(sum_of_squares)
  end

  def predicted=(val)
    if [true, '1', 1].include?(val)
      @predicted = 1
    else
      @predicted = 0
    end
  end

  def last_name
    name.split(',').first
  end

  def to_s
    attrs = [:cabin, :age, :ticket, :last_name, :predicted, :survived, :embarked, :sex, :pclass, :sibsp, :fare, :parch, :cabin_letter, :cabin_number].inject({}) do |memo, x|
      memo[x] = self.send(x)
      memo
    end
    puts attrs.sort.inspect
#    puts raw_attrs.sort.inspect
  end

end
