module ApplicationHelper
  def fancy_time_from_minutes time
    ("%02d" % (time / 60)) +
      ":" +
      ("%02d" % (time % 60)) +
      "H"
  end
end
