class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    impressionist(@book)
    @book_comment = BookComment.new
  end

  def index
    @books = Book.all.order(created_at: :desc).page(params[:page]).per(6)
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
   if @book.save
     flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book)
   else
    @books = Book.all
    render :index
   end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
   if @book.update(book_params)
     flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@book.id)
   else
    render :edit
   end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to "/books"
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
