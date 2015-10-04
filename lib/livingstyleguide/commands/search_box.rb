LivingStyleGuide.default_options[:search_box] = {
  placeholder: "Search …"
}

LivingStyleGuide.command :search_box do |arguments, options, content|
  placeholder = options[:placeholder] || LivingStyleGuide.default_options[:search_box][:placeholder]
  document.before << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/search-box.html.erb")).result(binding)
  document.javascript << ERB.new(File.read("#{File.dirname(__FILE__)}/../templates/scripts/search.js.erb")).result(binding)
  nil
end
