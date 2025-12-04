module Api
  module V1
    class SessionsController < Api::V1::ApplicationController
      
      include Devise::Controllers::Helpers 
      
      respond_to :json 

      def create
        user = User.find_by(email: params[:user][:email])
        
        if user&.valid_password?(params[:user][:password])
          sign_in(user) 
          
          render json: {  
            message: 'Logged in successfully.',
            user: UserSerializer.new(user)  
          }, status: :ok
        else
          render json: { error: 'Invalid Email or password' }, status: :unauthorized
        end
      end
      
      def destroy
        user = current_api_v1_user
        if user
          sign_out(user)
          head :no_content
        else
          head :not_found 
        end        
      end
    end
  end
end
