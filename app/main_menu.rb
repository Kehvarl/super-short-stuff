class MainMenu
  TEXT_COLOR = {r:255, g:255, b:255}.freeze
  HIGHLIGHT_COLOR = {r:192, g:192, b:255}.freeze

  BANNER_COLORS = [
    [{r: 255, g: 0, b:0}, {r: 192, g: 0, b:0}, {r: 128, g: 0, b:0}, {r: 64, g: 0, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 128, b:0}, {r: 192, g: 64, b:0}, {r: 128, g: 32, b:0}, {r: 64, g: 16, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 255, b:0}, {r: 192, g: 192, b:0}, {r: 128, g: 128, b:0}, {r: 64, g: 64, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 255, b:255}, {r: 192, g: 192, b:192}, {r: 128, g: 128, b:128}, {r: 64, g: 64, b:64}, {r: 32, g: 32, b:32}],
  ].freeze

  NUMBERS = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'].freeze

  attr_accessor :message, :select_event, :selected_index, :menu

  def initialize args
    @frame = 0
    @frame_v = 1
    @frame_max = 3
    @frame_delay = 10

    @menu = [["Snake", :newgame_snake],
             ["LindWurm", :newgame_lindwurm],
             ["Leap", :newgame_leap],
             ["Options", :options], ["Exit", :exit]]
    @selected_index = 0
    @select_event = false
    @message = nil
  end

  def tick args
    @select_event = false

    @frame_delay -=1
    if @frame_delay <= 0
      @frame += @frame_v
      if @frame > @frame_max or @frame < 0
        @frame_v = -@frame_v
        @frame += @frame_v
      end
      @frame_delay = 10
    end

    # Track Selected Menu Item
    # Change select with mouse or keyboard
      # Keyboard: Track selected index and increment/decrement
      if args.inputs.keyboard.key_down.up
        @selected_index = [0, @selected_index - 1].max
      elsif args.inputs.keyboard.key_down.down
        @selected_index = [@selected_index + 1, @menu.size() - 1].min
      elsif args.inputs.keyboard.key_down.enter
        @select_event = true
        @message = @menu[@selected_index][1]
      else
        # Iterate over keys one through nine
        (0..9).each do |num|
          if args.inputs.keyboard.key_down.send(:"#{NUMBERS[num]}")
            index = num - 1
            @selected_index = [@menu.size() - 1, index].min
            break
          end
        end
      end
      # Mouse:  On mouse over label, select index
    # On click/enter do something
  end

  def render
    out = []
    # Draw Banner
    out << {x: 500, y: 650, text: "Super Short Stuff", size_enum: 4, **BANNER_COLORS[0][@frame]}.label!
    out << {x: 507, y: 647, text: "Super Short Stuff", size_enum: 3, **BANNER_COLORS[1][@frame]}.label!
    out << {x: 514, y: 644, text: "Super Short Stuff", size_enum: 2, **BANNER_COLORS[2][@frame]}.label!
    out << {x: 521, y: 641, text: "Super Short Stuff", size_enum: 1, **BANNER_COLORS[3][@frame]}.label!

    # Draw Menu Items
    @menu.each_with_index do |item, index|
      color = TEXT_COLOR
      if index == @selected_index
        color = HIGHLIGHT_COLOR
      end
      out << {x:540, y:500 - (index * 30), text: "#{index+1}: #{@menu[index][0]}", **color}.label!

      # Maybe animate some background stuff
    end
    out
  end
end
