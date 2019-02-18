class MembershipController < Devise::RegistrationsController

  def new
    build_resource
    yield resource if block_given?
    respond_with resource
  end

  def create
    total_sign_up_params(sign_up_params)
    if build_resource(sign_up_params).valid?(:registration_step_1) && verify_recaptcha
      build_resource(sign_up_params)
      redirect_to  phone_new_path
    else
      resource_class.new(sign_up_params)
      render  membership_new_path
    end
  end

protected

  def total_sign_up_params(sign_up_params={})
    session[:user] = sign_up_params
  end

end
