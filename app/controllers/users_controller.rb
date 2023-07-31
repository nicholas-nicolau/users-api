class UsersController < ApplicationController

  def index
    @searcher = UserSearcher.new(search_params)

    @users = @searcher.search
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    service = UserService.new(user_params)

    service.create

    if service.success?
      render json: { id: service.record.id }, status: :created
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def update
    service = UserService.new(user_params)

    service.update(params[:id])

    if service.success?
      head :ok
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    service = UserService.new

    service.destroy(params[:id])

    if service.success?
      head :no_content
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def search_params
    params.permit(:sort_direction, :sort_by, :page_size, :page_number, :term, :request_from_api)
  end

  def user_params
    params.permit(:age, :name, :email)
  end
end
