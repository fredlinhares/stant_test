module PresentationListsParser
  TrackHandler = Struct.new(
    "TrackHandler", :track, :available_morning_time, :available_afternoon_time)

  def self.parse file_path
    ActiveRecord::Base.transaction do
      presentation_list, total_time_in_minutes = read_file file_path
      tracks = create_tracks total_time_in_minutes
      sort_presentations tracks, presentation_list
    end
  end

  private
  def self.read_file file_path
    presentation_list = []
    total_time_in_minutes = 0

    File.foreach file_path do |line|
      presentation = Presentation.from_string line.chop
      presentation_list << presentation
      presentation.duration_in_minutes = 5 if presentation.is_lightning
      total_time_in_minutes += presentation.duration_in_minutes
    end

    return presentation_list, total_time_in_minutes
  end

  def self.create_tracks total_time_in_minutes
    number_of_tracks = total_time_in_minutes / track_duration
    number_of_tracks += 1 if total_time_in_minutes % track_duration > 0
    tracks = number_of_tracks.times.map do
      TrackHandler.new Track.create!, morning_duration, afternoon_duration
    end
    return tracks
  end

  def self.sort_presentations tracks, presentation_list
    presentation_list.each do |presentation|
      tracks.each do |track_handler|
        if presentation.duration_in_minutes <=
           track_handler.available_morning_time
          track_handler.available_morning_time -=
            presentation.duration_in_minutes
          add_to_last_presentation track_handler.track, presentation, true
          break
        elsif presentation.duration_in_minutes <=
              track_handler.available_afternoon_time
          track_handler.available_afternoon_time -=
            presentation.duration_in_minutes
          add_to_last_presentation track_handler.track, presentation, false
          break
        end
      end
    end
  end

  def self.add_to_last_presentation track, presentation, morning
    presentation.morning = morning

    if morning
      last_presentation = track.last_morning_presentation
    else
      last_presentation = track.last_afternoon_presentation
    end

    if last_presentation == nil
      presentation.track = track
    else
      presentation.previous_presentation = last_presentation
    end
    presentation.save!
  end

  def self.track_duration
    return morning_duration + afternoon_duration
  end

  def self.morning_duration
    return (Presentation::MorningSessionsEndingTimeInMinutes -
            Presentation::MorningSessionsBeginningTimeInMinutes)
  end

  def self.afternoon_duration
    return (Presentation::AfternoonSessionsEndingTimeInMinutes -
            Presentation::AfternoonSessionsBeginningTimeInMinutes)
  end
end
