Pay.setup do |config|
  config.application_name = "Catering Form"
  config.business_name = "Catering Form"
  config.business_address = "Your Business Address" # Update this
  config.support_email = "support@example.com" # Update this

  config.default_product_name = "Monthly Subscription"
  config.default_plan_name = "Monthly"

  config.automount_routes = true
  config.routes_path = "/pay" # Set the path for mounted routes, e.g. /pay/webhooks

  # All processors are disabled by default. Enable the processors you want to use.
  config.enabled_processors = [:stripe]
end
