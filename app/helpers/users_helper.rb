module UsersHelper
  def current_user
    return User.first
  end
end
