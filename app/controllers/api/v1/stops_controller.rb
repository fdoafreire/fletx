module Api
  module V1
    class StopsController < Api::V1::ApplicationController
      
      before_action :set_stop, only: [:complete]

      def complete
        
        Stop.transaction do
          @stop.update!(status: :completed, completed_at: Time.current)
          
          process_next_stop_or_manifesto(@stop.manifesto)
        end

        render json: StopSerializer.new(@stop).serializable_hash
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # ----------------------------------------------------------------
      #                      MÉTODOS PRIVADOS
      # ----------------------------------------------------------------
      private

      def set_stop
        @stop = Stop.find(params[:id]) 
      end

      def process_next_stop_or_manifesto(manifesto)
        if manifesto.stops.all?(&:completed?)
          
          if manifesto.can_complete?
            manifesto.complete! 
          end
        else
          nil
        end
      rescue => e
        Rails.logger.error "Error en la lógica de avance del manifiesto #{manifesto.id}: #{e.message}"
      end
    end
  end
end
