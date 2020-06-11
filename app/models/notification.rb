class Notification < ApplicationRecord
    #新着順
    default_scope -> { order(created_at: :desc) }
    belongs_to :comic_board, optional: true
    belongs_to :comment, optional: true
    belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
    belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

    def create_notification_like!(current_user, favorite)
        #通知テーブルからいいねしたものがあるか検索　⇨　あれば、通知のレコード作成を行わない
        notification_searcn = Notification.where(["visitor_id = ? and visited_id = ? and comment_id = ? and action = ?", current_user.id, favorite.comment.user_id, favorite.comment.id, "いいね"] )
        if notification_searcn.blank?
            notification = current_user.active_notifications.new(
                comic_board_id: favorite.comment.comic_board_id,
                comment_id: favorite.comment.id,
                visited_id: favorite.comment.user_id,
                action: "いいね"
            )
            #自分へのいいねは既読にしておく
            if notification.visitor_id == notification.visitor_id
                notification.checked = true
            end
            notification.save if notification.valid?
        end 
    end

    def save_notification_comment!(current_user, comment)
        notification = current_user.active_notifications.new(
            comic_board_id: comment.comic_board_id,
            comment_id: comment.id,
            visited_id: comment.parent.user_id,
            action: 'コメント'
        )
        # 自分の投稿に対するコメントの場合は、通知済みとする
        if notification.visitor_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
    end


    def create_notification_follow!(current_user)
        notification_searcn = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
        if notification_searcn.blank?
            notification = current_user.active_notifications.new(
            visited_id: id,
            action: 'follow'
            )
            notification.save if notification.valid?
        end
    end
end
