class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    puts params
    @movies = Movie.with_ratings(params[:ratings])
    @movies = Movie.sort_by_col(params[:sort_by], @movies) if params[:sort_by]
    @sort_by = params[:sort_by]
    @all_ratings = Movie.all_ratings
    # set default to empty
    @ratings_to_show = []
    @ratings_to_show = params[:ratings].keys if params[:ratings]
    session[:ratings] = params[:ratings].keys if params[:ratings]
    session[:sort_by] = params[:sort_by] if params[:sort_by]
    puts(session[:ratings])
    puts(session[:sort_by])

    puts(@ratings_to_show)

    if not params.has_key?(:ratings) and not params.has_key?(:sort_by) 

      # ratings in session but sort_by is not
      if session.has_key?(:ratings) and not session.has_key?(:sort_by)
        puts 'case 1'
        redirect_to :ratings => session[:ratings].each_with_object({}) { |k, h| h[k] = 1 }
      # sort_by in session but ratings is not
      elsif session.has_key?(:sort_by) and not session.has_key?(:ratings)
        puts 'case 2'
        redirect_to :sort_by => session[:sort_by]
      # both in session
      elsif session.has_key?(:sort_by) and session.has_key?(:ratings)
        puts 'case 3'
        redirect_to :ratings => session[:ratings].each_with_object({}) { |k, h| h[k] = 1 }, :sort_by => session[:sort_by]
      end

    end
    

    # if_empty_key = Movie.with_ratings(params[:ratings])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
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
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
