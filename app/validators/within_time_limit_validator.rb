class WithinTimeLimitValidator < ActiveModel::Validator
  MorningSessionsEndingTimeInMinutes = 12.hours.in_minutes.to_i
  AfternoonSessionsEndingTimeInMinutes = 17.hours.in_minutes.to_i

  def validate record
    if record.beginning_in_minutes < MorningSessionsEndingTimeInMinutes &&
       record.ending_in_minutes < MorningSessionsEndingTimeInMinutes
      return true
    elsif record.ending_in_minutes < AfternoonSessionsEndingTimeInMinutes
      return true
    end

    record.erros.add :duration_in_minutes, "A presentation can not finish "/
                                           "after the session time limit."
  end
end
