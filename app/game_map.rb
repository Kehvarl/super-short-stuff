class Game_Map
  def initialize
    @w = 80
    @h = 120
    @tile_size = 16
    @background = {r:0,g:64,b:196,a:0}
    @grid = {}
    @viewport = {x:0,y:0,w:80,h:45}
  end

  def draw_rt args
    args.outputs[:game_map].width = @w*16
    args.outputs[:game_map].height = @h*16
    args.outputs[:game_map].primitives << {x:0,y:0,w:(@w*16),h:(@h*16)}.solid!
  end

  def render
    out = []
    out << {x:0,y:0,w:1280,h:960,
            source_x:@viewport.x,source_y:@viewport.y,source_w:@viewport.w,source_h:@viewport.h,
            path:game_map}.sprite!
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
