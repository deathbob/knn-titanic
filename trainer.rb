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





headers = ["sex", "pclass", "fare", 'sibsp', "age", 'parch', "embarked" ].map(&:intern)
k = 10
n = 100
s = headers.count
max_k = 14

best = [0, nil]

# [:age].each do |h|
#   puts h
#   puts passengers.select{|x| x.send(h) == nil}.sort{|a,b| a.last_name <=> b.last_name}.map(&:inspect)
# end

# puts passengers.map{|x| x.fare.to_f - x.age.to_f}.inspect

# floppers = passengers.select{|x| x.age.to_f > 0}.sort{|a,b| a.age.to_f <=> b.age.to_f}

# g_live = Gruff::Line.new(1200)
# g_live.title = 'age vs fare'
# g_live.data(:age,  floppers.map{|x| x.age.to_f})
# g_live.data(:fare, floppers.map{|x| x.normalized_fare.to_f})
# g_live.write('pngs/' + g_live.title + ".png")

# fail 'you shall not pass'

profile = false
if profile
  require 'ruby-prof'
end

Kernel.trap('INT') do
  puts
  puts '*' * 80
  puts best.inspect
  puts '*' * 80

  puts 'v' * 80
  puts best_specificity.inspect
  puts '^' * 80


  Kernel.exit
end

best_specificity = [0, nil]
best_recall = [0, nil]
best_accuracy = [0, nil]
best_f_one = [0, nil]
best_mcc = [0,nil]


(2..s).each do |num|
  headers.combination(num).each do |heads|
    puts heads.inspect
    (2..max_k).each do |this_k|

      if profile
        RubyProf.start
      end
      passengers.each do |user|
        tommy = passengers.sort_by{|x| user.distance_to(x, heads)}.reject{|x| x == user}.take(this_k)
        user.predicted = (tommy.map{|x| x.survived? == true ? 1 : 0}.reduce(:+) / this_k.to_f).round
      end

      right, wrong = passengers.partition{|x| x.predicted.to_s == x.survived}
      percentage = (right.count / passengers.count.to_f)
      percent_wrong = (1.0 - percentage) * 100
      print "\t k=", this_k, " percent_wrong=", percent_wrong, "\n"


      true_positive, false_positive = passengers.select{|x| x.predicted == 1}.partition{|x| x.predicted.to_s == x.survived}
      true_negative, false_negative = passengers.select{|x| x.predicted == 0}.partition{|x| x.predicted.to_s == x.survived}


      tp = true_positive.count
      fp = false_positive.count
      tn = true_negative.count
      fn = false_negative.count
      # puts 'right ' + right.count.to_s
      # puts 'wrong ' + wrong.count.to_s
      # puts 'percentage ' + percentage.to_s
      precision = tp / (tp + fp).to_f
      recall =    tp / (tp + fn).to_f
      accuracy = (tp + tn) / passengers.count.to_f
      specificity = (tn) / (tn + fp).to_f

      f_one_score = 2 * ((precision * recall) / (precision + recall))
      numer = (tp * tn) - (fp * fn)
      denom = (tp + fp) * (tp + fn) * (tn + fp) * (tn + fn)
      if denom.zero?
        denom = 1.0
      else
        denom = Math.sqrt(denom)
      end
      mcc = matthews_correlation_coefficient = numer / denom

      puts "\t\t Precision: #{precision}"
      puts "\t\t Recall: #{recall}"
      puts "\t\t Accuracy: #{accuracy}"
      puts "\t\t Specificity: #{specificity}"
      puts "\t\t F1 score: #{f_one_score}"
      puts "\t\t Matthews Correlation Coefficient: #{mcc}"



      if best_specificity[0] < specificity
        best_specificity[0] = specificity
        best_specificity[1] = heads
        best_specificity[2] = this_k
        puts ' ------------------------------------------------------- ' + heads.join(', ') + " k=" + best_specificity[2].to_s + ' takes the specificity lead!'

      end

      if best[0] < mcc
        best[0] = mcc
        best[1] = heads
        best[2] = this_k
        puts ' ------------------------------------------------------- ' + heads.join(', ') + " k=" + best[2].to_s + ' takes the mcc lead!'
      end

      if profile
        prof_result = RubyProf.stop
        printer = RubyProf::FlatPrinter.new(prof_result)
        printer.print(STDOUT)
      end

    end
  end
end

puts
puts '*' * 80
puts best.inspect
puts '*' * 80

puts 'v' * 80
puts best_specificity.inspect
puts '^' * 80

fail 'you shall not pass'






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
  values = passengers.map(&header).uniq.sort
  values.each do |val|
    puts "\t" << val.to_s
    cow = passengers.select{|x| x.send(header) == val}
    puts "\t\t" << cow.count.to_s <<  " people had #{val} for #{header}"
    puts "\t\t" << (cow.select{|x| x.survived?}.count / cow.count.to_f).round(3).to_s << " of those survived"
    puts "\t\t" << cow.select{|x| x.survived?}.count.to_s << " out of " << cow.count.to_s << "\n"

  end
end

#__END__

puts '__________________________________________________________________________________________________________________________________________________________'



bats = headers.combination(2).to_a

bats.each do |bat|
  puts "by " << bat.join(", ")
  values = passengers.map{|x| x.gimme(bat)}.uniq
  values.each do |val|

    cow = passengers.select{|x| x.send(:gimme, bat) == val}
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
