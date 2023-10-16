class Presentation < ApplicationRecord
  MorningSessionsBeginningTimeInMinutes = 9.hours.in_minutes.to_i
  AfternoonSessionsBeginningTimeInMinutes = 13.hours.in_minutes.to_i

  MorningSessionsEndingTimeInMinutes = 12.hours.in_minutes.to_i
  AfternoonSessionsEndingTimeInMinutes = 17.hours.in_minutes.to_i

  LightningRegex = /(.+)\slightning\z/
  NormalDurationRegex = /(.+)\s(\d+)min\z/
  ValidTitleRegex = /\A[^0-9]+\z/

  belongs_to :track, optional: true
  belongs_to :previous_presentation, class_name: "Presentation", optional: true
  has_one(:next_presentation, class_name: "Presentation",
          foreign_key: :previous_presentation_id)

  validates :title, presence: true, format: { with: ValidTitleRegex }
  validates :duration_in_minutes, presence: true
  validates_with PresentationHasABeginningValidator
  validates_with SingleFirstPresentationPerSessionValidator
  validates_with WithinTimeLimitValidator

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

  def beginning_in_minutes
    if !self.track.nil?
      if self.morning
        return MorningSessionsBeginningTimeInMinutes
      else
        return AfternoonSessionsBeginningTimeInMinutes
      end
    elsif self.previous_presentation.nil?
      return 0
    else
      self.previous_presentation.ending_in_minutes
    end
  end

  def ending_in_minutes
    self.beginning_in_minutes + self.duration_in_minutes
  end

  private
  def set_lightning_duration
    self.duration_in_minutes = 5 if self.is_lightning
  end
end
