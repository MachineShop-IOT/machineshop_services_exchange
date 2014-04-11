# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
default_widgets = { user_profile:{column:1,permissions:['admin','publisher','consumer']},
                    # system_status:{column:1,permissions:['admin','publisher','consumer']},
                    # api_usage:{column:1,permissions:['admin','publisher','consumer']},
                    last_device_report:{column:2,permissions:['admin','publisher','consumer']},
                    device_overview:{column:2,permissions:['admin','publisher','consumer']},
                    rule_management:{column:2,permissions:['admin','publisher','consumer']},
                    # system_usage:{column:2,permissions:['admin','publisher','consumer']},
                    user_management:{column:2,permissions:['admin']},
                    customer_management:{column:2,permissions:['publisher']},
                    custom_api_management:{column:2,permissions:['publisher']}
                  }

default_widgets.each do |widget, details|
  column = details[:column]
  permissions = details[:permissions]
  w = Widget.create({name:widget.to_s, default_column:column})
  permissions.each do |permission|
    WidgetPermission.create({role:permission,widget_id:w.id})
  end
end

faq1 = Faq.create! question:"How do I find my API Key?", answer:"You can either check your \"My Settings\" at the top of the page or navigate to the Admin section of the Service portal."
faq2 = Faq.create! question:"Can I change my email and notification preferences?", answer:"These settings are in \"My Settings\" and also in the Admin section of the Service portal."
faq3 = Faq.create! question:"If I have a question, how do I contact you?", answer:"Submit a support ticket under the Resources section. We\'ll get right back to you."
faq4 = Faq.create! question:"Do you have example applications?", answer:"Under resources, you will find sample applications hosted on Github that you can freely download and use as templates for your application."
faq5 = Faq.create! question:"How can I find the documentation for a specific API?", answer:"There are several ways to find the API you request. You can look for them under the Services tab under the API category definitions. If you already know the API name, you can go straight to resources or type it in the search box."
faq6 = Faq.create! question:"How do I know if my device is supported?", answer:"Send us a support ticket. We can also refer you to information on how to integrate a new device or get device vendor support for your device."
faq7 = Faq.create! question:"What is your maintenance window?", answer:"We publish maintenance events directly to our registered users. We try to minimize any service disruptions by operating redundant services allowing us to upgrade seamlessly."