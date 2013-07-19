class PagesController < ApplicationController
  def index
  end

  def download
  end

  def example
    @messages = Message.all
    respond_to do |format|
      format.html { render text: 'messages' }
      format.json { render json: @messages }
    end
  end
end
