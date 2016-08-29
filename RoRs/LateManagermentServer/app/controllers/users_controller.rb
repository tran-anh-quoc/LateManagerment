class UsersController < ApplicationController
  include UserConcern

  before_action :set_users_with_pagination, only: [:index]
  before_action :set_groups, only: [:edit, :update]

  def index
    authorize @users
    set_flash :info, (I18n.t 'messages.empty') unless @users.any?
  end

  # GET /users/1
  def show
    authorize @user
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # PATCH/PUT /users/1
  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        set_flash :success, I18n.t('users.messages.update_success')
        format.html { redirect_to @user }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /users/1
  def destroy
    authorize @user
    # High-cost operation !!!
    if @user.destroy
      set_flash :success, I18n.t('users.messages.destroy_success')
    else
      error_notice
    end

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end

  private
    def set_groups
      @groups = Group.all
    end
end
