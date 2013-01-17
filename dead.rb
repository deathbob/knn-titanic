require './passenger'
require 'csv'
require 'gruff'
require 'debugger'

foo = CSV.read('train.csv')
headers = foo.shift

passengers = foo.map{|x| Passenger.new(Hash[headers.zip(x)])}
puts 'total passengers'
puts total_passengers = passengers.count

live, dead = passengers.partition{|x| x.survived?}
puts "live " + live.count.to_s
puts "dead " + dead.count.to_s
