require 'test_helper'

class TaxonsControllerTest < ActionController::TestCase
  fixtures :taxons

  setup do
    @taxon = taxons(:taxon_one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:all_taxons_seen)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taxon" do
    assert_difference('Taxon.count') do
      post :create, {:taxon => { category: 'species', common_name: 'Newbird', family: 'Newus Familius', latin_name: 'Newus Birdus', order: 'Newus Orderus', range: '', sort: 998 }}, {:username => 'testuser', :login_time => Time.now.to_i}
    end

    assert_redirected_to taxon_path(assigns(:taxon))
  end

  test "should show taxon" do
    get :show, id: @taxon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @taxon
    assert_response :success
  end

  test "should update taxon" do
    put :update, id: @taxon, taxon: { category: @taxon.category, common_name: @taxon.common_name, family: @taxon.family, latin_name: @taxon.latin_name, order: @taxon.order, range: @taxon.range, sort: @taxon.sort }
    assert_redirected_to taxon_path(assigns(:taxon))
  end

  test "should destroy taxon" do
    assert_difference('Taxon.count', -1) do
      delete :destroy, id: @taxon
    end

    assert_redirected_to taxons_path
  end
end
