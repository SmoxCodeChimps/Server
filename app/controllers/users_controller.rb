class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
   def create
      @user = User.new(user_paramsweb)
      @user.group_id = :null
      if @user.save
        redirect_to @user
      else
        render :action => "new"
      end
    end
    
    def new
      @user = User.new
    end

    def show
      @user = User.find(params[:id])
    end
    def index
      @users = User.all
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id])
      if @user.update(groups_params)
            redirect_to @user
        else
            render 'edit'
        end
    end

     def destroy
      @user = User.find(params[:id])
      @user.destroy
   
      redirect_to users_path
  end

    def appCreate

      @user = User.new()
      @user.username = params[:username]
      @user.email = params[:email]
      @user.password = params[:password]
      @user.group_id = params[:group_id]
      if @user.save
        helpers.login @user
      end

    end

    def groop
      user = current_user
      @group_id = user.group_id
      render :json => @group_id
    end

    def getUser
      render :json => current_user
    end

    def appEdit
      @user = User.find(params[:id])
      if params[:username]
        @user.username = params[:username]
      end
      if params[:password]
        @user.password = params[:password] 
      end
      @user.save
      render :json => @user
  end

   def user_params
     params.permit(:username, :email, :password,:group_id,:id,:user)
   end

   def user_paramsweb
     params.require(:user).permit(:username, :email, :password,:group_id,:id)
   end
end