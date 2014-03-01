class PostsController < ApplicationController

  def create
    @post = Post.new(guard_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(guard_params)
      redirect_to @post
    else
      render 'edit'
    end
  end

  private

  def guard_params
    params.require(:post).permit(:title, :text)
  end

end
