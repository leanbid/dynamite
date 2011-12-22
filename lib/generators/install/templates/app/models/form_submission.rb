
class FormSubmission < ActiveRecord::Base
  belongs_to :form_schema
  has_one :form, :through => :form_schema
  has_many :form_vars
  
  validate :vars_are_valid
    
  def vars_are_valid 
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

  def vars
    if !@_vars.nil? 
       @_vars
    elsif self.id.nil?
      {}
    else
      @_vars = {}
      self.form_vars.each do |form_var|
        @_vars[form_var.key] = form_var.value
      end
      @_vars
    end
  end
  
  def vars=(hash)
    @_vars = hash
  end
  
  def schema
    FormSchema.where(:id => form_schema_id).first.data
  end
  
  after_save :save_vars
  def save_vars 
    FormVar.delete_all(:form_submission_id  => self.id)
    @_vars.each do |key,value|
      var = FormVar.new
      var.form_submission_id = self.id
      var.key = key
      var.value = value
      var.save
    end
  end

end
