class Presentation < ApplicationRecord
  LightningRegex = /(.+)\slightning\z/
  NormalDurationRegex = /(.+)\s(\d+)min\z/
  ValidTitleRegex = /\A[^0-9]+\z/

  validates :title, presence: true, format: { with: ValidTitleRegex }
  validates :duration_in_minutes, presence: true

  before_validation :set_lightning_duration

  def self.from_string text
    case text
    when LightningRegex
      new title: $1, is_lightning: true
    when NormalDurationRegex
      new title: $1, duration_in_minutes: $2.to_i
    else
      raise ArgumentError, "argument does not match required pattern"
    end
  end

  private
  def set_lightning_duration
    self.duration_in_minutes = 5 if self.is_lightning
  end
end
