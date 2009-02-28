module FilterTable
  module App
    module Helpers
      module ApplicationHelper
      
        def self.included(base)
          base.class_eval do
            include InstanceMethods
          end
        end
        
        module InstanceMethods
          def filter_links_for(field, options = {})
            #validate arguments
            values = values_from_options(field, options)
            title = options.delete(:title) || field.to_s.humanize
            active_css = options.delete(:active_class) || 'filter_active'
            #title list item
            title_item = content_tag :li, title, :class => 'filter_title'
            #create the html list for filter links
            content_tag :ul, title_item + filter_items_for(field.to_s, active_css, values), :class => 'filter_list'
          end
          
          def values_from_options(field,options)
            raise ArgumentError.new("missing :values argument") unless options[:values]
            values = options.delete(:values)
            if values == :auto
              raise ArgumentError.new("missing :model argument") unless options[:model]
              values = load_distinct_values(field,options[:model])
            end
            prepare_values(values)
          end

          def load_distinct_values(field,model_name)
            klass = eval(model_name)
            klass.find(:all,:select => "DISTINCT #{field}").map(&field) if klass
          end
          
          def prepare_values(values)
            #order the hash based on values
            values = values.sort{|a,b| a[1] <=> b[1]} if values.is_a? Hash
            #remove nil
            values.delete_if{|name,value| name.nil?}
            #prepare array of values, everything as string
            values.map do |name,value|
              value = value.nil? ? name.dup : value.to_s
              #blank values are changed to -blank- keyword
              name  = BLANK_FILTER if name.blank? 
              value = BLANK_FILTER if value.blank?
              #spaces in values must be sub to --
              value.gsub! ' ', '--'
              [name,value]
            end
          end

          def filter_items_for(field, active_css, values)
            list_html = ''
            #create the list item for each filter
            values.each do |name,value|
              if already_filtered? field, value
                item = name
                item += content_tag :span, link_to('x', remove_filter_url(field, value))
                css_class = active_css
              else
                item = link_to(name, filter_url(field, value))
                item += content_tag :span, link_to('+', add_filter_url(field, value))
                css_class = nil
              end
              list_html += content_tag :li, item, :class => css_class
            end
            list_html
          end

          def already_filtered?(field,value)
            param_values = []
            param_values = params[field].split if params[field]
            params.has_key?(field) && param_values.include?(value)
          end

          def filter_url(field,value)
            url_for(params.merge({field => value, :page => nil}))
          end

          def remove_filter_url(field, value)
            params_values = []
            param_values = params[field].split if params[field]
            param_values.delete value
            new_params = params.dup
            param_values.empty? ? new_params.delete(field) : new_params[field] = param_values.join(" ")
            url_for(new_params)
          end

          def add_filter_url(field, value)
            new_value = value
            if params.has_key? field
              new_value = "#{params[field]} #{value}"
            end
            filter_url(field,new_value)
          end
        end
        
      end
    end
  end
end