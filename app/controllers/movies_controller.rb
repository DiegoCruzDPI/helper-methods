class MoviesController < ApplicationController

  def new
    @movie = Movie.new

    #bcause we know that .html.erb is internal, rudy does not need us to explicityly say "movies/new.html.erb"

    #also, if the name of the folder matches the name of the conroller and the action name matches the name of the template, we can delete all of this
    # you have to be very mindful of this, however, because if you ommit it prematurely it will break

    #the two match so we dont even need to include it in the action at all
    # render  "movies/new"

  end

  def index
    @movies = Movie.order( created_at: :desc )

    respond_to do |format|
      format.json do
        render json: @movies
      end

      format.html do
    
      end
    end
  end

  def show
    # @movie = Moive.where(id: params.fetch(:id)).first
#.find will go to the movies table and pull out the :id for us. It also gives us a more clear error message when there is no id in the record
    @movie = Movie.find(params.fetch(:id))
 
  end

  def create

    #boom! MASS ASSIGNMENT!!!! .new can get multple hashes and assign them values for us. So :title and :descrption are automatically taken care of 
    # for us when we params.fetch(:movie)

    #//for security, we need .require(:movie).permit(title,:title) in order to retrieve user input. 
    #not doing so will result in a Forbidden attributes erro and frogetting one will give us a Unpermitted parameter: :description error in our terminal
    movie_attributes = params.require(:movie).permit(:title,:description)

    @movie = Movie.new(movie_attributes)

#Here we were fetching the :movie and :title/:description to get a hash within a hash
    # @movie = Movie.new
    # @movie.title = params.fetch(:movie).fetch(:title)
    # @movie.description = params.fetch(:movie).fetch(:description)

    if @movie.valid?
      @movie.save
      #we use the _url versions of our paths in our controllers!!! We want the full _url to render here in the server!!!
      redirect_to(movies_url, { :notice => "Movie created successfully." })
    else
      #we need to have new here still because the action is not the same as the template!!!
      render  "new"
    end
  end

  def edit
    @movie = Movie.find(params.fetch(:id))
  end

  def update
    @movie = Movie.find(params.fetch(:id))
   movie_params = params.require(:movie).permit(:title,:description)

   @movie.update(movie_params)

    if @movie.valid?
      @movie.save
      redirect_to(movie_url(@movie), { :notice => "Movie updated successfully."} )
    else
      redirect_to(movie_url(@movie), { :alert => "Movie failed to update successfully." })
    end
  end

  def destroy
    @movie = Movie.find(params.fetch(:id))

    @movie.destroy

    redirect_to(movies_url, { :notice => "Movie deleted successfully."} )
  end
end
