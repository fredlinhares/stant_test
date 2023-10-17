class Track < ApplicationRecord
  NetworkingMinimunTimeInMinutes = 16.hours.in_minutes.to_i
  has_many :presentations

  def last_morning_presentation
    presentation = first_monining_presentation
    return last_presentation presentation
  end

  def last_afternoon_presentation
    presentation = first_afternoon_presentation
    return last_presentation presentation
  end

  def morning_presentations &block
    presentations_loop first_monining_presentation, block
  end

  def afternoon_presentations &block
    presentations_loop first_afternoon_presentation, block
  end

  def networking_time_in_minutes
    ending = last_afternoon_presentation.ending_in_minutes
    if ending < NetworkingMinimunTimeInMinutes
      return NetworkingMinimunTimeInMinutes
    else
      return ending
    end
  end

  private
  def first_monining_presentation
    Presentation.where(track: self, morning: true)[0]
  end

  def first_afternoon_presentation
    Presentation.where(track: self, morning: false)[0]
  end

  def last_presentation presentation
    return nil if presentation.nil?
    loop do
      if presentation.next_presentation.nil?
        return presentation
      else
        presentation = presentation.next_presentation
      end
    end
  end

  def presentations_loop presentation, block
    loop do
      break if presentation.nil?
      block.call presentation
      presentation = presentation.next_presentation
    end
  end
end
