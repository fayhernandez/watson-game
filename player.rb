class Player

  attr_reader :score

  def initialize(window)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @beep = Gosu::Sample.new(window, "media/Beep.wav")
    @x = @y = @x_vel = @y_vel = @angle = 0.0
    @score = 0
  end

  def warp (x, y) 
    @x, @y = x, y
  end

  def turn_left
    @angle -= 4.5
  end

  def turn_right
    @angle += 4.5
  end

  def accelerate
    @x_vel += Gosu::offset_x(@angle, 0.5)
    @y_vel += Gosu::offset_y(@angle, 0.5)
  end

  def move
    @x += @x_vel
    @y += @y_vel
    @x %= 640
    @y %= 480

    @x_vel *= 0.95
    @y_vel *= 0.95
  end

  def draw
   @image.draw_rot(@x, @y, 1, @angle)
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 35 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end

