class RegistrationsController < Devise::RegistrationsController
  include DonationsHelper
  def new
    if params[:token]
      @token = Token.find_by_value params[:token]
      @ext_donation = @token.ext_donation
    end
    super
  end

  def create
    build_resource(sign_up_params)

    if resource.save
      if params[:token]
        @token = Token.find_by_value params[:token]
        @ext_donation = @token.ext_donation
        resource.donations.create(
          status: "SUCCESSFUL",
          amount: @ext_donation.amount,
          note: "Converted from External Donation",
          collection_method: @ext_donation.collection_method,
          project_id: @ext_donation.project.id
        )
      end
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

end 