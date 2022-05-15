# frozen_string_literal: true

# descale
# A library, or "scale", for DragonRuby
# By Dee Schaedler

# Provided under the MIT License, reproduced below

# Copyright 2022 D Schaedler
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# === General Methods ===

# Returns an integer between min and max
def randr(min, max)
  rand(max - min + 1) + min
end

# Returns an array [rrr, ggg, bbb] which is the same color as the hex code
def hex_to_rgb(hexstring)
  hexstring.delete('#').chars.each_slice(2).map { |e| e.join.to_i(16) }
end

# Returns an array [x, y] that, when called repeatedly with the same arguments, will be normally distributed
def gaussian(mean, stddev)
  theta = 2 * Math::PI * rand
  rho = Math.sqrt(-2 * Math.log(1 - rand))
  scale = stddev * rho
  [mean + (scale * Math.cos(theta)), mean + (scale * Math.sin(theta))]
end

# Returns an array [rrr, ggg, bbb] which is the same color as the HSV
def hsv_to_rgb(h, s, v)
  # based on conversion listed here: https://www.rapidtables.com/convert/color/hsv-to-rgb.html
  h = h % 360

  c = v * s
  x = c * (1 - (((h / 60) % 2) - 1).abs)
  m = v - c

  rp, gp, bp = [
    [c, x, 0], #   0 < h <  60
    [x, c, 0], #  60 < h < 120
    [0, c, x], # 120 < h < 180
    [0, x, c], # 180 < h < 240
    [x, 0, c], # 240 < h < 300
    [c, 0, x]  # 300 < h < 360
  ][h / 60]

  {
    r: (rp + m) * 255,
    g: (gp + m) * 255,
    b: (bp + m) * 255
  }
end

# === Constants ===

DEGREES_TO_RADIANS = Math::PI / 180
ALPHANUM = (('A'..'Z').to_a + (0..9).to_a)

# === DragonRuby Specific Stuff ===

# Abstracted drawing handler.
# @draw = Draw.new(args)
# @draw.layers = [[], [], [], []]
class Draw
  attr_accessor :layers, :debug_layer

  def initialize(_args)
    # layers = [[{}, {}, {},], [{}, {}, {}]]
    @layers = []
    @debug_layer = []
  end

  def tick(args)
    args.outputs.primitives << @layers
    @layers.each(&:clear)

    args.outputs.debug << @debug_layer
    @debug_layer.clear
  end
end

# == Big Data ==

ELEMENT_NAMES = %w[
  Hydrogen Helium Lithium Beryllium Boron Carbon Nitrogen Oxygen Fluorine Neon
  Sodium Magnesium Aluminium Silicon Phosphorus Sulfur Chlorine Argon Potassium
  Calcium Scandium Titanium Vanadium Chromium Manganese Iron Cobalt Nickel
  Copper Zinc Gallium Germanium Arsenic Selenium Bromine Krypton Rubidium
  Strontium Yttrium Zirconium Niobium Molybdenum Technetium Ruthenium Rhodium
  Palladium Silver Cadmium Indium Tin Antimony Tellurium Iodine Xenon Caesium
  Barium Lanthanum Cerium Praseodymium Neodymium Promethium Samarium Europium
  Gadolinium Terbium Dysprosium Holmium Erbium Thulium Ytterbium Lutetium
  Hafnium Tantalum Tungsten Rhenium Osmium Iridium Platinum Gold Mercury
  Thallium Lead Bismuth Polonium Astatine Radon Francium Radium Actinium Thorium
  Protactinium Uranium Neptunium Plutonium Americium Curium Berkelium
  Californium Einsteinium Fermium Mendelevium Nobelium Lawrencium Rutherfordium
  Dubnium Seaborgium Bohrium Hassium Meitnerium Darmstadtium Roentgenium
  Copernicium Nihonium Flerovium Moscovium Livermorium Tennessine Oganesson
].freeze

ELEMENT_SYMBOLS = %w[
  H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn Fe Co Ni Cu
  Zn Ga Ge As Se Br Kr Rb Sr Y Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I Xe Cs Ba
  La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu Hf Ta W Re Os Ir Pt Au Hg Tl Pb
  Bi Po At Rn Fr Ra Ac Th Pa U Np Pu Am Cm Bk Cf Es Fm Md No Lr Rf Db Sg Bh Hs
  Mt Ds Rg Cn Nh Fl Mc Lv Ts Og
].freeze

