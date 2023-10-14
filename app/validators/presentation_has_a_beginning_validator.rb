class PresentationHasABeginningValidator < ActiveModel::Validator
  def validate record
    if record.previous_presentation.nil? && record.track.nil?
      record.erros.add :track, "A presentation must start in a session or "/
                               "after another presentation."
    elsif !record.previous_presentation.nil? && !record.track.nil?
      record.erros.add :track, "A presentation can not start in a session and "/
                               "after another presentation at the same time."
    end
  end
end
