require './passenger'
require 'csv'

foo = CSV.read('train.csv')
headers = foo.shift

bar = foo.map{|x| Passenger.new(x)}


headers = ["pclass", "name", "sex", "age", "sibsp", "parch", "ticket", "fare", "cabin", "embarked"].map(&:intern)
headers = ["pclass", "sex", "age", 'sibsp', 'parch', "embarked", "cabin"].map(&:intern)

puts 'total passengers'
puts total_passengers = bar.count



bats = headers.permutation(2).to_a



headers.each do |header|
  puts header
  values = bar.map(&header).uniq.sort
  values.each do |val|
    puts "\t" << val.to_s
    cow = bar.select{|x| x.send(header) == val}
    puts "\t\t" << cow.count.to_s <<  " people had #{val} for #{header}"
    puts "\t\t" << (cow.select{|x| x.survived?}.count / cow.count.to_f).round(3).to_s << " of those survived"
    puts "\t\t" << cow.select{|x| x.survived?}.count.to_s << " out of " << cow.count.to_s << "\n"

  end
end



puts '_______________'

bats.each do |bat|
  puts "by " << bat.join(", ")
  values = bar.map{|x| x.gimme(bat)}.uniq
  values.each do |val|
    cow = bar.select{|x| x.send(:gimme, bat) == val}
    unless cow.count < 10
      puts "\t" << val.join(", ")
      puts "\t\t" << cow.count.to_s <<  " people had #{val} for #{bat}"
      puts "\t\t" << (cow.select{|x| x.survived?}.count / cow.count.to_f).round(3).to_s << " of those survived"
      puts "\t\t" << cow.select{|x| x.survived?}.count.to_s << " out of " << cow.count.to_s << "\n"
    end
  end

end
