# app/controllers/tweets_controller.rb
class TweetsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @tweet = Tweet.new
    @tweets = Tweet.all.order(created_at: :desc)
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user = current_user

    respond_to do |format| 
      if @tweet.save
        format.html {redirect_to root_path}
        format.turbo_stream
      else
        format.html do
          flash[:tweet_errors] = @tweet.errors.full_messages
          redirect_to root_path
        end
      end
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
    @comment = Comment.new
    @comments = @tweet.comments.order(created_at: :desc)
  end

  def destroy
    @tweet = current_user.tweets.find(params[:id])
    while true
      if @tweet.comments.exists?(tweet_id: params[:id])
        @comment = @tweet.comments.find_by(tweet_id: params[:id])
        @comment.destroy
      else
        break
      end
    end
    @tweet.destroy
    respond_to do |format| 
        format.html {redirect_to root_path}
        format.turbo_stream
    end
  end

  def retweet
    @tweet = Tweet.find(params[:id])  

    @retweet = current_user.tweets.new(tweet_id: @tweet.id)
    respond_to do |format| 
      if @retweet.save
        format.html {redirect_to root_path}
        format.turbo_stream
      else
        format.html { redirect_back fallback_location: @tweet, alert: "Could not retweet" }
      end
    end
  end
  private

  def tweet_params
    params.require(:tweet).permit(:body)
  end
end