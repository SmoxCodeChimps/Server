module SessionsHelper
	def authenticate(username, password)
		@user = User.find_by_username(username)
		if !@user.nil?
			if @user.password == password
				return @user
			end
		end
		return nil
	end

	def login(user)
		session[:current_user_id] = user.id
	end
end
