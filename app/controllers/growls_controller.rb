class GrowlsController < ApplicationController
  # def show
  #   @user = User.where(display_name: request.subdomain).first
  #   @growls = @user.get_growls(params[:type], params[:page])
  # end

  def index
    @user = User.find_by_display_name(request.subdomain)
    @growls = @user.get_growls(params[:type])#.page(params[:page])
  end

  def create
    @type = params[:growl][:type]
    @growl = current_user.relation_for(@type).new(params[:growl])
    @growl.build_meta_data(params[:meta_data]) if params[:meta_data]
    if @growl.save
      flash[:notice] = "Your #{@type.downcase} has been created."
      redirect_to dashboard_path
    else
      @growl = @growl.becomes(Growl)
      render "dashboards/show"
    end
  end
end
