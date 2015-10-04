if defined?(Rails) and defined?(Rails::Railtie)
  require "rails"
  class LivingStyleGuideRailtie < Rails::Railtie
    initializer "living_style_guide.assets" do
      Rails.application.assets.register_engine(".lsg", ::LivingStyleGuide::Document)
      LivingStyleGuide.default_options[:scss_template] = ::Sass::Rails::ScssTemplate
    end
  end
end
