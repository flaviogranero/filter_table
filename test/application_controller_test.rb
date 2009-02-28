
require File.dirname(__FILE__) + '/test_helper.rb'


class ApplicationControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = CarsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new

    ActionController::Routing::Routes.draw do |map|
      map.resources :cars
    end
  end
  
  def test_index
    get :index
    assert_response :success
  end
  
  def test_filter_attributes_status
    get :index, :status => 2
    assert_equal @controller.filter_conditions, {'status' => ['2']}
  end
  
  def test_filter_attributes_status_and_not_required_classification
    get :index, :status => 2, :classification => 'Normal'
    assert_equal @controller.filter_conditions, {'status' => ['2']}
  end
  
  def test_filter_multile_status
    get :index, :status => "1 2", :classification => 'Normal'
    assert_equal @controller.filter_conditions, {'status' => ['1','2']}
  end
  
  def test_filter_with_blank_value
    get :index, :status => "1 #{BLANK_FILTER}"
    assert_equal @controller.filter_conditions, {'status' => ['1','']}
  end
  
  def test_filter_with_a_string_value
    get :index, :category => "compact sedan"
    assert_equal @controller.filter_conditions, {'category' => ['compact','sedan']}
  end
  
  def test_filter_with_a_composed_value
    get :index, :category => "compact--suv sedan"
    assert_equal @controller.filter_conditions, {'category' => ['compact suv','sedan']}
  end
end