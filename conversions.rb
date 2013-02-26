def rgb2hsl(rgb)
  r = rgb[0]/255
  g = rgb[1]/255
  b = rgb[2]/255

  min = [r, g, b].min
  max = [r, g, b].max
  delta = max - min

  if (max == min)
    h = 0
  elsif (r == max)
    h = (g - b) / delta
  elsif (g == max)
    h = 2 + (b - r) / delta
  elsif (b == max)
    h = 4 + (r - g)/ delta
  end

  h = [h * 60, 360].min

  if (h < 0)
    h += 360
  end

  l = (min + max) / 2

  if (max == min)
    s = 0
  elsif (l <= 0.5)
    s = delta / (max + min)
  else
    s = delta / (2 - max - min)
  end

  [h, s * 100, l * 100]
end

def rgb2hsv(rgb)
  r = rgb[0]
  g = rgb[1]
  b = rgb[2]

  min = [r, g, b].min
  max = [r, g, b].max
  delta = max - min

  if (max == 0)
    s = 0
  else
    s = (delta/max * 1000)/10
  end

  if (max == min)
    h = 0
  elsif (r == max)
    h = (g - b) / delta
  elsif (g == max)
    h = 2 + (b - r) / delta
  elsif (b == max)
    h = 4 + (r - g) / delta
  end

  h = [h * 60, 360].min

  if (h < 0)
    h += 360
  end

  v = ((max / 255) * 1000) / 10

  [h, s, v]
end

def rgb2cmyk(rgb)
  r = rgb[0] / 255
  g = rgb[1] / 255
  b = rgb[2] / 255
     
  k = [1 - r, 1 - g, 1 - b].min
  c = (1 - r - k) / (1 - k)
  m = (1 - g - k) / (1 - k)
  y = (1 - b - k) / (1 - k)
  [c * 100, m * 100, y * 100, k * 100]
end

def rgb2keyword(rgb)
  reverseKeywords[JSON.stringify(rgb)]
end

def rgb2xyz(rgb)
  r = rgb[0] / 255
  g = rgb[1] / 255
  b = rgb[2] / 255

  # assume sRGB
  r = r > 0.04045 ? ((r + 0.055) / 1.055) ** 2.4 : (r / 12.92)
  g = g > 0.04045 ? ((g + 0.055) / 1.055) ** 2.4 : (g / 12.92)
  b = b > 0.04045 ? ((b + 0.055) / 1.055) ** 2.4 : (b / 12.92)
 
  x = (r * 0.4124) + (g * 0.3576) + (b * 0.1805)
  y = (r * 0.2126) + (g * 0.7152) + (b * 0.0722)
  z = (r * 0.0193) + (g * 0.1192) + (b * 0.9505)

  [x * 100, y *100, z * 100]
end

def rgb2lab(rgb)
  xyz = rgb2xyz(rgb)
  x = xyz[0]
  y = xyz[1]
  z = xyz[2]

  x /= 95.047
  y /= 100
  z /= 108.883

  x = x > 0.008856 ? x ** (1/3) : (7.787 * x) + (16 / 116)
  y = y > 0.008856 ? y ** (1/3) : (7.787 * y) + (16 / 116)
  z = z > 0.008856 ? z ** (1/3) : (7.787 * z) + (16 / 116)

  l = (116 * y) - 16
  a = 500 * (x - y)
  b = 200 * (y - z)
 
  [l, a, b]
end

def hsl2rgb(hsl)
  h = hsl[0] / 360
  s = hsl[1] / 100
  l = hsl[2] / 100

  if (s == 0)
    val = l * 255
    return [val, val, val]
  end

  if (l < 0.5)
    t2 = l * (1 + s)
  else
    t2 = l + s - l * s
  end
  t1 = 2 * l - t2

  rgb = [0, 0, 0]
  3.times { | i |
    t3 = h + 1 / 3 * - (i - 1)
    t3 < 0 && t3++
    t3 > 1 && t3--

    if (6 * t3 < 1)
      val = t1 + (t2 - t1) * 6 * t3
    elsif (2 * t3 < 1)
      val = t2
    elsif (3 * t3 < 2)
      val = t1 + (t2 - t1) * (2 / 3 - t3) * 6
    else
      val = t1
    end

    rgb[i] = val * 255
  }
 
  rgb
