require "dynamite/version"
require "dynamite/railtie"
require "dynamite/engine"

require 'rails/generators'

module Dynamite

  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('../generators/install/templates', __FILE__)
    
    #Every public method gets executed - which is a bit wierd!
    #the 'do_installation' method could have been called 'fundito', and would have worked just the same
    #check out http://railscasts.com/episodes/218-making-generators-in-rails-3
    def do_installation
    
      copy_file "db/migrate/install_dynamite.rb", "db/migrate/#{Time.now.getutc.strftime('%Y%m%d%H%M%S')}_install_dynamite.rb"
      
      directory "app/models", "app/models"
      directory "app/controllers", "app/controllers"
      directory "app/views", "app/views"

      route "resources :forms"
      route "resources :form_submissions"
      
      directory "app/assets/stylesheets/", "app/assets/stylesheets"

      gsub_file 'app/assets/javascripts/application.js', /\Z/m do ||
        "\n//= require dynamite"
      end

      
    end
    
  end
end

class ActionView::Helpers::FormBuilder
    def dynamite_inputs type_partials = {}
      
      dir = File.expand_path('../default_partials', __FILE__)
      
      default_partials = {
        :textbox => "#{dir}/_textbox.html.erb",
        :textarea => "#{dir}/_textarea.html.erb",
        :email => "#{dir}/_email.html.erb",
        :tickbox => "#{dir}/_tickbox.html.erb"
      }
      
      out = [];
      
      JSON.parse(@object.schema)['inputs'].each do |input|
        type = input['type'].to_sym
        value = @object.vars()[input['label']]
        is_error = !@object.errors.get(input['label'].to_sym).nil?
        if !type_partials[type].nil?
          out.push @template.render :partial => partials[type], :locals => {:form => self, :name => @object_name, :input => input, :value => value, :is_error => is_error}
        elsif !default_partials[type].nil?
          out.push @template.render :file => default_partials[type], :locals => {:form => self, :name => @object_name, :input => input, :value => value, :is_error => is_error}
        else
          out.push @template.render :partial => partials[:textbox], :locals => {:form => self, :name => @object_name, :input => input, :value => value, :is_error => is_error}
        end
      end
      out.join.html_safe;
    end
end
