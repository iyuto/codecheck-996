class Api::ProjectsController < ApplicationController
	
	def index
		@projects = Project.all
		render json: @projects
	end
	
	def show
		begin
			@project = Project.find(params[:id])
			render json: @project
		rescue
			render nothing: true, status: 404
		end
	end
	
	def create
		@project = Project.new(:url => project_params[:url], :title => project_params[:title], :description => project_params[:description])
		
		if @project.save
			render json: @project, status: :created
		else
			render json: @project.errors, status:400
		end
	end
	
	def destroy
		begin
			@project = Project.find(params[:id])
			@project.destroy
			head :no_content
		rescue
			render nothing: true, status: 404
		end
	end
	
	private
		# パラメータをカプセル化
		# :titleと:descriptionのどちらかが空の場合は400
		def project_params
			params.require(:title)
			params.require(:description)
			params.permit(:url)
			params
		end
	
end