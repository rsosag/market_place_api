require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user_two = users(:two)
  end
  # ======= Show tests =======
  test "should show user" do
    get api_v1_user_url(@user), as: :json
    assert_response :success
    # Test to ensure response contains the correct email
    json_response = JSON.parse(response.body, symbolize_names: true)
    assert_equal @user.email, json_response.dig(:data, :attributes, :email)
    assert_equal @user.products.first.id.to_s, json_response.dig(:data, :relationships, :products, :data, 0, :id)
    assert_equal @user.products.first.title, json_response.dig(:included, 0, :attributes, :title)
  end

  # ======= Create tests =======
  test "should create user" do
    assert_difference('User.count') do
      post api_v1_users_url, params: { user: { email: 'test@test.org', password: '123456' } }, as: :json
    end
    assert_response :created
  end

  test "should not create user with taken email" do
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { email: @user.email, password: '123456' } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  # ======= Update tests =======
  test "should update user" do
    patch api_v1_user_url(@user), params: { user: { email: @user.email, password: '123456' } },
                                  headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
                                  as: :json

    assert_response :success
  end

  test "should forbid update user" do
    patch api_v1_user_url(@user), params: { user: { email: @user.email } }, as: :json
    assert_response :forbidden
  end

  test "should not update user when invalid params are sent" do
    patch api_v1_user_url(@user), params: { user: { email: 'bad_email', password: '123456' } },
                                  headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
                                  as: :json
    assert_response :unprocessable_entity
  end

  test "should not update user with taken email" do
    patch api_v1_user_url(@user_two), params: { user: { email: @user.email, password: '123456' } },
                                      headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
                                      as: :json
    assert_response :forbidden
  end

  # ======= Delete tests =======
  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user), headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
                                     as: :json
    end
    assert_response :no_content
  end

  test "should forbid destroy user" do
    assert_no_difference('User.count') do
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :forbidden
  end

end
