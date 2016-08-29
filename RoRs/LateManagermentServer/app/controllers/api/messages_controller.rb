class Api::MessagesController < Api::BaseController
  include MessageConcern

  def index
    @messages = Message.all
  end

  def show
  end

  def create
    created = create_message
    if created
      render action: :show
    else
      error_400
    end
  end

  private
    def set_user(number)
      user = User.where(phone_number: number).first
    end

    def get_phone_number(message)
      split_messages = message.split('-')
      old_phone_number = nil
      if split_messages.count > 1
        old_phone_number = split_messages.first.delete(' ')
        if old_phone_number[0] == '0'
          old_phone_number[0] = '+84'
        end
      end
      old_phone_number
    end

    def create_message
      if validate_params
        user = set_user(params[:phone_number])
        if !user
          old_phone_number = get_phone_number(params[:description])
          if old_phone_number
            user = set_user(old_phone_number)
          end
        end

        @message = Message.new(message_params)
        if !user
          @message.user_id = 1000000001
        else
          @message.user_id = user.id
        end
        @message.save
      else
        false
      end
    end

    def validate_params
      if params[:phone_number].present? && params[:description].present?
        true
      else
        false
      end
    end
end
