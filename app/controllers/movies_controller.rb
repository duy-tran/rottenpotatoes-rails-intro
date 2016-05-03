class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    session[:ratings] = params[:ratings] || session[:ratings] || 1
    session[:sort] = params[:sort] || session[:sorts]
    if session[:sort] == 'title'
      @title_class = 'hilite'
    elsif session[:sort] == 'release_date'
      @release_class = 'hilite'
    end 
    @movies = Movie.order(session[:sort]).where("rating IN (?)",session[:ratings].keys)
    @checked_ratings = params[:ratings] = params[:ratings] || {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"}
    @session_ratings = session[:ratings]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(movies_path(ratings: session[:ratings],sort: session[:sort]))
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(movies_path(ratings: session[:ratings],sort: session[:sort]))
  end

end
