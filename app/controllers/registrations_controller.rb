class RegistrationsController < Devise::RegistrationsController 
	def create
		super
		if resource.save 
			b = Brother.where(email: resource.email).first
			if !b.nil?
				resource.email = b.email
				resource.brother_id = b.id
				resource.chapter = b.chapter
				resource.approved = true
				resource.chapter_manager = false
				resource.save
			else
				resource.destroy
				flash[:notice] = "A matching brother record could not be found. Does your chapter use Greek Finances yet?"
			end
		end
	end
  protected
  def after_sign_up_path_for(resource)
    new_user_session_path
  end
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

end
