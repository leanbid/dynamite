


class Form < ActiveRecord::Base
  has_many :form_submissions
  has_many :form_schemas, :order => "id DESC"
  
  validates :name, :presence => true
  
  after_save :save_schema
  
  @_schema = nil
  
  def schema
    if !@_schema.nil?
      @_schema
    elsif self.id.nil?
      ""
    else
      @_schema = form_schemas.first.data
      @_schema
    end
  end
  
  def schema=(value)
    @_schema = value
  end
  
  
  def save_schema
    form_schema = FormSchema.new
    form_schema.form_id = id
    form_schema.data =  @_schema
    form_schema.save
  end

end
