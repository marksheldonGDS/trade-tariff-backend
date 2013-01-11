module Api
  module V1
    class GeographicalAreasController < ApplicationController
      def countries
        @geographical_areas = GeographicalArea.eager(:geographical_area_description)
                                              .countries
                                              .all

        respond_with @geographical_areas
      end
    end
  end
end