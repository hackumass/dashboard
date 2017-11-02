namespace :template_email do



  task :send => :environment do
    email_count = 0

    app_mailing_list = EventApplication.where('university=? OR university=?', 'University of Massachusetts Amherst', 'UMass Amherst').where(:application_status => 'accepted').where(:rsvp => false)


    app_mailing_list.each do |app|
      email_count += 1
    end

    puts '--------------------------'
    puts "Number UMass students that didn't rsvp: #{email_count}"
  end

end
