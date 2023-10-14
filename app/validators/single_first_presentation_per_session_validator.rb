class SingleFirstPresentationPerSessionValidator < ActiveModel::Validator
  def validate record
    if !record.previous_presentation.nil? || record.track.nil?
      return true
    end

    case record.track.presentations.size
    when 0
      return true
    when 1
      return true if record.track.presentations[0].moring != record.morning
    when 2
      return true if record.track.presentations.include? record
    end

    record.errors.add :track, "Each track can have one initial presentation "\
                              "per session."
  end
end
