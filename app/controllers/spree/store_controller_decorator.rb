Spree::StoreController::THEME_VIEW_LOAD_PATH = File.join(Spree::Theme::CURRENT_THEME_PATH, 'views')

module Spree
  module StoreControllerDecorator

    def self.prepended(base)
      base.fragment_cache_key Spree::ThemesTemplate::CacheResolver::FRAGMENT_CACHE_KEY
      base.before_action :set_view_path
      base.before_action :set_preview_theme, if: [:preview_mode?, :preview_theme]
      base.helper_method :preview_mode?
    end

    private

    def set_preview_theme
      params.merge!({mode: 'preview', theme: preview_theme.id})
    end

    def preview_mode?
      cookies[:preview].present?
    end


    def set_view_path
      path = preview_mode? ? theme_preview_path : Spree::StoreController::THEME_VIEW_LOAD_PATH
      prepend_view_path path
    end

    def theme_preview_path
      File.join(Spree::Theme::THEMES_PATH, cookies[:preview], 'views')
    end

    def preview_theme
      @preview_theme ||= Spree::Theme.find_by(name: cookies[:preview])
    end

  end
end

if defined?(Spree::StoreController)
  Spree::StoreController.prepend(Spree::StoreControllerDecorator)
end