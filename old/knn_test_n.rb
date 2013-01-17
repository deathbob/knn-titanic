require './passenger'
require 'csv'
require 'debugger'

foo = CSV.read('train.csv')
headers = foo.shift

passengers = foo.map{|x| Passenger.new(Hash[headers.zip(x)])}
live, dead = passengers.partition{|x| x.survived?}

puts 'total passengers'
puts total_passengers = passengers.count

puts "live " + live.count.to_s
puts "dead " + dead.count.to_s

max_k = 30
n = 100

best = [0, nil, 0]

Kernel.trap('INT') do
  puts
  puts '*' * 80
  puts best.inspect
  puts '*' * 80

  Kernel.exit
end

heads = ['fare', 'pclass', 'sex']
puts heads.inspect

(2..max_k).each do |num|

  passengers.each do |user|
    tommy = passengers.sort_by{|x| user.distance_to(x, heads)}.reject{|x| x == user}.take(num)
    user.predicted = (tommy.map{|x| x.survived? == true ? 1 : 0}.reduce(:+) / num.to_f).round
  end

  right, wrong = passengers.partition{|x| x.predicted.to_s == x.survived}
  percentage = (right.count / passengers.count.to_f)

  # puts 'right ' + right.count.to_s
  # puts 'wrong ' + wrong.count.to_s
  # puts 'percentage ' + percentage.to_s

  percent_wrong = (1.0 - percentage) * 100
  print "\t", num, " ", percent_wrong, "\n"

  if best[0] < percentage
    best[0] = percentage
    best[1] = heads
    best[2] = num
    puts ' ---------------------------- ' + heads.join(', ') + " k=" + best[2].to_s + ' takes the lead!'
  end
end

puts
puts '*' * 80
puts best.inspect
puts '*' * 80
