require File.dirname(__FILE__) + '/test_helper.rb'

class ApplicationHelperTest < Test::Unit::TestCase
  
  def setup
    @request    = ActionController::TestRequest.new
    @controller = CarsController.new
    @controller.request = @request
    # Fake url rewriter so we can test url_for
    @controller.url = ActionController::UrlRewriter.new @request, {}
    
    @helper = CarHelper.new
    @helper.controller = @controller
    
    @helper.params = {:controller => :cars, :action => :index}
  end
  
  #test arguments required
  def test_values_required
    assert_raise(ArgumentError) do
      @helper.filter_links_for :status
    end
  end
  
  def test_model_required
    assert_raise(ArgumentError) do
      @helper.filter_links_for :status, :values => :auto
    end
  end
  
  def test_filter_links_for_enum
    html = @helper.filter_links_for :status, :title => 'Car State', :values => {"Normal" => 0, "Broken" => 1, "Running" => 2}
    assert html.include?('<a href="/cars?status=0">Normal</a>')
    assert html.include?('<a href="/cars?status=1">Broken</a>')
    assert html.include?('<a href="/cars?status=2">Running</a>')
    assert html.include?('<li class="filter_title">Car State</li>')
  end
  
  def test_filter_links_for_array_of_strings
    html = @helper.filter_links_for :category, :values => ['compact','sedan', 'compact suv']
    assert html.include?('<a href="/cars?category=compact">compact</a>')
    assert html.include?('<a href="/cars?category=sedan">sedan</a>')
    assert html.include?('<a href="/cars?category=compact--suv">compact suv</a>')
    assert html.include?('<li class="filter_title">Category</li>')
  end
  
  def test_filter_links_with_filter_applyed
    @helper.params = {:controller => :cars, :action => :index, 'status' => '0'}
    
    html = @helper.filter_links_for :status, :title => 'Car State', :values => {"Normal" => 0, "Broken" => 1, "Running" => 2}
    
    assert html.include?('<a href="/cars?status=0+1">+</a>')
    assert html.include?('<a href="/cars?status=0+2">+</a>')
    assert html.include?('<a href="/cars">x</a>')
    assert html.include?('<li class="filter_title">Car State</li>')
  end
  
  def test_auto_filter_links
    Car.colors = ["silver","black","white"]
    html = @helper.filter_links_for :color, :values => :auto, :model => 'Car'
    assert html.include?('<a href="/cars?color=silver">silver</a>')
    assert html.include?('<a href="/cars?color=black">black</a>')
    assert html.include?('<a href="/cars?color=white">white</a>')
    assert html.include?('<li class="filter_title">Color</li>')
  end
  
end