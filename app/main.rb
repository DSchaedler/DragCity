# frozen_string_literal: true

# By Dee Schaedler

# Provided under the MIT License, reproduced below

# Copyright 2022 D Schaedler
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class Game
  attr_gtk

  def tick
    defaults
    calc
    render
  end

  def defaults
    game_reset if state.tick_count.zero?
  end

  def game_reset
    state.zoom = 1

    state.spritesheet = 'sprites/colored_packed.png'
    state.sprite_size = 16

    state.city_grid_size = 50
    state.tile_scale = 16
    state.tile = { w: state.tile_scale, h: state.tile_scale, path: state.spritesheet, tile_w: 16, tile_h: 16 }

    state.cursor_sprite = { tile_x: 29 * state.sprite_size, tile_y: 14 * state.sprite_size }
    state.grass_sprite = { tile_x: 6 * state.sprite_size, tile_y: 0 * state.sprite_size }

    state.city_grid = nil
    build_grid
  end

  def build_grid
    iter_x = 0
    while iter_x < state.city_grid_size
      iter_y = 0
      state.city_grid[iter_x] = {}

      while iter_y < state.city_grid_size
        state.city_grid[iter_x][iter_y] = { loc_x: iter_x, loc_y: iter_y, zone: :none, entity: :none, state: {} }
        iter_y += 1
      end

      iter_x += 1
    end
  end

  def calc
    if inputs.keyboard.key_up.z
      state.zoom += 0.1
      state.zoom.round(1)
    end

    if inputs.keyboard.key_up.x
      state.zoom -= 0.1
      state.zoom.round(1)
    end
  end

  def render
    args.render_target(:city_grid).clear_before_render = true

    iter_x = 0
    while iter_x < state.city_grid_size
      iter_y = 0

      while iter_y < state.city_grid_size

        # puts state.city_grid[iter_x][iter_y]
        case state.city_grid[iter_x][iter_y][:entity]
        when :road
          # Holder
        else
          tile_x = 6
          tile_y = 0
        end

        args.render_target(:city_grid).sprites << {
          x: iter_x * state.tile_scale,
          y: iter_y * state.tile_scale
        }.merge(state.tile).merge(state.grass_sprite)

        iter_y += 1
      end

      iter_x += 1
    end

    args.outputs.sprites << { x: 0, y: 0, w: 1280 * state.zoom, h: 720 * state.zoom, path: :city_grid }
  end
end

def tick(args)
  $game.args = args
  $game.tick
end

$game = Game.new
$gtk.reset
