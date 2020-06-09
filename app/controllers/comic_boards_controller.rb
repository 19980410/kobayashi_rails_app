class ComicBoardsController < ApplicationController

    def show
        @comic_board = ComicBoard.find(params[:id])
        @comment = Comment.new
        @comments = Comment.where(parent_id: nil, board_id: params[:id])
    end

    def create
        comics = Comic.where(seriazation_status: 0)
        comics.each do |comic|
            ComicBoard.create(comic_id: comic.id)
        end
        redirect_to root_path
    end
end
