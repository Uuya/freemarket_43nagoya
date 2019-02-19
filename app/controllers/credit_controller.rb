class CreditController < Devise::RegistrationsController

  def new
    build_resource
    yield resource if block_given?
    respond_with resource
  end

  def create
    total_sign_up_params(sign_up_params)
    build_resource(session[:user])
    session[:user] = nil
    unless resource.save
      render credit_new_path
    end
    SnsCredential.where(uid: session[:sns_user]).update(user_id: resource.id) if session[:sns_user]
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        if params[:"payjp-token"]
          Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
          Payjp::Customer.create(
            id:   current_user.id,
            card: params[:"payjp-token"]
          )
        end
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

protected

  def total_sign_up_params(sign_up_params={})
    session[:user] = session[:user].merge(sign_up_params)
  end

end
