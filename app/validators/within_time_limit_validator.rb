class WithinTimeLimitValidator < ActiveModel::Validator
  def validate record
    if record.beginning_in_minutes <
       Presentation::MorningSessionsEndingTimeInMinutes &&
       record.ending_in_minutes <
       Presentation::MorningSessionsEndingTimeInMinutes
      return true
    elsif record.ending_in_minutes <
          Presentation::AfternoonSessionsEndingTimeInMinutes
      return true
    end

    record.erros.add :duration_in_minutes, "A presentation can not finish "/
                                           "after the session time limit."
  end
end
