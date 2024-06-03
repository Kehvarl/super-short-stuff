require('app/game.rb')

# Spritesheets
# cat
  # 32x32
  # sit, down 4
  # sit, right 4
  # idle lick right 4
  # idle earwash right 4
  # prance right 8
  # leap right 8
  # sleep 4
  # walk right 6
  # pounce 7
  # arch right 8

class Cat
  attr_sprite

  def initialize (x,y)
    @x = x
    @y = y
    @w = 64
    @h = 64
    @path= "sprites/sheets/cat.png"
    @angle= 0
    @tile_x=  0
    @tile_y=  0
    @tile_w= 32
    @tile_h= 32
    @flip_vertically = false
    @flip_horizontally = false

    @current_pose = :idle_lick
    @current_frame = 0
    @frame_duration = 10
    @frame_delay = 10
    @countdown = 0
    @pose_list = {
      sit_down: [0,4,4, [:sit_down, :idle_lick, :idle_sleep]],
      sit_right: [1,4,4, [:sit_right, :idle_lick, :idle_sleep]],
      idle_lick: [2,4,2, [:idle_lick, :idle_ear, :idle_sleep, :arch]],
      idle_ear: [3,4,1, [:idle_lick, :idle_sleep, :arch]],
      prance: [4,8,1, [:sit_down]],
      leap: [5,8,1, [:sit_down]],
      idle_sleep: [6,4,4, [:idle_sleep, :idle_ear, :idle_sleep, :arch]],
      walk: [7,6,1, [:sit_down]],
      pounce: [8,7,1, [:sit_down]],
      arch: [9,8,1, [:sit_down]]
    }
  end

  def tick args
    @frame_duration -= 1
    if @frame_duration <= 0
      @frame_duration = @frame_delay
      @current_frame += 1
      if @current_frame >= @pose_list[@current_pose][1]
        @current_frame = 0
        @countdown -= 1
        if @countdown <= 0
          @current_pose = @pose_list[@current_pose][3].sample()
          @countdown = @pose_list[@current_pose][2]
        end
      end
    end
    @tile_x = @current_frame*32
    @tile_y = @pose_list[@current_pose][0]*32
  end
end

class Rsk < Game
  def initialize args={}
    @robot = {x:632, y:352, w:16, h:32, angle:0}
    @cat = Cat.new(200,100)
    @entities = []
  end

  def tick args
    super(args)

    @cat.tick args

    if args.inputs.keyboard.key_held.up
      @robot.y += 1
      @robot.angle = 90
    elsif args.inputs.keyboard.key_held.down
      @robot.y -= 1
      @robot.angle = 270
    elsif args.inputs.keyboard.key_held.left
      @robot.x -=1
      @robot.angle = 180
    elsif args.inputs.keyboard.key_held.right
      @robot.x += 1
      @robot.angle = 0
    end

  end

  def render
    out = []
    out << {**@robot, path:"sprites/circle/indigo.png"}.sprite!
    out << @cat
    out
  end
end
