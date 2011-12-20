require "dynamite/version"
require "dynamite/railtie"
require "dynamite/engine"

require 'json'
require 'action_view'
require 'active_record'

class ActionView::Helpers::FormBuilder
    def dynamite_inputs type_partials = {}
      partials = {
        :textbox => "dynamite/textbox",
        :textarea => "dynamite/textarea",
        :email => "dynamite/email",
        :tickbox => "dynamite/tickbox"
      }.merge(type_partials)
      
      out = [];
      
      JSON.parse(@object.schema)['inputs'].each do |input|
        type = input['type'].to_sym
        value = @object.vars()[input['label']]
        is_error = !@object.errors.get(input['label'].to_sym).nil?
        if !partials[type].nil?
          out.push @template.render :partial => partials[type], :locals => {:form => self, :name => @object_name, :input => input, :value => value, :is_error => is_error}
        else
          out.push @template.render :partial => partials[:textbox], :locals => {:form => self, :name => @object_name, :input => input, :value => value, :is_error => is_error}
        end
      end
      out.join.html_safe;
    end
end

class ActiveRecord::Base
  def self.dynamite_submission_for model = :Form
    validate :vars_are_valid
    
    define_method :vars_are_valid do
      current_vars = self.vars
      JSON.parse(self.schema)['inputs'].each do |input|
        if input['type'] == 'textbox' || input['type'] == 'email' ||  input['type'] == 'textarea' || input['type'] == 'email'
          if current_vars[input['label']].strip == ""
            errors.add input['label'].to_sym, " can't be blank"
          elsif input['type'] == 'email' && !current_vars[input['label']].match(/^[^@]+@[^@]+$/)
            errors.add input['label'].to_sym, " is invalid"
          end
        end
      end
    end
    
    
    @_vars = nil

    define_method :vars do
      if !@_vars.nil? 
         @_vars
      elsif self.id.nil?
        {}
      else
        @_vars = {}
        self.form_submission_vars.each do |form_submission_var|
          @_vars[form_submission_var.key] = form_submission_var.value
        end
        @_vars
      end
    end
    
    define_method "vars=".to_sym do |hash|
      @_vars = hash
    end
    
    define_method :schema do
      self.send(Kernel.const_get(model).table_name.sub(/.$/, "")).schema
    end
    
    after_save :save_vars
    
    define_method :save_vars do
      FormSubmissionVar.delete_all(:form_submission_id  => self.id)
      @_vars.each do |key,value|
        var = FormSubmissionVar.new
        var.form_submission_id = self.id
        var.key = key
        var.value = value
        var.save
      end
    end
  end
end
