class Api::ProjectsController < ApplicationController
	
	def index
		@projects = Project.all
		render json: @projects
	end
	
	def show
		begin
			@project = Project.find(params[:id])
		rescue
			render status: 404
		end
		render json: @project
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
		rescue
			render status: 404
		end
		@project.destroy
		head :no_content
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