class StaticPageController < ApplicationController

	skip_before_filter :authenticate_user!

	layout 'static_page'

	def index	
	end

end
