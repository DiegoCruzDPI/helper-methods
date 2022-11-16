class MoviesController < ApplicationController
  def new
    @the_movie = Movie.new

    #bcause we know that .html.erb is internal, rudy does not need us to explicityly say "movies/new.html.erb"

    #also, if the name of the folder matches the name of the conroller and the action name matches the name of the template, we can delete all of this
    # you have to be very mindful of this, however, because if you ommit it prematurely it will break

    #the two match so we dont even need to include it in the action at all
    # render  "movies/new"

  end

  def index
    matching_movies = Movie.all

    @list_of_movies = matching_movies.order({ :created_at => :desc })

    respond_to do |format|
      format.json do
        render json: @list_of_movies
      end

      format.html do
    
      end
    end
  end

  def show
    the_id = params.fetch(:id)

    matching_movies = Movie.where({ :id => the_id })

    @the_movie = matching_movies.first
 
  end

  def create
    @the_movie = Movie.new
    @the_movie.title = params.fetch("query_title")
    @the_movie.description = params.fetch("query_description")

    if @the_movie.valid?
      @the_movie.save
      #we use the _url versions of our paths in our controllers!!! We want the full _url to render here in the server!!!
      redirect_to(movies_url, { :notice => "Movie created successfully." })
    else
      #we need to have new here still because the action is not the same as the template!!!
      render  "new"
    end
  end

  def edit
    the_id = params.fetch(:id)

    matching_movies = Movie.where({ :id => the_id })

    @the_movie = matching_movies.first

  end

  def update
    the_id = params.fetch(:id)
    the_movie = Movie.where({ :id => the_id }).first

    the_movie.title = params.fetch("query_title")
    the_movie.description = params.fetch("query_description")

    if the_movie.valid?
      the_movie.save
      redirect_to(movie_url(the_movie), { :notice => "Movie updated successfully."} )
    else
      redirect_to(movie_url(the_movie), { :alert => "Movie failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch(:id)
    the_movie = Movie.where({ :id => the_id }).first

    the_movie.destroy

    redirect_to(movies_url, { :notice => "Movie deleted successfully."} )
  end
end
