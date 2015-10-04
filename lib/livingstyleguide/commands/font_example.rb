LivingStyleGuide.default_options[:font_example] = { text: <<-TEXT }
  ABCDEFGHIJKLMNOPQRSTUVWXYZ
  abcdefghijklmnopqrstuvwxyz
  0123456789
  !&/()$=@;:,.
TEXT

LivingStyleGuide.command :font_example do |arguments, options, text|
  text ||= LivingStyleGuide.default_options[:font_example][:text]
  text = ERB::Util.html_escape(text)
  text.strip!
  text.gsub!(/\n/, "<br>\n")
  font = ERB::Util.html_escape(arguments.first)
  ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/font-example.html.erb")).result(binding)
end
