class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    if user
      session[:user_id] = user.id
      notice = 'Welcome'
    else
      notice = 'You’re not authorized'
    end

    redirect_to root_path, flash: {notice: notice}
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
