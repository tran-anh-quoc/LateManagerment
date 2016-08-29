# concerns/message_concern.rb
module MessageConcern
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER = 10

  included do
    before_action :set_message, only: [:show, :edit, :update, :destroy]
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def set_messages_with_pagination
    page = params[:page] || DEFAULT_PAGE
    @messages = MessageSearch.search(search_params).page(page).per(DEFAULT_PER).sorted_by_newest
  end

  def message_params
    puts params[:message]
    params.permit(:description, :phone_number)
  end

  def search_params
    params.permit(
      :name_phone,
      :time
    )
  end
end
