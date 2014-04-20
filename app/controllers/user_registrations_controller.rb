class UserRegistrationsController < Devise::RegistrationsController
  before_action :update_sanitized_params

  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      flash[:error] = resource.errors.full_messages
      redirect_to :root
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    thank_you_for_registering_path
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :household_size)}
  end

end