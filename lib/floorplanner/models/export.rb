module Floorplanner
  module Models
    class Export < Model
      self.namespace = "http://floorplanner.com/export/request"

      # required
      complex :resolution, Resolution
      element :callback # if not included ...
      element :send_to # ... this must be included

      # optional
      element :type # MIME type of requested export format
      element :paper_scale # Number between 0.002 and 0.02 (PDF only, see design export)
      element :scaling # if set to 'constant', all designs will be scaled by the same ratio
      element :scalebar # set to 1 or “true” to include a scale bar in the output image
      element :black_white # Boolean value (true/false) of whether the output should be in grayscale

      def errors
        [].tap do |e|
          if resolution
            e << "resolution#width is missing" if resolution.width.nil?
            e << "resolution#height is missing" if resolution.height.nil?
          else
            e << "resolution must be set"
          end

          if (callback.nil? || callback.empty?) && (send_to.nil? || send_to.empty?)
            e << "a value must be supplied for callback or send_to"
          end

          if callback && send_to
            e << "supply either callback or send_to, not both"
          end
        end
      end
    end
  end
end
