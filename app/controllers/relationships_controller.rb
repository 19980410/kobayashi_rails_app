class RelationshipsController < ApplicationController
    def follow
        ActiveRecord::Base.transaction do
            current_user.follow(params[:id])
            notification = Notification.new
            notification.create_notification_follow!(current_user, params[:id])
        end
        redirect_to user_path(params[:id])
    end
      
    def unfollow
        current_user.unfollow(params[:id])
        redirect_to user_path(params[:id])
    end
end
