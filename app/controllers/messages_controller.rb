class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!

    @path = conversation_path(@conversation)
    rip = current_user == @conversation.recipient ? @conversation.sender : @conversation.recipient
    PrivatePub.publish_to("/notifications" + rip.id.to_s, cid: @conversation.id, sid: current_user.id, rip:  rip.id)
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
