#stubs for filter_table tests
class CarHelper < ActionView::Base
  include FilterTable::App::Helpers::ApplicationHelper
  #params stub
  attr_accessor :params
end

class CarsController < ActionController::Base
  include FilterTable::App::Controllers::ApplicationController
  
  attr_accessor :request, :url
  
  filter_attributes :status, :category
  
  def rescue_action(e) raise e end; 
    
  def index
    render :text => "Fusca"
  end
end


class Car
  attr_accessor :color
  
  #find :all stub
  def self.find(*arguments)
    @@cars
  end
  
  def self.colors=(colors)
    @@cars = colors.map do |color| 
      car = Car.new
      car.color = color
      car
    end
  end
  
end
