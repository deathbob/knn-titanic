require 'gruff'


    g = Gruff::Scatter.new(800)
    g.title = "asdf"
    g.data(:dead, [1,2], [3,4])
    g.data(:ctrl, [0], [0])
    g.write('pngs/' + g.title + '.png')
