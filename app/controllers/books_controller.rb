class BooksController < ApplicationController
before_action :find_book, only: [:show, :edit, :update, :destroy]
# before_action :default_image, only: [:show, :edit, :update, :destroy]
# before_action :image_nil, only: [:show, :edit, :update, :destroy]


  helper_method :sort_column, :sort_direction


  #currently sorts and paginates at 3 books per page
  def index
# required for searchkick
#    term = params[:search].present? ? params[:search] : nil

  	@books = Book.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 5)
    
    #search kick if statement for search. issues with order and paginate
#    @books = if term
#      Book.search(term).order("LOWER(" + sort_column + ") " + sort_direction).paginate(:page => params[:page], :per_page => 5)
#    else
#      Book.all.order("LOWER(" + sort_column + ") " + sort_direction).paginate(:page => params[:page], :per_page => 5)
#    end
  end

  def new
  	@book = Book.new
  end

  def create
    @book = Book.new(post_params)
  	if @book.save
  		redirect_to @book
  	else
      flash.now['danger'] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def show
  	#@book = Book.find(params[:id])
  end

  def edit
  	#@book = Book.find(params[:id])
  end

  def update
    if current_user.id = @book.user_id
    	if @book.update(post_params)
    		redirect_to @book
    	else
    		render 'edit'
      end
    else
      flash.now['danger'] = "This post does not belong to you."
  	end
  end
  
  def destroy
    if current_user.id = @book.user_id
    	@book.destroy
    	redirect_to root_path
    else
      flash.now['danger'] = "This post does not belong to you."
    end
  end

  def delete_image_attachment
    @book.cover_image = ActiveStorage::Blob.find_signed(params[:id])
    @book.cover_image.purge 
    redirect_to listing_space_path(@space)
  end

  def delete_cover_image
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge # or use purge_later
    redirect_back(fallback_location: books_path)
  end

  def delete_condition_image
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge # or use purge_later
    redirect_back(fallback_location: books_path)
  end

  def autocomplete
    render json: Book.search(params[:query], {
      fields: ["title^5", "author", "description", "isbn13", "isbn10"],
      match: :word_start,
      limit: 10,
      load: false,
      misspellings: {below: 5}
    }).map(&:title)
  end

  private
  def sort_column
    Book.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  #accessor method and validation for the direction
  #used to prevent SQL injection and setting asc as default value
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def find_book
  	@book = Book.find(params[:id])
  end

  def post_params
  	params.require(:book).permit(:title, :author, :isbn13, :isbn10, :price, :user_id, :image, :remove_cover_image, :condition, :description, :cover_image, condition_images: [])
  end

  #assigns default image if user did not upload an image for book
  def default_image
    if @book.image == nil
      @book.image = "userImgDefault.png"
    end
  end

  def image_nil
    @book = Book.find(params[:id])
     if !@book.cover_image.attached?
         @book.cover_image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'fallback', 'default.png')), filename: 'default.png', content_type: 'image/png')
     end
  end  
end
