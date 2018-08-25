class MessagesController < ApplicationController
  before_action :set_conversation, only: [:index, :create]

  def index
    @messages = @conversation.messages
    if @conversation.sender_id == current_user.id
      @matching_user = User.find(@conversation.recipient_id)
    elsif @conversation.recipient_id == current_user.id
      @matching_user = User.find(@conversation.sender_id)
    end

    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end

    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.read = true
      end
    end

    @message = @conversation.messages.build
  end

  def message_link_through
    @message = Message.find(params[:id])
    @message.update read: true
    @conversation = @message.conversation
    binding.pry
    redirect_to conversation_messages_path(@conversation)
  end

  def create
    @message = @conversation.messages.build(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      render 'index'
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :user_id, :message_recipient_id)
  end
end
