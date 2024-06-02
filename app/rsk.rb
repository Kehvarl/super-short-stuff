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

class Rsk < Game
  def initialize args={}
    @robot = {x:632, y:352, w:16, h:32, angle:0}
    @entities = []
  end

  def tick args
    super(args)

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
    out = {**@robot, path:"sprites/circle/indigo.png"}.sprite

    out
  end
end
