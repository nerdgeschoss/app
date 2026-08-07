# frozen_string_literal: true

# leave_during is derived from days in Leave's before_validation, so it is not set here.
leaves.create :john_sick_leave, user: users.john, title: "Having the Flu", type: "sick", status: "approved", days: ["2025-01-01"]
leaves.create :john_vacation, user: users.john, title: "Vacation!", type: "paid", status: "approved", days: ["2025-01-03"]
leaves.create :john_vacation_pending, user: users.john, title: "Vacation!", type: "paid", status: "pending_approval", days: ["2025-01-05"]
leaves.create :john_cross_year_vacation, user: users.john, title: "New Year Vacation", type: "paid", status: "approved",
  days: ["2024-12-30", "2024-12-31", "2025-01-01", "2025-01-02"]
