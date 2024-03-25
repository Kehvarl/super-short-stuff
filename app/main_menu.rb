class MainMenu
  TEXT_COLOR = {r:255, g:255, b:255}.freeze
  HIGHLIGHT_COLOR = {r:192, g:192, b:255}.freeze

  BANNER_COLORS = [
    [{r: 255, g: 0, b:0}, {r: 192, g: 0, b:0}, {r: 128, g: 0, b:0}, {r: 64, g: 0, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 128, b:0}, {r: 192, g: 64, b:0}, {r: 128, g: 32, b:0}, {r: 64, g: 16, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 255, b:0}, {r: 192, g: 192, b:0}, {r: 128, g: 128, b:0}, {r: 64, g: 64, b:0}, {r: 0, g: 0, b:0}],
    [{r: 255, g: 255, b:255}, {r: 192, g: 192, b:192}, {r: 128, g: 128, b:128}, {r: 64, g: 64, b:64}, {r: 32, g: 32, b:32}],
  ].freeze

  def initialize args
    @frame = 0
    @frame_v = 1
    @frame_max = 3
    @frame_delay = 10

    @menu = ["New Game", "Options", "Exit"]
    @selected_index = 0
  end

  def tick args

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
      @selected_index = [0, @selected_index -1].max
    elsif args.inputs.keyboard.key_down.down
      @selected_index = [@selected_index + 1, @menu.size() -1].min

      # Keybard: Allow direct select of an entry by number 1-9
    elsif args.inputs.keyboard.key_down.one
      @selected_index = 0
    elsif args.inputs.keyboard.key_down.two
      if @menu.size() > 1
        @selected_index = 1
      else
        @selected_index = @menu.size() -1
      end
    elsif args.inputs.keyboard.key_down.three
      if @menu.size() > 2
        @selected_index = 2
      else
        @selected_index = @menu.size() -1
      end
    elsif args.inputs.keyboard.key_down.four
      if @menu.size() > 3
        @selected_index = 3
      else
        @selected_index = @menu.size() -1
      end
    elsif args.inputs.keyboard.key_down.five
      if @menu.size() > 4
        @selected_index = 4
      else
        @selected_index = @menu.size() -1
      end
    elsif args.inputs.keyboard.key_down.six
      if @menu.size() > 5
        @selected_index = 5
      else
        @selected_index = @menu.size() -1
      end
    elsif args.inputs.keyboard.key_down.seven
      if @menu.size() > 6
        @selected_index = 6
      else
        @selected_index = @menu.size() -1
      end
    elsif args.inputs.keyboard.key_down.eight
      if @menu.size() > 7
        @selected_index = 7
      else
        @selected_index = @menu.size() -1
      end
    elsif args.inputs.keyboard.key_down.nine
      if @menu.size() > 8
        @selected_index = 8
      else
        @selected_index = @menu.size() -1
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
      out << {x:540, y:500 - (index * 30), text: "#{index+1}: #{@menu[index]}", **color}.label!

      # Maybe animate some background stuff
    end
    out
  end
end
