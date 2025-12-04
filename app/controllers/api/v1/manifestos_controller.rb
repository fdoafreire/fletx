module Api
  module V1
    class ManifestosController < Api::V1::ApplicationController
      
      before_action :set_manifesto, only: [:show, :start] 
      
      # GET /api/v1/manifestos/:id
      def show
        render json: ManifestoSerializer.new(@manifesto).serializable_hash
      end

      # POST /api/v1/manifestos
      def create
        Manifesto.transaction do
          @manifesto = Manifesto.new(manifesto_params.except(:stops))

          if @manifesto.save
            create_stops(@manifesto, manifesto_params[:stops])
            
            render json: ManifestoSerializer.new(@manifesto).serializable_hash, status: :created
          else
            render_errors(@manifesto)
          end
        end
      end
      
      # PATCH /api/v1/manifestos/:id/start
      def start
        @manifesto.start!
        render json: ManifestoSerializer.new(@manifesto).serializable_hash
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # ----------------------------------------------------------------
      #                      MÉTODOS PRIVADOS
      # ----------------------------------------------------------------
      private

      def set_manifesto
        @manifesto = Manifesto.find(params[:id]) 
      end

      def manifesto_params
        params.require(:manifesto).permit(
          :date, 
          :driver_id, 
          :vehicle_id,
          :status,
          stops: [
            :address, 
            :order, 
            :stop_type
          ]
        )
      end
      
      def create_stops(manifesto, stops_attributes)
        stops_attributes.each do |stop_attr|
          manifesto.stops.create!(stop_attr)
        end
      end
      
      def render_errors(resource)
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
