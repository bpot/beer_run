class BeersController < ApplicationController
  BEERS_BOB_LIKES = ["Zima", "Mike's Hard Lemonade"]
  
  def index
    @beers = Beer.all.sort_by do |beer| 
      if BEERS_BOB_LIKES.include?(beer.name)
        -1
      else
        -beer.points 
      end
    end
  end

  def new
    @beer = Beer.new
  end

  def create
    @beer = Beer.new(params[:beer])

    if @beer.save
      flash[:notice] = 'Beer created.'
      redirect_to :beers
    else
      render :new
    end
  end

  def vote
    authenticate_user!
    @beers = Beer.order(:name)
    @votes = current_user.votes
  end

  def record_vote
    authenticate_user!
    params[:beers] ||= []
    current_user.votes = params[:beers].collect { |id| Beer.find_by_id(id) }.compact

    if current_user.save
      flash[:notice] = 'Votes recorded.'
    else
      flash[:alert] = current_user.errors.to_a.join("\n")
    end

    redirect_to :action => :vote
  end
end
