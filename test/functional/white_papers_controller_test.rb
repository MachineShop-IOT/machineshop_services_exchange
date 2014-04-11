require 'test_helper'

class WhitePapersControllerTest < ActionController::TestCase
  setup do
    @white_paper = white_papers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:white_papers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create white_paper" do
    assert_difference('WhitePaper.count') do
      post :create, white_paper: {  }
    end

    assert_redirected_to white_paper_path(assigns(:white_paper))
  end

  test "should show white_paper" do
    get :show, id: @white_paper
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @white_paper
    assert_response :success
  end

  test "should update white_paper" do
    put :update, id: @white_paper, white_paper: {  }
    assert_redirected_to white_paper_path(assigns(:white_paper))
  end

  test "should destroy white_paper" do
    assert_difference('WhitePaper.count', -1) do
      delete :destroy, id: @white_paper
    end

    assert_redirected_to white_papers_path
  end
end
