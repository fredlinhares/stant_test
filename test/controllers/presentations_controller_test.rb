require "test_helper"

class PresentationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @presentation = presentations(:trabalho_remoto_pros_e_cons)
  end

  test "should get new" do
    get new_presentation_url
    assert_response :success
  end

  test "should create presentation" do
    assert_difference("Presentation.count") do
      post presentations_url, params: {
             presentation: {
               duration_in_minutes: 35,
               is_lightning: false,
               morning: true,
               previous_presentation_id: nil,
               title: "Some very cool presentation!",
               track_id: tracks(:c).id }
           }
    end

    assert_redirected_to presentation_url(Presentation.last)
  end

  test "should show presentation" do
    get presentation_url(@presentation)
    assert_response :success
  end

  test "should get edit" do
    get edit_presentation_url(@presentation)
    assert_response :success
  end

  test "should update presentation" do
    patch presentation_url(@presentation), params: {
            presentation: {
              duration_in_minutes: 65,
              title: "Understanding remote work" }
          }
    assert_redirected_to presentation_url(@presentation)
  end

  test "should destroy presentation" do
    presentation = presentations(:codifique_menos_escreva_mais)
    assert_difference("Presentation.count", -1) do
      delete presentation_url(presentation)
    end

    assert_redirected_to presentations_url
  end
end
