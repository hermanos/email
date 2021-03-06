class MessagesController < ApplicationController
  before_filter :verify_authenticity_token
 # before_filter :authenticate_user!, except: [:index, :show]
  layout 'simple'

  # GET /messages
  # GET /messages.json
  def index
    @current_folder = params[:folder] || 'inbox'
    @messages = current_user.own_messages_with_tag(@current_folder).sort_by { |message| message.created_at }.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        messages = []

        @messages.each do |message|
          messages << {
            subject: message.subject,
            content: message.content,
            created_at: message.created_at.strftime('%F %T'),
            from: message.sender.email,
            to: message.receiver.email,
            id: message.id,
            folder: @current_folder
          }
        end

        render json: messages
      end
    end
  end 

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])
    @message.update_read_status

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.json
  def create
    @receiver = User.find_by_email(params[:message][:receiver])
    unless @receiver.nil?
      @message = Message.new(sender_id: current_user.id, receiver_id: @receiver.id, subject: params[:message][:subject], content: params[:message][:content])

      respond_to do |format|
        if @message.save
          format.html { redirect_to messages_path, notice: 'Message was successfully created.' }
          format.json { render json: @message, status: :created, location: @message }
        else
          format.html { render action: "new" }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

end
