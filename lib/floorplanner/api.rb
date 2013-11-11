module Floorplanner
  module Api
    extend ActiveSupport::Autoload

    autoload :Resource
    autoload :Client

    autoload_under 'resources' do
      autoload :User
    end
  end
end