end

def hsl2hsv(hsl)
  h = hsl[0]
  s = hsl[1] / 100
  l = hsl[2] / 100

  l *= 2
  s *= (l <= 1) ? l : 2 - l
  v = (l + s) / 2
  sv = (2 * s) / (l + s)
  [h, sv * 100, v * 100]
end

def hsl2cmyk(args)
  rgb2cmyk(hsl2rgb(args))
end

def hsl2keyword(args)
  rgb2keyword(hsl2rgb(args))
end

def hsv2rgb(hsv)
  h = hsv[0] / 60
  s = hsv[1] / 100
  v = hsv[2] / 100
  hi = h.floor % 6

  f = h - h.floor
  p = 255 * v * (1 - s)
  q = 255 * v * (1 - (s * f))
  t = 255 * v * (1 - (s * (1 - f)))
  v = 255 * v

  case hi
    when 0
      return [v, t, p]
    when 1
      return [q, v, p]
    when 2
      return [p, v, t]
    when 3
      return [p, q, v]
    when 4
      return [t, p, v]
    when 5
      return [v, p, q]
  end
end

def hsv2hsl(hsv)
  h = hsv[0]
  s = hsv[1] / 100
  v = hsv[2] / 100

  l = (2 - s) * v; 
  sl = s * v
  sl /= (l <= 1) ? l : 2 - l
  l /= 2
  [h, sl * 100, l * 100]
end

def hsv2cmyk(args)
  rgb2cmyk(hsv2rgb(args))
end

def hsv2keyword(args)
  rgb2keyword(hsv2rgb(args))
end

def cmyk2rgb(cmyk)
  c = cmyk[0] / 100
  m = cmyk[1] / 100
  y = cmyk[2] / 100
  k = cmyk[3] / 100

  r = 1 - [1, c * (1 - k) + k].min
  g = 1 - [1, m * (1 - k) + k].min
  b = 1 - [1, y * (1 - k) + k].min
  [r * 255, g * 255, b * 255]
end

def cmyk2hsl(args)
  rgb2hsl(cmyk2rgb(args))
end

def cmyk2hsv(args)
  rgb2hsv(cmyk2rgb(args))
end

def cmyk2keyword(args)
  rgb2keyword(cmyk2rgb(args))
end


def xyz2rgb(xyz)
  x = xyz[0] / 100
  y = xyz[1] / 100
  z = xyz[2] / 100

  r = (x * 3.2406) + (y * -1.5372) + (z * -0.4986)
  g = (x * -0.9689) + (y * 1.8758) + (z * 0.0415)
  b = (x * 0.0557) + (y * -0.2040) + (z * 1.0570)

  r = r > 0.0031308 ? (1.055 * r) ** (1.0 / 2.4) - 0.055 : r = (r * 12.92)

  g = g > 0.0031308 ? ((1.055 * g) ** (1.0 / 2.4)) - 0.055 : g = (g * 12.92)
       
  b = b > 0.0031308 ? ((1.055 * b) ** (1.0 / 2.4)) - 0.055 : b = (b * 12.92)

  r = (r < 0) ? 0 : r
  g = (g < 0) ? 0 : g
  b = (b < 0) ? 0 : b

  [r * 255, g * 255, b * 255]
end

def xyz2lab(xyz)
  x = xyz[0]
  y = xyz[1]
  z = xyz[2]

  x /= 95.047
  y /= 100
  z /= 108.883

  x = x > 0.008856 ? x ** (1/3) : (7.787 * x) + (16 / 116)
  y = y > 0.008856 ? y ** (1/3) : (7.787 * y) + (16 / 116)
  z = z > 0.008856 ? z ** (1/3) : (7.787 * z) + (16 / 116)

  l = (116 * y) - 16
  a = 500 * (x - y)
  b = 200 * (y - z)
 
  [l, a, b]
