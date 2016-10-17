class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    # apply the filters here with memorization:
    if params[:ratings] 
      @selected_ratings = params[:ratings].keys
      session[:ratings] = @selected_ratings
    elsif session[:ratings]
      # use the stored settings
      @selected_ratings = session[:ratings]
    else
      # the initial case
      @selected_ratings = @all_ratings
    end
    
    sort = params[:sort] || session[:sort]
    if sort == "title"
      @css_class_title = "hilite"
      @movies = Movie.where({rating: @selected_ratings}).order("title" + " " + sort_direction)
      session[:sort] = "title"
    elsif sort == "release_date"
      @css_class_release = "hilite"
      @movies = Movie.where({rating: @selected_ratings}).order("release_date" + " " + sort_direction)
      session[:sort] = "release_date"
    else
      @movies = Movie.all.where({rating: @selected_ratings})
    end
    
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
  
  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : nil
  end

  def sort_direction
    %w[asc, desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
