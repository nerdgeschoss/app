# frozen_string_literal: true

class Views::Leaves::New < Components::Base
  prop :leave, Leave
  prop :permit_user_select, _Boolean, default: false
  prop :users, _Any, default: nil

  def view_template
    form_with(model: @leave, url: leaves_path, builder: ComponentFormBuilder) do |f|
      stack do
        render CalendarField.new(name: "leave[days][]", label: "Days")
        if @permit_user_select && @users
          f.select :user_id, @users.map { |u| [u.display_name, u.id] }
        end
        f.text_field :title
        f.select :type, [["Paid", "paid"], ["Sick", "sick"], ["Not working", "non_working"]]
        f.submit "Request leave"
      end
    end
  end
end
