# frozen_string_literal: true

john = users.create :john,
  email: "john@example.com",
  roles: ["sprinter"],
  first_name: "John",
  last_name: "Doe",
  born_on: "1989-09-30",
  hired_on: "2020-01-01",
  slack_id: "slack-john",
  github_handle: "john-github",
  harvest_email: "john+harvest@example.com"

users.create :john_no_slack,
  email: "john-no-slack@example.com",
  roles: ["sprinter"],
  first_name: "John",
  last_name: "Doe",
  born_on: "1989-09-30",
  hired_on: "2020-01-01"

users.create :cigdem, email: "cigdem@example.com", roles: ["sprinter"], first_name: "Cigdem", last_name: "Doe"
users.create :yuki, email: "yuki@example.com", roles: ["sprinter"], first_name: "Yuki", last_name: "Doe"
users.create :zacharias, email: "zacharias@example.com", roles: ["sprinter"], first_name: "Zacharias", last_name: "Zinser"
users.create :admin, email: "admin@example.com", roles: ["hr"], first_name: "Admin", last_name: "User"

# Only John has salaries: several profit calculation specs depend on the other
# users not having any salary records.
salaries.create :john_old, user: john, valid_from: "2021-01-01", brut: 3500, net: 2777.33, hgf_hash: "c211p000e122d000l211b100o000"
salaries.create :john_current, user: john, valid_from: "2022-01-01", brut: 3800, net: 3177.33, hgf_hash: "c311p000e122d000l211b100o001"
