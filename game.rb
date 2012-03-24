require 'gosu'
require './player'
require './star'
require './Zorder'
require './color'

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Watson"

    @background_image = Gosu::Image.new(self, "media/Space.png", true)

    @player = Player.new(self)
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles(self, "media/Star.png", 25, 25, false)
    @stars = Array.new

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @timer = 15 * 60

    @timer_scale = 1.0

    @timer_start_color = Color.new("DFE620")
    @timer_end_color = Color.new("E6202D")
    @timer_current_color = nil
    @timer_current_step = 0.0

  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25 then
      @stars.push(Star.new(@star_anim))
    end
    @timer -= 1 

    if (@timer / 60) <= 10 && (@timer % 60) == 0 
      @timer_scale += 0.1 
      @timer_current_step += 0.1
    end



    color = Color.blend(@timer_start_color, @timer_end_color, @timer_current_step)
    @timer_current_color = Gosu::Color.rgba((color.to_s(false)+"FF").to_i(16))
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, ZOrder::Background)
    @stars.each { |star| star.draw }
    # colors are ARGB
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    @font.draw("Timer: #{@timer / 60}", 10, 50, ZOrder::UI, @timer_scale, @timer_scale, @timer_current_color)
  end

  def button_down(id) 
    if id == Gosu::KbEscape
      close
    end
  end
end

window = GameWindow.new
window.show