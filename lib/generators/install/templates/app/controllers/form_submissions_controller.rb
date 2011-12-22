class FormSubmissionsController < ApplicationController
  # GET /form_submissions
  # GET /form_submissions.json
  def index
    @form = Form.find(params[:form_id])
    @form_submissions = FormSubmission.joins(:form_schema).where("form_schemas.form_id = ?", @form.id)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @form_submissions }
    end
  end

  # GET /form_submissions/1
  # GET /form_submissions/1.json
  def show
    @form_submission = FormSubmission.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @form_submission }
    end
  end

  # GET /form_submissions/new
  # GET /form_submissions/new.json
  def new
    @form_submission = FormSubmission.new
    @form_submission.form_schema_id = Form.find(params[:form_id]).form_schemas.first.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @form_submission }
    end
  end

  # GET /form_submissions/1/edit
  def edit
    @form_submission = FormSubmission.find(params[:id])
  end

  # POST /form_submissions
  # POST /form_submissions.json
  def create
    @form_submission = FormSubmission.new(params[:form_submission])
    respond_to do |format|
      if @form_submission.save
        format.html { redirect_to @form_submission, notice: 'Form submission was successfully created.' }
        format.json { render json: @form_submission, status: :created, location: @form_submission }
      else
        format.html { render action: "new" }
        format.json { render json: @form_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /form_submissions/1
  # PUT /form_submissions/1.json
  def update
    @form_submission = FormSubmission.find(params[:id])

    respond_to do |format|
      if @form_submission.update_attributes(params[:form_submission])
        format.html { redirect_to @form_submission, notice: 'Form submission was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @form_submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /form_submissions/1
  # DELETE /form_submissions/1.json
  def destroy
    @form_submission = FormSubmission.find(params[:id])
    @form_submission.destroy

    respond_to do |format|
      format.html { redirect_to form_submissions_url }
      format.json { head :ok }
    end
  end
end
