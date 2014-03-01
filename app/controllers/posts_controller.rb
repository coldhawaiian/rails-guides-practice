class PostsController < ApplicationController

  def create
    render text: params[:post].inspect
  end

  def new
  end

end
