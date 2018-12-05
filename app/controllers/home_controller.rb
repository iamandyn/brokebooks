class HomeController < ApplicationController
  def index
  	@books = Book.last(6)

  	@books1 = @books.first(3)
  	@books2 = @books.last(3)
  end
end