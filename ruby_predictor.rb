require './passenger'
require 'csv'
require 'debugger'

train = CSV.read('train.csv')
test = CSV.read('test.csv')


train_headers = train.shift
test_headers = test.shift

training_set = train.map{|x| Passenger.new(Hash[train_headers.zip(x)])}
test_set = test.map{|x| Passenger.new(Hash[test_headers.zip(x)])}



CSV.open("for_processing_train.csv", 'wb') do |csv|
  training_set.each do |ts|
    csv << [ts.sex, ts.pclass, ts.fare, ts.survived]
  end
end

CSV.open("for_processing_test.csv", 'wb') do |csv|
  training_set.each do |ts|
    csv << [ts.sex, ts.pclass, ts.fare, ts.survived]
  end
end
# also
#heads = %w[embarked sex pclass sibsp parch]# 0.76555, 763
#heads = %w[sex pclass fare] # 0.77990, 331
#heads = %w[sex pclass fare embarked] # 0.75120, 380
#heads = %w[sex pclass] # 0.75598, 380 k = 13
heads = %w[embarked sex pclass sibsp parch]# 0.76555, 763
k = 9

test_set.each do |user|
  tommy = training_set.sort_by{|x| user.distance_to(x, heads)}.take(k)
  user.predicted = (tommy.map{|x| x.survived? == true ? 1 : 0}.reduce(:+) / k.to_f).round
end

File.open("my_answers.csv", 'w+') do |f|
  test_set.each do |p|
    f.puts p.predicted
  end
end
