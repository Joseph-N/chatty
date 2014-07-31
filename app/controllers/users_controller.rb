class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
      @users = User.where.not("id = ?",current_user.id)
  end
end
