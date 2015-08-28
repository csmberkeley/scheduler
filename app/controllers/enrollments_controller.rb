class EnrollmentsController < ApplicationController
	def switch_section
		@enrollment = Enroll.find(params[:id])
		@section = Section.find(@enrollment.section_id)
		@course = Course.find(@enrollment.course_id)
		@open_sections = @section.getOtherOpenSections()
		@offer = @enrollment.getOffer
		@compatable_offers = Offer.getCompatableOffers(@section)
		@transactions = @enrollment.transactions
	end

  def new
    @enrollment = Enroll.new
    @courses = Course.all
  end

  def create
    course = Course.find_by_course_name(params[:enroll][:course_id])

    #check if the student has already been enrolled in the class
    @enrolls = current_user.enrolls
    @enrolls.each do |enroll|
      if enroll.course_id == course.id
        flash[:notice] = "You are already enrolled into this class"
        redirect_to new_enrollment_path
        return
      end
    end  

    @enrollment = Enroll.new
    course = Course.find_by_course_name(params[:enroll][:course_id])
    @enrollment.user_id = current_user.id
    @enrollment.course_id = course.id
    if @enrollment.save
      flash[:notice] = "You have been enrolled into #{course.course_name}"
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def edit
    @enrollment = Enroll.find(params[:id])
    course = Course.find(@enrollment.course_id)
    @sections = course.sections
  end

  def update
    section = Section.find_by_name(params[:enroll][:section_id])

    #check if section isn't full


    @enrollment = Enroll.find(params[:id])
    1/0
  end

  def destroy
    @enrollment = Enroll.find(params[:id])
    @course = Course.find(@enrollment.course_id)
    flash[:notice] = "You have been dropped from #{@course.course_name}"
    @enrollment.destroy
    redirect_to root_path
  end

end