end

def lab2xyz(lab)
  l = lab[0]
  a = lab[1]
  b = lab[2]

  if (l <= 8)
    y = (l * 100) / 903.3
    y2 = (7.787 * (y / 100)) + (16 / 116)
  else
    y = 100 * ((l + 16) / 116) ** 3
    y2 = (y / 100) ** (1/3)
  end

  x = x / 95.047 <= 0.008856 ? x = (95.047 * ((a / 500) + y2 - (16 / 116))) / 7.787 : 95.047 * ((a / 500) + y2) ** 3

  z = z / 108.883 <= 0.008859 ? z = (108.883 * (y2 - (b / 200) - (16 / 116))) / 7.787 : 108.883 * (y2 - (b / 200)) ** 3

  [x, y, z]
end

def keyword2rgb(keyword)
  cssKeywords[keyword]
end

def keyword2hsl(args)
  rgb2hsl(keyword2rgb(args))
end

def keyword2hsv(args)
  rgb2hsv(keyword2rgb(args))
end

def keyword2cmyk(args)
  rgb2cmyk(keyword2rgb(args))
end

def keyword2lab(args)
  rgb2lab(keyword2rgb(args))
end

def keyword2xyz(args)
  rgb2xyz(keyword2rgb(args))
end

@cssKeywords = {
  'aliceblue' =>  [240,248,255],
  'antiquewhite' => [250,235,215],
  'aqua' => [0,255,255],
  'aquamarine' => [127,255,212],
  'azure' =>  [240,255,255],
  'beige' =>  [245,245,220],
  'bisque' => [255,228,196],
  'black' =>  [0,0,0],
  'blanchedalmond' => [255,235,205],
  'blue' => [0,0,255],
  'blueviolet' => [138,43,226],
  'brown' =>  [165,42,42],
  'burlywood' =>  [222,184,135],
  'cadetblue' =>  [95,158,160],
  'chartreuse' => [127,255,0],
  'chocolate' =>  [210,105,30],
  'coral' =>  [255,127,80],
  'cornflowerblue' => [100,149,237],
  'cornsilk' => [255,248,220],
  'crimson' =>  [220,20,60],
  'cyan' => [0,255,255],
  'darkblue' => [0,0,139],
  'darkcyan' => [0,139,139],
  'darkgoldenrod' =>  [184,134,11],
  'darkgray' => [169,169,169],
  'darkgreen' =>  [0,100,0],
  'darkgrey' => [169,169,169],
  'darkkhaki' =>  [189,183,107],
  'darkmagenta' =>  [139,0,139],
  'darkolivegreen' => [85,107,47],
  'darkorange' => [255,140,0],
  'darkorchid' => [153,50,204],
  'darkred' =>  [139,0,0],
  'darksalmon' => [233,150,122],
  'darkseagreen' => [143,188,143],
  'darkslateblue' =>  [72,61,139],
  'darkslategray' =>  [47,79,79],
  'darkslategrey' =>  [47,79,79],
  'darkturquoise' =>  [0,206,209],
  'darkviolet' => [148,0,211],
  'deeppink' => [255,20,147],
  'deepskyblue' =>  [0,191,255],
  'dimgray' =>  [105,105,105],
  'dimgrey' =>  [105,105,105],
  'dodgerblue' => [30,144,255],
  'firebrick' =>  [178,34,34],
  'floralwhite' =>  [255,250,240],
  'forestgreen' =>  [34,139,34],
  'fuchsia' =>  [255,0,255],
  'gainsboro' =>  [220,220,220],
  'ghostwhite' => [248,248,255],
  'gold' => [255,215,0],
  'goldenrod' =>  [218,165,32],
  'gray' => [128,128,128],
  'green' =>  [0,128,0],
  'greenyellow' =>  [173,255,47],
  'grey' => [128,128,128],
  'honeydew' => [240,255,240],
  'hotpink' =>  [255,105,180],
  'indianred' =>  [205,92,92],
  'indigo' => [75,0,130],
  'ivory' =>  [255,255,240],
  'khaki' =>  [240,230,140],
  'lavender' => [230,230,250],
  'lavenderblush' =>  [255,240,245],
  'lawngreen' =>  [124,252,0],
  'lemonchiffon' => [255,250,205],
  'lightblue' =>  [173,216,230],
  'lightcoral' => [240,128,128],
  'lightcyan' =>  [224,255,255],
  'lightgoldenrodyellow' => [250,250,210],
  'lightgray' =>  [211,211,211],
  'lightgreen' => [144,238,144],
  'lightgrey' =>  [211,211,211],
  'lightpink' =>  [255,182,193],
  'lightsalmon' =>  [255,160,122],
  'lightseagreen' =>  [32,178,170],
  'lightskyblue' => [135,206,250],
  'lightslategray' => [119,136,153],
  'lightslategrey' => [119,136,153],
  'lightsteelblue' => [176,196,222],
  'lightyellow' =>  [255,255,224],
  'lime' => [0,255,0],
  'limegreen' =>  [50,205,50],
  'linen' =>  [250,240,230],
  'magenta' =>  [255,0,255],
  'maroon' => [128,0,0],
  'mediumaquamarine' => [102,205,170],
  'mediumblue' => [0,0,205],
  'mediumorchid' => [186,85,211],
  'mediumpurple' => [147,112,219],
  'mediumseagreen' => [60,179,113],
  'mediumslateblue' =>  [123,104,238],
  'mediumspringgreen' =>  [0,250,154],
  'mediumturquoise' =>  [72,209,204],
  'mediumvioletred' =>  [199,21,133],
  'midnightblue' => [25,25,112],
  'mintcream' =>  [245,255,250],
  'mistyrose' =>  [255,228,225],
  'moccasin' => [255,228,181],
  'navajowhite' =>  [255,222,173],
  'navy' => [0,0,128],
  'oldlace' =>  [253,245,230],
  'olive' =>  [128,128,0],
  'olivedrab' =>  [107,142,35],
  'orange' => [255,165,0],
  'orangered' =>  [255,69,0],
  'orchid' => [218,112,214],
  'palegoldenrod' =>  [238,232,170],
  'palegreen' =>  [152,251,152],
  'paleturquoise' =>  [175,238,238],
  'palevioletred' =>  [219,112,147],
  'papayawhip' => [255,239,213],
  'peachpuff' =>  [255,218,185],
  'peru' => [205,133,63],
  'pink' => [255,192,203],
  'plum' => [221,160,221],
  'powderblue' => [176,224,230],
  'purple' => [128,0,128],
  'red' =>  [255,0,0],
  'rosybrown' =>  [188,143,143],
  'royalblue' =>  [65,105,225],
  'saddlebrown' =>  [139,69,19],
  'salmon' => [250,128,114],
  'sandybrown' => [244,164,96],
  'seagreen' => [46,139,87],
  'seashell' => [255,245,238],
  'sienna' => [160,82,45],
  'silver' => [192,192,192],
  'skyblue' =>  [135,206,235],
  'slateblue' =>  [106,90,205],
  'slategray' =>  [112,128,144],
  'slategrey' =>  [112,128,144],
  'snow' => [255,250,250],
  'springgreen' =>  [0,255,127],
  'steelblue' =>  [70,130,180],
  'tan' =>  [210,180,140],
  'teal' => [0,128,128],
  'thistle' =>  [216,191,216],
  'tomato' => [255,99,71],
  'turquoise' =>  [64,224,208],
  'violet' => [238,130,238],
  'wheat' =>  [245,222,179],
  'white' =>  [255,255,255],
  'whitesmoke' => [245,245,245],
  'yellow' => [255,255,0],
  'yellowgreen' =>  [154,205,50]
}

=begin
var reverseKeywords = {}
for (var key in cssKeywords) {
  reverseKeywords[JSON.stringify(cssKeywords[key])] = key
}
=end
