class PagesController < ApplicationController
  def home
    @categories = Category.all
    @lastevents = Event.last(3) 

  end
  def about 
    @categories = Category.all

	end 
end
