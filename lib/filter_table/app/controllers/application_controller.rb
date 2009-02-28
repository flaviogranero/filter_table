module FilterTable
  module App
    module Controllers
      module ApplicationController

        def self.included(base)
          base.class_eval do
            include InstanceMethods
            extend ClassMethods
          end
        end
        
        module ClassMethods
          
          def filter_attributes(*args)
            define_filter_conditions(args.map(&:to_s))
          end

          def define_filter_conditions(acceptable_columns)
            define_method(:filter_conditions) do |*default| 
              conditions = {}
              params.each do |key,value|
                if acceptable_columns.include? key
                  conditions[key] = value.split
                  conditions[key] << '' if conditions[key].delete BLANK_FILTER
                  #replace -- by space char
                  conditions[key].collect{|value| value.gsub! '--', ' '}
                end
              end
              conditions
            end
          end
        end
        
        module InstanceMethods
          
        end

      end
    end
  end  
end


