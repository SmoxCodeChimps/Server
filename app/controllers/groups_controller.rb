class GroupsController < ApplicationController

	skip_before_action :verify_authenticity_token
	def create
		@group = Group.new(groups_paramsweb)

		response= helpers.party_post(@group)

		body = JSON.parse(response.response.body)
		tracker_id = body["target_id"]
	
		@group.tracker_id = tracker_id
		#helpers.party_get()
		
		if @group.save
			redirect_to @group
		else
			render :action => "new"
		end

	end

	def new
		@group = Group.new
	end

	def index
		@groups = Group.all
	end

	def show
		@group = Group.find(params[:id])
		render :json => @group
	end

	def update
		@group = Group.find(params[:id])
		if @group.update(groups_paramsweb)
			response= helpers.send_update(@group)
			@group.save
      		redirect_to @group
    	else
      		render 'edit'
      	end
    end

    def edit
    	
    	@group = Group.find(params[:id])
    end

    def destroy
	    @group = Group.find(params[:id])
	    @group.destroy
	 
	    redirect_to groups_path
 	end

 	def portrait
 		group = Group.find_by_tracker_name(params[:id])
 		@image = url_for(group.portrait)
 		render :json => @image
 		
 	end

 	def tracker
 		group = Group.find_by_tracker_name(params[:id])
 		@image = url_for(group.tracker)
 		render :json => @image
 		#render template: "groups/image.html.haml"

 	end

 	def join
 		@group = Group.find(params[:id])
 		user = current_user
 		users_count = @group.users.size
 		@uss = User.find(user.id)

 		if users_count < 5
 			@group.users << @uss
 			@group.save
 			@uss.group_id = @group.id
 			@uss.save
 			puts "USER ADDED"
 		end
 	end
 	def leaveGroup
      @group = Group.find(params[:id])
 	  @user = current_user
 	  @group.users.delete(User.find(@user.id))
 	  @user.group_id = :null
 	  @user.save
 	  @group.save

    end

 	def appCreate
 		@group = Group.new()
 		@group.name = params[:name]
 		@group.tracker_name = params[:tracker_name]
 		@group.tracker = params[:tracker]
 		@group.portrait = params[:portrait]
		response= helpers.party_post(@group)

		body = JSON.parse(response.response.body)
		tracker_id = body["target_id"]
		@group.tracker_id = tracker_id
		puts "AAAAAAA"
		puts current_user
		@user = User.find(params[:user_id])
		@user.group_id = @group.id
		@group.users << @user
		@group.save

 	end

 	def appEdit
 		@group = Group.find(params[:id])
 		@group.tracker = params[:tracker]
 		@group.portrait = params[:portrait]
		response= helpers.send_update(@group)
		@group.save
		render :json => @group
 	end

 	def appIndex
 		@groups = Group.all
 		render :json => @groups
 	end

 	def compas
 		@group = Group.find(params[:id])
 		render :json => @group.users
 	end

	private

	def groups_params
		params.permit(:name, :tracker_name, :tracker_id,:tracker, :portrait, :id,:user_id)
	end

	def groups_paramsweb
		params.require(:group).permit(:name, :tracker_name, :tracker_id,:tracker, :portrait, :id)
	end
end
