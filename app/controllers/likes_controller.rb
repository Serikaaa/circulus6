class LikesController < ApplicationController
    before_action :set_likeable
  
    def create
        respond_to do |format| 
            if @likeable.likes.count >= 1 && @likeable.liked_by?(current_user)
                format.html {redirect_to root_path}
                format.turbo_stream
                @like = Like.find_by(likeable_id: @likeable.id, user: current_user)
                @like.destroy
            else
                format.html {redirect_to root_path}
                format.turbo_stream
                @like = @likeable.likes.new
                @like.user = current_user
                @like.save
            end
            end
        end
    private
  
    def set_likeable
      @likeable = params[:likeable_type].constantize.find(params[:likeable_id])
    end
  end