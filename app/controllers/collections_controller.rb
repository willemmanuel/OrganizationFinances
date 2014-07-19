class CollectionsController < ApplicationController

  before_action :set_collection, only: [:show, :edit, :update, :destroy]

  before_filter :require_chapter_manager

  def show
  end

  def new
  	@collection = Collection.new
  end

  def edit
  end

  def create
  	@collection = Collection.new(collection_params)
    @collection.semester = current_user.chapter.get_current_semester
  	if @collection.save
  		redirect_to @collection, notice: 'Collection was successfully created.'
  	else
  		render action: 'edit'
  	end
  end

  def update
  	if @collection.update(collection_params)
		redirect_to @collection, notice: 'Collection was successfully updated.'
  	else
  		render action: 'edit'
  	end
  end

  def destroy
  	@collection.destroy
  	redirect_to collections_path
  end

  private
	def set_collection
	  @collection = Collection.find(params[:id])
	end

	def collection_params
      params.require(:collection).permit(:name)
    end

    def require_chapter_manager
      if !current_user.present?
        return
      end
      unless current_user.chapter_manager
        redirect_to personal_path
      end
    end
end
