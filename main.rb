#!/usr/bin/env ruby

require "ft2"

class Ft2Example
  def initialize(ttf_path)
    @face = FT2::Face.new ttf_path
    @face.set_pixel_sizes 16, 0
  end

  def draw
    glyph = @face.glyph

    for row in 0..(glyph.bitmap.rows - 1)
      for pixel in 0..(glyph.bitmap_left - 1)
        print "  "
      end

      for pixel in 0..(glyph.bitmap.width - 1)
        # pitch 是指一個 row 有多少 bytes
        # 跟 c/c++ 不一樣的是，ruby 的條件式是只有 nil 跟 false 會是 false
        # 所以這邊要設定條件 > 0
        index = row * glyph.bitmap.pitch + pixel / 8
        if glyph.bitmap.buffer[index].ord & (0xC0 >> (pixel % 8)) > 0
          print "██"
        else
          print "  "
        end
      end
      puts
    end
  end

  def draw_ch(ch)
    # 先取得索引
    ch_index = @face.char_index ch.ord

    # 設定現在要渲染的文字
    @face.load_glyph ch_index, FT2::Load::DEFAULT

    # 設定渲染模式
    @face.glyph.render_glyph FT2::RenderMode::MONO

    draw
  end

  def draw_string(str)
    str.split("").each do |ch|
      draw_ch(ch)

      puts
    end
  end
end

if ARGV.size < 2
  puts "Usage:"
  puts "    ruby main.rb TTF_PATH \"WORD\""

  puts

  puts "Example:"
  puts "    ruby main.rb ./GenShinGothic-Monospace-Regular.ttf 安安您好"

  exit 1
end

ft2_example = Ft2Example.new(ARGV[0])
ft2_example.draw_string(ARGV[1])

