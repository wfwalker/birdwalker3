require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  fixtures :posts

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new, {}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, {:post => { }}, {:username => 'testuser', :login_time => Time.now.to_i}
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, :id => posts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => posts(:one).to_param}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_response :success
  end

  test "should update post" do
    post :update, {:id => posts(:one).to_param, :post => { }}, {:username => 'testuser', :login_time => Time.now.to_i}
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, {:id => posts(:one).to_param}, {:username => 'testuser', :login_time => Time.now.to_i}
    end

    assert_redirected_to posts_path
  end
end
