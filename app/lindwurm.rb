
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

  def initialize args={}
    @score = 0
    @playfield = []

    @playfield_model = [[{x:0,y:0,w:1,h:(720/16),block:true}, {x:0,y:0,w:(1280/16),h:1,block:true}],
                       ]
    @snake_length = 3
    @snake_direction = [1,0,0]
    @snake_pd = 0
    @snake = [{x:1,y:1,d:0,nd:0}, {x:2,y:1,d:0,nd:0}, {x:3,y:1,d:0,nd:0}]

    @viewport = [0,0,1280,720]

    build_playfield(0)
  end

  def build_playfield(level=0)
    @playfield_model[level].each do |p|
      (0..p.w-1).each do |pw|
        (0..p.h-1).each do |ph|
          @playfield << {x: pw + p.x, y: ph + p.y}
        end
      end
    end
  end

  def tick args
  end

  def render
    out = []
    out
  end
end
