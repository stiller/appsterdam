class ClassifiedsController < ApplicationController
  allow_access(:authenticated, :only => [:new, :create])
  allow_access(:authenticated, :only => [:edit, :update, :destroy]) { !find_classified.nil? }
  allow_access(:all, :only => :index)

  def index
    @classifieds = Classified.all
  end

  def new
    @classified = @authenticated.classifieds.build
  end

  def create
    @authenticated.classifieds.create(params[:classified])
    redirect_to classifieds_url
  end

  def update
    @classified.update_attributes(params[:classified])
    redirect_to classifieds_url
  end

  def destroy
    @classified.destroy
    redirect_to classifieds_url
  end

  private

  def find_classified
    @classified = @authenticated.classifieds.find_by_id(params[:id])
  end
end
