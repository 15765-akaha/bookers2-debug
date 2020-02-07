class BooksController < ApplicationController
   before_action :authenticate_user!

  def show
    @book_new = Book.new
  	@book = Book.find(params[:id])
    @user = User.find(@book.user_id)
  end

  def index
    @book = Book.new
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
  end

  def create
  	@book = Book.new(book_params) #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
    @book.user_id = current_user.id
  	if @book.save #入力されたデータをdbに保存する。
  		flash[:notice] = "successfully created book!"
      redirect_to book_path(@book) #保存された場合の移動先を指定。
  	else
  		@books = Book.all
  		render :index
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to @book, notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render :edit
  	end
  end

  def delete
  	@book = Book.find(params[:id])
  	@book.destoy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title, :body)
  end

end
