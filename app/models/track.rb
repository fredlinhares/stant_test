class Track < ApplicationRecord
  has_many :presentations

  def morning_presentations &block
    presentations_loop(
      Presentation.where(track: self, morning: true)[0], block)
  end

  def afternoon_presentations &block
    presentations_loop(
      Presentation.where(track: self, morning: false)[0], block)
  end

  private
  def presentations_loop presentation, block
    loop do
      break if presentation.nil?
      block.call presentation
      presentation = presentation.next_presentation
    end
  end
end
