# Scheduler

## Overview
CSM tutoring interface which links students and mentors together to engage in group tutoring.

#### Dependencies:
* Ruby **2.1.0** 
* Rails **4.2.5**

#### Gems:
All the gems used in this project are listed in the Gemfile, but notable ones
include:

    gem 'devise' # Sign-in and user functionality
    gem "figaro" # Secret key handler
    gem 'ckeditor' # UI for editing announcements
    gem 'bootstrap3-datetimepicker-rails' # UI for selecting a time/date
    gem 'font-awesome-sass' #Provides icons

Credits to [Glyphicons](http://glyphicons.com/) for the application icons.

## Set-up and Deployment

### To run on your local machine

Ensure that Rails and Ruby are installed on your machine. Check by running
    ruby -v; rails -v
which should display the current versions if installed correctly.

Recommendation for Windows: http://railsinstaller.org/ #Currently Ruby 2.2 is not compatible with sqlite gem, so use 2.1

Fork this repository to your own GitHub account.
Run the following command to clone to your local machine. It should look something like this:
    git clone https://github.com/azntango/scheduler

#### Generating secret keys

In order for Devise and our application to properly perform authentication, a few secret keys must be generated. It's best that you generate your own keys, put them in a file, and place that file on your own local machine. With [Figaro](https://github.com/laserlemon/figaro), these keys will be hidden from the public, and excluded from future pushes (e.g., from updates) to GitHub, as long as the file is part of the `.gitignore` file.

We've already set up Figaro and the `.gitignore`, so an easy and safe way to do generate your secret keys is to perform the following:

    .../healthy-eff$ rake secret
    e19fd9b63ab682ffa4f33677b8fb742423db788df4d256cbbb7c5...

Save the entire string somewhere, and repeat this two more times to obtain **3 strings in total**.

The default seed (check out seeds.rb in the db/ folder) has an admin account and two users. Since we would like to keep the passwords hidden from github, we put the passwords here. If you would like to change around the default users, make sure to add them to the seed file and place their passwords here. Otherwise, manage the users once you've launched the application.

Create a new blank file called `application.yml` and place it directly inside the `config/` folder. Format the file as follows:

    development:
      SECRET_KEY_BASE: <insert 1st string here>
      USERNAME: <put your username for an email account you own, see section "Mailing System">
      PASSWORD: <put your password for an email account you own, see section "Mailing System">
      ADMIN_PASS: <pick a password for admin account, you can choose>
      USER_ALLAN_PASS: <pick a password for user account, you can choose>
      USER_MIKE_PASS: <pick a password for user account, you can choose>

    test:
      SECRET_KEY_BASE: <insert 2nd string here>
      USERNAME: <put your username for an email account you own, see section "Mailing System">
      PASSWORD: <put your password for an email account you own, see section "Mailing System">
      ADMIN_PASS: <pick a password for admin account, you can choose>
      USER_ALLAN_PASS: <pick a password for user account, you can choose>
      USER_MIKE_PASS: <pick a password for user account, you can choose>

    production: 
      SECRET_KEY_BASE: <insert 3rd string here>
      USERNAME: <put your username for an email account you own (everything before the @), see section "Mailing System">
      PASSWORD: <put your password for an email account you own, see section "Mailing System">
      ADMIN_PASS: <pick a password for admin account, you can choose>
      USER_ALLAN_PASS: <pick a password for user account, you can choose>
      USER_MIKE_PASS: <pick a password for user account, you can choose>

You can to choose to generate your own strings if you'd like. Save the file once you're done.

#### Mailing System

We'll also need to set up a mailing system to invite new users to the application. You'll need to provide the following:

1. An email address
2. Password for the email
3. The host URL when you deploy on your own server

Open all three files in `config/environments/`. They all have somewhere near the top something that looks like this:

    config.action_mailer.default_url_options = { :host => 'localhost:3000' } # You'll change this for production.rb
    config.action_mailer.delivery_method = :smtp # May change this, but smtp usually the basic protocol
    config.action_mailer.perform_deliveries = true

    config.action_mailer.smtp_settings = {
        :enable_starttls_auto => true,
        :address => "smtp.gmail.com", # Depends on email service
        :port => 587,
        :domain => "gmail.com", # Depends on email service
        :authentication => :login,
        :user_name => ENV["USERNAME"], # Specifies email account. Place credientials in application.yml, don't change this
        :password => ENV["PASSWORD"] # Specifies email account password. Place credientials in application.yml, don't change this
    }

You can specify which email to use depending on the environment (`development`, `test`, `production`). You can use the same email for all three, make each one different, or any other combination you see fit. Running the machine locally (covered in this section) will use the settings provided in `development.rb`; running our tests will use `test.rb`, and running the application on a deployed web server will use `production.rb`.

Check out the current setup on these files for a concrete example. We use mailcatcher for development and testing, which provides an environment for spoofing emails.

#### Set up your initial database

We've already added most of the basics for setting up scheduler for 61A/61B/70, but feel free to change `db/seeds.rb` to configure the starting database of the application. If you want to add a new person (admin or user) before deploying, follow the examples on the `db/seeds.rb` file.

#### Final set-up

Run the following to set up the gems we've used for this project.

    .../scheduler$ bundle install

Run the following to restart the database and add in the users and courses you specified in the `db/seeds.rb`.

*** Note: this will wipe the current database and start from only the seeds. All previous activities and database transactions will be deleted. You'll probably only want to run this once for setup. ***

    .../scheduler$ rake db:reset

Start a server and enjoy!

    .../scheduler$ rails s

Visit `localhost:3000` on your favorite browser to see the application.

### To deploy onto a web server
Check out [Heroku](https://www.heroku.com/) for easy deployment (which is what we have been using).

Remember to change `config.action_mailer.default_url_options` in `config/environment/production.rb` so that the mailing system works for your web server.

## Developing On Rails

Rails applications are structured after the MVC model (Model, View, Controller), which you can find in the /app folder. This is where most of your code changes are going to go. Think of View as how the page looks (HTML), Model as the layout of how information is stored in the database (Like Object-Oriented Programming, each object having its own attributes), and the Controller as the brains of the application (Ruby) which communicates between the View and the Model. In general, one Controller per View folder, and a Controller can interact with as many Models as you want.

I would highly recommend looking at Ruby on Rails guides online if you would like to go more in depth and hopefully between having an example application, some documentation outlined below, and help from online you'll be able to make changes.

### Notable files

**db/schema.rb**: This file outlines all the necessary tables that hold all the necessary state information needed to run scheduler. In the spirit of OOP, think of each column as a separate attribute and each row as a separate object/instance. For example, the "courses" table has attributes course_name, semester, year, etc. In our current application, we have CS61A, CS61B, and CS70 so we'll have three rows in our table. More courses, more rows.

Changing this file will not add extra columns or delete columns, as this file is autogenerated just so you can look at the current layout of the database. You'll have to perform rails migrations to change the layout of the database, which you can look up how to do yourself. In general, this file is for reference only to make your life easier.

**db/seeds.rb**: This file inserts information into our tables to give us the starting point of our application. Some of the code in here is necessary for the application to run, while other information is some basic setup so that your application doesn't look bare when you first start running it. Everytime you reset the database, it runs all this code here so you'll have the same starting place everytime.

Running rake db:drop will destory your database. Running rake db:migrate will format your database. Runinng rake db:seed will run seed.rb to initialize your application to the starting state you desire, so change starting values to your liking. 

**config/routes.rb**: This file outlines what URL request talks to which Controller and what function it calls. If there are conflicting URL paths, the route closest to the bottom gets priority. The formatting of each route is as follows:
    
    <URL Verb> "<URL path>" => "<controller>#<controller_method>", as: :<shortcut_name for URL for coding purposes>
    
The **resources** key word gives you a nifty, standard-convention list of commonly used paths, given a controller name.

### Workflow
Probably the best way to show the MVC model is walking through a small part of the application - generating the home page.

#### Controller

The home page is handled by app/controller/homes_controller.rb. I'll outline important things in this code as a list.

    class HomesController < ApplicationController
        before_filter :check_logged_in

        def index
          	@enrolls = current_user.enrolls
          	@senrolls = current_user.senrolls
          	@jenrolls = current_user.jenrolls
          	@courses_to_mentor_enrolls = Hash.new([])
          	@jenrolls.each do |jenroll|
          		curr_class_name = Course.find(jenroll.course_id).course_name
          		@courses_to_mentor_enrolls[curr_class_name] = @courses_to_mentor_enrolls[curr_class_name] + [jenroll]
          	end
          	@senrolls.each do |senroll|
          		curr_class_name = Course.find(senroll.course_id).course_name
          		@courses_to_mentor_enrolls[curr_class_name] = @courses_to_mentor_enrolls[curr_class_name] + [senroll]
          	end
            @show_tabs = (@enrolls.size > 0 and (@jenrolls.size + @senrolls.size) > 0)
            if Setting.find_by(name: 'announcement').value == "1"
              @announcement = Announcement.all.first
            end
          end
        end

* **class HomesController < ApplicationController** signifies all controllers inherit from application_controller.rb. So if you want an application wide method that all other controllers can use, you can put it in application_controller.rb
* **before_filter :check_logged_in** is a method that is always run before every method called in this controller. In this case, it makes sense to make sure you are logged in before you perform any action, so we create a filter as a security parameter to ensure the user has proper authorization. The method is defined in application_controller.rb
* There is one function per HTTP request, which means one seperate function when you load a page or click a button on the webpage to save something. Here, we have one function called **index** which is called when our application load the homepage. 
    1. Optional info: Most controllers follow CRUD, which stands for Create (Add something to the app), Read (Display a value from the app), Update (Change a current value in the app), and Destroy(Delete a value in the app that outlines the basic ways users usually interact with the application. In accordance, most controllers have function definitions named show, index, new, create, edit, update, and destroy.
* The @ sign in front of variables is information you want to send to the View where it can be manipulated or displayed.
* **curr_class_name = Course.find(jenroll.course_id)** is an example of a database request. This line looks in the Course table to fine the Course row/object that matches the course a junior mentor is enrolled in. Calling **.course_name** on it takes the row/object we pulled from the database and gives us the name of the course. I'd highly recommend looking at db/schema.rb and reading up on relational databases in ruby to see how tables interact with each other (has_many, belongs_to associations are a good place to start)
    1. Optional info: Rails is great in that it takes this line and converts it into SQL for you. If you want to see the actual SQL output, look at the terminal as you are clicking around in the application. However, sometimes you can get overhead which makes some queries quite slow, a problem this application has currently with loading all the students and sections all in one page.
* At the end of execution of this function, it automatically renders the views/homes/index.html.erb. You'll know which view it renders because of the file hierarchy in the views folder, so naming convention is super important. In general, never make folders and files yourself, run **rails generate** commands to do them for you.

#### View

Now let's move on to the View (views/homes/index.html.erb) .erb stands for extended ruby, so all of this is written in html with ruby embedded in the code. I'll only show the first few lines of code.

    <% if @enrolls.size + @jenrolls.size + @senrolls.size > 0 %>
        <div class = "enroll" style = "padding-top: 5px">
            <div class="btn-group">
                <button type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="fa fa-plus"></i> Enroll
      </button>
      <ul class="dropdown-menu">
        <li><%= link_to 'Enroll As Student'.html_safe, new_enrollment_path%></li>
        <li><%= link_to 'Enroll As Mentor'.html_safe, new_jenroll_path%></li>
      </ul>
    </div>
    ...

* Everything inside <\* \*> is Ruby code you want to run on the page. With this, you can provide some form of control on what is shown using basic code control logic. Everything else is familiar HTML.
* <\*= \*> with an equal sign means this information will be displayed on the screen. Forgetting this equal sign will not show the stored ruby value on the screen, which is a common mistake. 
* Whatever you have tagged with an @ symbol in you controller, you can access that value here with using @ again
* **<%= link_to 'Enroll As Student'.html_safe, new_enrollment_path%>** shows a hyperlink that will call another controller action (usually loading a new page). The first argument is the value displayed, the second argument is a route specified in config/routes.rb (see "Notable files" section)
* CSS and Javascript are stored in the app/assets, corresponding to the controller name and view folder name.
* **<%= render "student_side" %>** will load the _student_side.html.erb file in this spot. This is so you don't have to rewrite repetitive html.erb code. These files are called **partials** and they keep your erb code clean. Stored them in the same file directory and make as many as you want!

You've made it! There's many more things going on in the background that I haven't discussed yet, but this should be enough for you to move forward!

#### What are Gems?

Gems are ways to combine other people's code into your application (for free!), which you can specify in your Gemfile. This allows for a community of Rails developers to help each other out so we don't have to re-invent the wheel everytime we want to make an Rails appplication. Check out [this](https://rubygems.org/) for all the gems that are avaliable. For this application, we used the devise gem to give us a great coding interface to handle logins and many others. If you can think of it, there's probably a gem written for it already.

## Closing Statements

Special thanks to contributors Mike Aboody and Alex Zhang for helping me code this application and spending countless hours on this side project in order to handle the mentoring logistics that CSM strives to solve. Please feel free to email us at csmberkeley@gmail.com if you have any questions about this application.

## License

Developed through UC Berkeley's [Computer Science Mentors](csmberkeley.github.io), a student mentoring organization.

Copyright (c) 2016 Allan Tang, Mike Aboody, Alex Zhang. See LICENSE for details.

