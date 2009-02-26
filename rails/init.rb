require "filter_table"
ActionController::Base.send :include, FilterTable::App::Controllers::ApplicationController
ActionView::Base.send :include, FilterTable::App::Helpers::ApplicationHelper