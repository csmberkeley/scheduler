class EnrollmentsController < ApplicationController
	def switch_section
		#enrollment works here
		@enrollment = Enroll.find(params[:id])
		@section = Section.find(@enrollment.section_id)
		@course = Course.find(@enrollment.course_id)
		@open_sections = @section.getOtherOpenSections()
		@offer = @enrollment.offer
		@compatable_offers = Offer.getCompatableOffers(@section)
		@transactions = @enrollment.getTransactionsInReverseOrder
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

    #check that current user isn't editing an enrollment he/she doesn't own
    if @enrollment.user_id != current_user.id
      flash[:notice] = "Forbbiden access. Use the switch section button to change sections"
      redirect_to root_path
      return
    end

    course = Course.find(@enrollment.course_id)
    @sections = course.sections

  end

  def update
    section = Section.find_by_name(params[:enroll][:section_id])
    enrollment = Enroll.find(params[:id])

    #check if section isn't full
    if section.enrolls.size >= 5
      flash[:notice] = "Current section you selected has been filled up."
      redirect_to edit_enrollment_path(params[:id])
      return
    end

    #check if student already enrolled into this section
    curr_enrolls = section.enrolls.to_ary()
    current_user.enrolls.each do |enroll|
      if curr_enrolls.include?(enroll)
        flash[:notice] = "You are already enrolled into this section"
        redirect_to root_path
        return
      end
    end

    #check if student is already enrolled into another section in the same class
    if not enrollment.section_id.nil?
      flash[:notice] = "You are already enrolled into another section in this class"
      redirect_to root_path
      return
    end

    #safe to enroll
    enrollment.section_id = section.id
    section.enrolls << enrollment
    if enrollment.save! and section.save!
      flash[:notice] = "You have signed up for #{section.name}"
      redirect_to root_path
      return
    else
      flash[:notice] = "Couldn't sign up for section. Try again"
      redirect_to root_path
      return
    end
  end

  def destroy
    @enrollment = Enroll.find(params[:id])
    @course = Course.find(@enrollment.course_id)
    flash[:notice] = "You have been dropped from #{@course.course_name}"
    @enrollment.destroy
    redirect_to root_path
  end

end
