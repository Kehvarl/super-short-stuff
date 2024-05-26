require('app/game_map.rb')
class LindWurm < Game

  # TODO: Setup Game Map
  # TODO: scrolling map
    # Draw map on RT
    # Viewport into RT centered on character
  # TODO: platforms
  # TODO: climbing
  # TODO: gravity
  # TODO: collectables
  # TODO: exits
  # TODO: HUD
  # TODO: scoring
  # TODO: Enemies
  # TODO: damage

  def initialize args
    @score = 0
    @playfield = Game_Map.new()
    @playfield_model = [[{x:0,y:0,w:1,h:(720/16),block:true}, {x:0,y:0,w:(1280/16),h:1,block:true}],
                       ]
    @playfield.build_playfield(@playfield_model)
    @playfield.draw_rt(args)

    @snake_length = 3
    @snake_direction = [1,0,0]
    @snake_pd = 0
    @snake = [{x:39,y:1,d:0,nd:0}, {x:40,y:1,d:0,nd:0}, {x:41,y:1,d:0,nd:0}]

    @viewport = [0,0,1280,720]

  end

  def tick args
  end

  def draw_snake
    out = []
    @snake.each do |s|
      #puts(s)
      if s == @snake[-1]
        out << {x: s.x*16, y: s.y*16, w: 16, h: 16, angle: s.d, path: "sprites/circle/green.png"}.sprite!
      else
        out << {x: s.x*16, y: s.y*16, w: 16, h: 16, angle: s.nd, path: "sprites/square/green.png"}.sprite!
      end
      if s.x == 0
        if s == @snake[-1]
          out << {x:79*16, y:s.y*16, w:16, h:16, angle:s.d, path:"sprites/circle/green.png"}.sprite!
        else
          out << {x:79*16, y:s.y*16, w:16, h:16, angle:s.nd, path:"sprites/square/green.png"}.sprite!
        end
      end
      if s.y == 0
        if s == @snake[-1]
          out << {x:s.x*16, y:44*16, w:16, h:16, angle:s.d, path:"sprites/circle/green.png"}.sprite!
        else
          out << {x:s.x*16, y:44*16, w:16, h:16, angle:s.nd, path:"sprites/square/green.png"}.sprite!
        end
      end
    end
    out
  end

  def render
    out = []
    out << @playfield.render()
    out << draw_snake
    out
  end
end
