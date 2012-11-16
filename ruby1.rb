require './passenger'
require 'csv'
require 'gruff'
require 'debugger'

foo = CSV.read('train.csv')
headers = foo.shift

bar = foo.map{|x| Passenger.new(x)}
live, dead = bar.partition{|x| x.survived?}

headers = ["embarked", "sex", "pclass", "age", 'sibsp', 'parch', "cabin", "fare", "cabin_number"].map(&:intern)

puts 'total passengers'
puts total_passengers = bar.count

bar.each{|x| x.precompute_gimme(headers) }

puts bar.map{|x| x.cabin_number}.uniq.compact.inspect

bats = headers.combination(2).to_a

puts "live " + live.count.to_s
puts "dead " + dead.count.to_s

k = 3
n = 100
s = headers.count

best = [0, nil]

if profile = false
  require 'ruby-prof'
end

(2..3).each do |num|
  headers.combination(num).each do |heads|
    puts heads.inspect

    if profile
      RubyProf.start
    end
    bar.each_with_index do |user, idx|
      tommy = bar.sort_by{|x| user.distance_to(x, heads)}.take(k)
      user.predicted = (tommy.reject{|x| x == user}.map{|x| x.survived? == true ? 1 : 0}.reduce(:+) / k.to_f).round
    end

    right, wrong = bar.partition{|x| x.predicted.to_s == x.survived}


    puts 'right ' + right.count.to_s
    puts 'wrong ' + wrong.count.to_s
    percentage = (right.count / bar.count.to_f)
    puts 'percentage ' + percentage.to_s
    if best[0] < percentage
      best[0] = percentage
      best[1] = heads
      puts ' ---------------------------- ' + heads.join(', ') + ' takes the lead!'
    end

    if profile
      prof_result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(prof_result)
      printer.print(STDOUT)
    end
    raise 'round 1'
  end
end


# # gruff stuff
# bats.each do |bat|
#   puts "by " << bat.join(", ")

#   g_live = Gruff::Scatter.new(800)
#   g_live.title = bat.join(", ") << ' live'
#   g_live.data(:control, [0, 3], [0, 3])
#   live_xs = live.map{|x| x.send(:gimme, bat)[0].to_i }
#   live_ys = live.map{|x| x.send(:gimme, bat)[1].to_i }
#   g_live.data(:live, live_xs, live_ys)
#   g_live.write('pngs/' + g_live.title + ".png")

#   g_dead = Gruff::Scatter.new(800)
#   g_dead.title = bat.join(", ") << ' dead'
#   g_dead.data(:control, [0, 3], [0, 3])
#   dead_xs = dead.map{|x| x.send(:gimme, bat)[0].to_i }
#   dead_ys = dead.map{|x| x.send(:gimme, bat)[1].to_i }
#   g_dead.data(:dead, dead_xs, dead_ys)
#   g_dead.write('pngs/' + g_dead.title + ".png")

# end
# __END__


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

#__END__

puts '__________________________________________________________________________________________________________________________________________________________'

bats.each do |bat|
  puts "by " << bat.join(", ")
  values = bar.map{|x| x.gimme(bat)}.uniq
  values.each do |val|

    cow = bar.select{|x| x.send(:gimme, bat) == val}
    live, dead = cow.partition{|x| x.survived?}
    unless cow.count < 10

      # g = Gruff::Scatter.new(800)
      # g.title = bat.zip(val).join(", ")
      # g.data(:control, [0, 10], [0, 10])
      # live_xs = live.map{|x| x.send(:gimme, bat)[0].to_i}
      # puts live_xs.inspect
      # live_ys = live.map{|x| x.send(:gimme, bat)[1].to_i}
      # g.data(:live, live_xs, live_ys)
      # dead_xs = dead.map{|x| x.send(:gimme, bat)[0].to_i}
      # dead_ys = dead.map{|x| x.send(:gimme, bat)[1].to_i}
      # g.data(:dead, dead_xs, dead_ys)
      # g.write('pngs/' + g.title + ".png")
      percentage = (live.count / cow.count.to_f).round(3)

      if percentage > 0.7 || percentage < 0.3
        puts "\t\t" << cow.count.to_s <<  " people had #{val} for #{bat}"
        puts "\t\t" << percentage.to_s << " of those survived"
        puts "\t\t" << live.count.to_s << " out of " << cow.count.to_s << "\n"
      end
    end
  end

end
