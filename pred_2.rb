require './passenger'
require 'csv'
#require 'gruff'
require 'debugger'

foo = CSV.read('train.csv')
headers = foo.shift

passengers = foo.map{|x| Passenger.new(x)}
live, dead = passengers.partition{|x| x.survived?}

headers = ["embarked", "sex", "pclass", "age", 'sibsp', 'parch', "cabin", "fare", "cabin_number"].map(&:intern)

puts 'total passengers'
puts total_passengers = passengers.count

puts "live " + live.count.to_s
puts "dead " + dead.count.to_s

k = 10
n = 100
s = headers.count

best = [0, nil]
snake = true

profile = false
if profile
  require 'ruby-prof'
end

Kernel.trap('INT') do
  puts
  puts '*' * 80
  puts best.inspect
  puts '*' * 80

  Kernel.exit
end


# headers.each do |header|
#   puts header
#   values = passengers.map(&header).uniq.sort
#   values.each do |val|
#     puts "\t" << val.to_s
#     cow = passengers.select{|x| x.send(header) == val}
#     puts "\t\t" << cow.count.to_s <<  " people had #{val} for #{header}"
#     puts "\t\t" << (cow.select{|x| x.survived?}.count / cow.count.to_f).round(3).to_s << " of those survived"
#     puts "\t\t" << cow.select{|x| x.survived?}.count.to_s << " out of " << cow.count.to_s << "\n"

#   end
# end







#in absence of data just guess they died.

bats = headers.combination(2).to_a



bats.each do |bat|
  puts "by " << bat.join(", ")
  values = passengers.map{|x| x.gimme(bat)}.uniq
  values.each do |val|

    cow = passengers.select{|x| x.send(:gimme, bat) == val}
    live, dead = cow.partition{|x| x.survived?}
    unless cow.count < 10
      percentage = (live.count / cow.count.to_f).round(3)

      if percentage > 0.7 || percentage < 0.3
        puts "\t\t" << cow.count.to_s <<  " people had #{val} for #{bat}"
        puts "\t\t" << percentage.to_s << " of those survived"
        puts "\t\t" << live.count.to_s << " out of " << cow.count.to_s << "\n"
      end
    end
  end

end
