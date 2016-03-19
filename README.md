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

## License

Developed through UC Berkeley's [Computer Science Mentors](https://www.csmberkeley.github.io/), a student mentoring organization.

Copyright (c) 2016 Allan Tang, Mike Aboody, Alex Zhang. See LICENSE for details.

