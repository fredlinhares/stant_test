require "test_helper"

class PresentationTest < ActiveSupport::TestCase
  test "if lightning have 5 minutes" do
    presentation = Presentation.from_string(
      "Rails para usuários de Django lightning")
    presentation.save

    assert presentation.valid?
    assert_equal 5, presentation.duration_in_minutes
  end

  test "presentation is invalid when title have numbers" do
    presentation = Presentation.from_string(
      "The 3 rules for a better code 45min")
    presentation.save

    assert presentation.invalid?
  end

  test "extracts the correct time and title" do
    presentation = Presentation.from_string(
      "Clojure engoliu Scala: migrando minha aplicação 45min")
    presentation.save

    assert presentation.valid?
    assert_equal 45, presentation.duration_in_minutes
    assert_equal(
      "Clojure engoliu Scala: migrando minha aplicação",
      presentation.title)
  end
end
