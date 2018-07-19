class WordsController < ApplicationController
  respond_to :json

  def index
    respond_with Word.all
  end

  def show
    respond_with Word.find(params[:id])
  end

  def create
    respond_with Word.create(word_params)
  end

  def update
    word = Word.find(params[:id])
    respond_with word.update_attributes(word_params)
  end

  def destroy
    respond_with Word.destroy(params[:id])
  end

  private
    def word_params
      params.require(:word).permit(:word, :definition)
    end
end
