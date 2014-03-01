class PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to @post
  end

  def new
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end

end
