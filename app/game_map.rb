class Game_Map
  attr_accessor :w, :h, :grid, :viewport, :check_tile, :build_playfield, :draw_rt, :render
  def initialize
    @w = 80
    @h = 120
    @tile_size = 16
    @background = {r:0,g:64,b:196,a:255}
    @grid = []
    @viewport = {x:0,y:0,w:80,h:45}
  end

  def check_tile(x,y,climbing=false,falling=true)
    tile = @grid.select{|g| g.x == x and g.y == y}[0]
    return (climbing and tile.block_climb) or (falling and tile.block_fall)
  end

  def build_playfield(playfield_model)
    playfield_model[0].each do |p|
      (0..p.w-1).each do |pw|
        (0..p.h-1).each do |ph|
          @grid << {x: pw + p.x, y: ph + p.y, block_climb:true, block_fall:true}
        end
      end
    end
  end

  def draw_rt args
    args.outputs[:game_map].width = @w*16
    args.outputs[:game_map].height = @h*16
    args.outputs[:game_map].primitives << {x:0,y:0,w:(@w*16),h:(@h*16),
                                          **@background}.solid!

    args.outputs[:game_map].primitives << draw_playfield
  end

  def draw_playfield
    out = []
    @grid.each do |p|
      out << {x:p.x*16, y:p.y*16, w:16, h:16, path: "sprites/square/gray.png"}.sprite!
      if p.x == 0
        out << {x:79*16, y:p.y*16, w:16, h:16, path: "sprites/square/gray.png"}.sprite!
      end
      #if p.y == 0
      #  out << {x:p.x*16, y:44*16, w:16, h:16, path: "sprites/square/gray.png"}.sprite!
      #end
    end
    out
  end

  def render
    out = []
    out << {x:0,y:0,w:1280,h:720,
            source_x:@viewport.x*16,source_y:@viewport.y*16,
            source_w:@viewport.w*16,source_h:@viewport.h*16,
            path: :game_map }.sprite!
    out
  end

  def serialize
    {w:@w, h:@h, background:@background, grid:@grid, viewport:@viewport}
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end
