# concerns/user_concern.rb
module UserConcern
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER = 10

  included do
    before_action :set_user, only: [:show, :edit, :update, :destroy]
  end

  def set_users_with_pagination
    page = params[:page] || DEFAULT_PAGE
    @users = User.all.page(page).per(DEFAULT_PER).sorted_by_newest
  end

  def set_users
    @users = User.all
  end

  def update_user(user)
    return false unless user.present?

    user.assign_attributes(user_params)
    user.save
  end

  # Get parameter for adding new user
  def user_params
    params.require(:user).permit(:name, :phone_number, :nickname, :image, :group_id)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
