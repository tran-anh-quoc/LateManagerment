class MessagesController < ApplicationController
  include MessageConcern

  before_action :set_filter, :set_messages_with_pagination, only: [:index]

  def index
    set_flash :info, (I18n.t 'messages.empty') unless @messages.any?
  end

  def show
  end

  def edit
  end

  def new
  end

  def update
  end

  def create
  end

  def destroy
  end

  private
    def set_filter
      @filters = Settings.time.filter
    end
end
