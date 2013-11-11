module Floorplanner
  module Api
    extend ActiveSupport::Autoload

    autoload :Resource
    autoload :UrlBuilder

    autoload_under 'resources' do
      autoload :User
    end
  end
end