EXOPLANETS = [
  'Abol', 'Agouto', 'Albmi', 'Alef', 'Amateru', 'Arber', 'Arion', 'Arkas',
  'Asye', 'Aumatex', 'Awasis', 'Babylonia', 'Bagan', 'Baiduri', 'Bambaruush[6]',
  'Barajeel', 'Beirut', 'Bendida', 'Bocaprins', 'Boinayel', 'Brahe', 'Bran',
  'Buru', 'Caleuche', 'Cayahuanca', 'Chura', 'Cruinlagh', 'Cuptor', 'Dagon',
  'Dimidium', 'Dopere', 'Draugr', 'Drukyul', 'Dulcinea', 'Eburonia', 'Eiger',
  'Equiano', 'Eyeke', 'Finlay', 'Fold', 'Fortitudo', 'Galileo', 'Ganja',
  'Guarani', 'Haik', 'Hairu', 'Halla', 'Harriot', 'Hiisi', 'Hypatia',
  'Independance', 'Iolaus', 'Isagel', 'Isli', 'Iztok', 'Janssen', 'Jebus',
  'Kavian', 'Khomsa', "Koyopa'", 'Krotoa', 'Laligurans', 'Leklsullun', 'Lete',
  'Lipperhey', 'Madalitso', 'Madriu', 'Maeping', 'Magor', 'Majriti',
  'Makropulos', 'Mastika', 'Meztli', 'Mintome', 'Mulchatna', 'Nachtwacht',
  'Naron', 'Negoiu', 'Neri', 'Noifasui', 'Onasilos', 'Orbitar', 'Peitruss',
  'Perwana', 'Phobetor', 'Pipitea', 'Pirx', 'Pollera', 'Poltergeist', 'Quijote',
  'Ramajay', 'Riosar', 'Rocinante', 'Saffar', 'Samagiya', 'Samh', 'Sancho',
  'Santamasa', 'Sazum', 'Sissi', 'Smertrios', 'Spe', 'Staburags', 'Sumajmajta',
  'Surt', 'Tadmor', 'Tanzanite', 'Taphao Kaew', 'Taphao Thong', 'Tassili',
  'Teberda', 'Thestias', 'Toge', 'Tondra', 'Trimobe', 'Tryzub', 'Tumearandu',
  'Ugarit', 'Veles', 'Victoriapeak', 'Viculus', 'Viriato', 'Vlasina', 'Vytis',
  'Wadirum', 'Wangshu', 'Xolotlan', 'Yanyan', 'Yvaga'
].freeze

# === Geometry ===
# Returns an array [x, y]
def point_at_distance_angle(options = {})
  point = options[:point]
  distance = options[:distance]
  angle = options[:angle]

  new_point = {}

  new_point[:x] = (distance * Math.cos(angle * Math::PI / 180)) + point[:x]
  new_point[:y] = (distance * Math.sin(angle * Math::PI / 180)) + point[:y]
  new_point
end

# Returns an array [dx, dy]
def point_difference(point1:, point2:)
  [point1.x - point2.x, point1.y - point2.y]
end

# Returns a float of the distance between points
def point_distance(point1:, point2:)
  dx = point2.x - point1.x
  dy = point2.y - point1.y
  Math.sqrt((dx * dx) + (dy * dy))
end

# Returns a float of the distance between points squared
def point_distance_squared(point1:, point2:)
  dx = point2.x - point1.x
  dy = point2.y - point1.y
  (dx * dx) + (dy * dy)
end

def vector_angle(vector1:, vector2:)
  Math.acos(
    vector_dot_product(
      vector1: vector1,
      vector2: vector2
    ) / (
        vector_normal(vector: vector1) * vector_normal(vector: vector2)
      )
  ) * numeric_sign(value: vector_cross_product(vector1: vector1, vector2: vector2))
end

def vector_cross_product(vector1:, vector2:)
  (vector1.x * vector2.y) - (vector2.x * vector1.y)
end

def vector_dot_product(vector1:, vector2:)
  (vector1.x * vector2.x) + (vector1.y * vector2.y)
end

def vector_normal(vector:)
  Math.sqrt((vector.x * vector.x) + (vector.y * vector.y))
end

def numeric_sign(value:)
  value <=> 0
end
