class Api::UsersController < Api::BaseController
  include UserConcern

  def index
    @users = User.all
  end

  def show
  end

  def create
    render template: 'api/shared/success'
  end

  def update
    render template: 'api/shared/success'
  end

  def destroy
    @user.destroy
    render template: 'api/shared/success'
  end
end
