class PagesController < ApplicationController
  def index
  end

  def download
  end

  def example
    @messages = Message.order('created_at desc').all
    respond_to do |format|
      format.html { render text: 'messages' }
      format.json do
        messages = []

        @messages.each do |message|
          messages << {
            subject: message.subject,
            content: message.content,
            created_at: message.created_at.strftime('%F %T'),
            from: message.sender.email,
            to: message.receiver.email
          }
        end

        render json: messages
      end
    end
  end
end
