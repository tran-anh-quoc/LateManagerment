class Message < ActiveRecord::Base
  belongs_to :user
  # For trailing white spaces
  strip_attributes

  # Soft delete with paranoia
  acts_as_paranoid

  validates :description, length: { maximum: 255 }, presence: true

  scope :sorted_by_newest, lambda { order(created_at: :desc) }
  scope :with_time, lambda { |time|
    case time
      when 'Daily'
        where("messages.created_at >= ? AND messages.created_at <= ?", 1.day.ago, Time.now)
      when 'Weekly'
        where("messages.created_at >= ? AND messages.created_at <= ?", 7.day.ago, Time.now)
      when 'Monthly'
        where("messages.created_at >= ? AND messages.created_at <= ?", 30.day.ago, Time.now)
      end
  }

end
