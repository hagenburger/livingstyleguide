LivingStyleGuide.command :default do |arguments, options, block|
  key = arguments.first ? arguments.first.gsub("-", "_").to_sym : :global
  document.defaults[key] ||= {}
  document.defaults[key].merge!(options)
  nil
end
