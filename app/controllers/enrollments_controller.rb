class EnrollmentsController < ApplicationController
	def switch_section
		@enrollment = Enroll.find(params[:id])
		@section = Section.find(@enrollment.section_id)
		@course = Course.find(@enrollment.course_id)
		@open_sections = @section.getOtherOpenSections()
		@offer = Offer.getUserOfferFromSection(current_user, @section)
		@compatable_offers = Offer.getCompatableOffers(@section)
	end

  def show

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
      
    end  


    @enrollment = Enroll.new(enroll_params)
    course = Course.find_by_course_name(params[:enroll][:course_id])
    if @enrollment.save
      flash[:notice] = "You have been enrolled into #{course.course_name}"
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def edit
    @enrollment = Enroll.new
    @courses = Course.all
  end

  def update

  end

  def destroy

  end

  private

  def enroll_params
    params.require(:enroll).permit(:user_id, :course_id, :section_id)
  end
end
