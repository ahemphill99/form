module FormsHelper
  def color_with_opacity(hex_color, opacity)
    # Convert hex to RGB
    hex_color = hex_color.gsub('#', '')
    r = hex_color[0..1].to_i(16)
    g = hex_color[2..3].to_i(16)
    b = hex_color[4..5].to_i(16)
    
    # Return rgba color
    "rgba(#{r}, #{g}, #{b}, #{opacity})"
  end
end
