# coding: utf-8
#
# fontpad.rb
#   minimum text editor for trying a font(.ttf) before installation.

require "win32api"
require "wx"
require "ttfunk"


class FontPad < Wx::App

  FR_PRIVATE = 0x10

  def load_font(font_file_path)
    @font_file_path = font_file_path
    add_font_resource_ex = Win32API.new('gdi32', 'AddFontResourceEx', 'PLP', 'I')
    return add_font_resource_ex.call(@font_file_path, FR_PRIVATE, 0)
  end
  
  
  def unload_font
    remove_font_resource_ex = Win32API.new('gdi32', 'RemoveFontResourceEx', 'PLP', 'I')
    return remove_font_resource_ex.call(@font_file_path, FR_PRIVATE, 0)
  end
  
  
  def on_init
    frame = Wx::Frame.new(nil, -1, "#{@font_file_path} - FontPad",
      Wx::Point.new(0,0), Wx::Size.new(300, 250))
    
    font_sample = set_font_by_file(@font_file_path)
    text_name = Wx::StaticText.new(frame, -1,
      "Font Name: '#{font_sample[:font].get_face_name()}'")    
    text_sample = Wx::RichTextCtrl.new(frame, -1, font_sample[:sample],
      Wx::Point.new(0, 20), Wx::Size.new(280, 200))
    text_sample.set_font(font_sample[:font])
    
    frame.show()
  end # on_init
  
  
  def set_font_by_file(font_file_path)
    # parse the font file
    font_file = TTFunk::File.open(font_file_path)
    name_table = font_file.name

    # list up font names (one of them should be valid)
    font_names = name_table.font_name.concat(name_table.font_family).map do |font_name_raw|
      begin
        "#{font_name_raw}".encode("UTF-8", "UTF-16BE")
      rescue
        font_name_raw
      end
    end.uniq
    
    font = Wx::Font.new()
    font.set_style(Wx::FONTSTYLE_NORMAL)  

    # look for a valid name of the font
    valid_name = ""
    font_names.each do |font_name|
      font.set_face_name(font_name)
      if font.get_face_name() == font_name
        valid_name = font_name
        break
      end
    end

    font.set_point_size(20)

    # sample
    sample_text = font_file_path
    
    if !valid_name.empty?
      sample_text = valid_name
    end
    
    if !name_table.sample_text.nil? && !name_table.sample_text.empty?
      sample_text = name_table.sample_text[0].encode('UTF-8', 'UTF-16BE')
    end

    return {font: font, name: valid_name, sample: sample_text}
  end # set_font
  
end # FontPad


########################################
# command line processing
########################################

# recieves font file path
font_file = ARGV[0]

if font_file.nil? || font_file.empty?
  exit 1
end

font_file_path = File.absolute_path(font_file)

fontpad = FontPad.new
if fontpad.load_font(font_file_path) > 0
  fontpad.main_loop
  fontpad.unload_font
else
  exit 1
end

exit 0

# EOF

