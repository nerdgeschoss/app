# frozen_string_literal: true

namespace :heroku do
  desc "List all addons with their prices"
  task :addons do
    csv = CSV.generate(col_sep: ";") do |csv|
      csv << ["project", "app", "addon", "price"]
      JSON.parse(`heroku addons --all --json`).map do |addon|
        csv << [addon.dig("app", "name").split("-").first, addon.dig("app", "name"), addon.dig("plan", "name"), (addon.dig("plan", "price", "cents") * 0.01).to_s.tr(".", ",")]
      end
    end
    puts csv
  end
end
