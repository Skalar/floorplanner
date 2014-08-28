module Floorplanner
  module Models
    class PublishConfiguration < Model
      # required
      element :path # The part of the URL that comes after the pl.an/ domain: http://pl.an/:path

      # optional
      element :style_id # The numerical ID of a style
      element :show_furniture_and_texture_libraries # A boolean to indicate if visitors are allowed to decorate the plan or not
      element :show_measurement_system # A boolean to show or hide the meter/feet toggle in the bottom left corner
      element :show_3d # A boolean to give visitors access to the 3D view of a plan
      element :show_dimensions # A boolean to show or hide the automatic wall dimensions
      element :show_custom_dimensions # A boolean to show or hide the hand draw dimension lines
      element :allow_print # A boolean to control printing
      element :allow_save_by_mail # A boolean to indicate if visitors are allowed to share the plan (via email, Twitter or Facebook)
      element :show_sidebar # A boolean to show or hide the sidebar
      element :cc_addresses # A list of comma separated email addresses
      element :allow_cc_addresses # A boolean to indicate if the email addresses in the cc-addresses list should get a notification email when a visitor saves a design
      element :receive_bcc # A boolean to indicate if the owner of the project should get a notification email when a visitor saves a design
      element :element_categories # A list of comma separated numerical IDs of element categories. The elements (furniture items) of these categories are shown in the furniture library.
      element :init_module # A string which shows the active sidebar tab when loading the project. (options: details, media, location, share, assets, tutorial)
      element :hide_scale_bar # A boolean to indicate if the scale bar should not be shown
    
      def errors
        [].tap do |e|
          e << "path is missing" if path.nil? || path.empty?
        end
      end
    end
  end
end
