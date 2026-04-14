# frozen_string_literal: true

class Components::ProjectCard < Components::Base
  prop :project, Project
  prop :current_sprint, _Nilable(Sprint), default: nil
  prop :hide_financials, _Boolean, default: false

  def view_template
    render Card.new do
      stack(size: 16) do
        render_header
        render Divider.new
        render_links
        render_details
        render_framework_versions
      end
    end
  end

  private

  def render_header
    stack(size: 4) do
      text(type: :"h5-bold") { @project.name }
      text(type: :"caption-primary-regular", color: "label-caption-secondary") do
        a(href: projects_path(customer: @project.client_name)) { @project.client_name }
      end
    end
  end

  def render_links
    return unless @project.github_url

    stack(line: :mobile) do
      render IconLink.new(title: "GitHub", icon: :github, href: @project.github_url)
    end
  end

  def render_details
    return if @hide_financials && tasks_in_sprint.nil?

    render Grid.new(gap: 8, horizontal_gap: 24, min_column_width: 230) do
      unless @hide_financials
        if @project.open_invoice_amount > 0
          value = if @project.open_invoice_count > 1
            "#{format_currency(@project.open_invoice_amount)} (#{@project.open_invoice_count})"
          else
            format_currency(@project.open_invoice_amount)
          end
          render DetailLine.new(label: "Open Invoices", value:, icon: :harvest, icon_url: @project.harvest_invoice_url)
        end

        if @project.invoiced_revenue > 0
          render DetailLine.new(label: "Invoiced Revenue", value: format_currency(@project.invoiced_revenue))
        end

        if @project.uninvoiced_revenue > 0
          render DetailLine.new(label: "Uninvoiced Revenue", value: format_currency(@project.uninvoiced_revenue))
        end

        if @project.last_invoiced
          render DetailLine.new(label: "Last Invoiced", value: I18n.l(@project.last_invoiced.to_date))
        end
      end

      if @current_sprint && tasks_in_sprint && tasks_in_sprint > 0
        render DetailLine.new(label: "Tasks in Sprint #{@current_sprint.title}", value: tasks_in_sprint.to_s)
      end
    end
  end

  def render_framework_versions
    versions = @project.framework_versions
    return if versions.blank?

    render Divider.new
    stack(size: 8, line: :mobile, align: :center, justify: :"space-between") do
      versions.sort_by { |name, _| name }.each do |name, version|
        stack(line: :mobile, size: 8) do
          render DependencyIcon.new(name:)
          text(type: :"caption-primary-regular", no_wrap: true) { version }
        end
      end
    end
  end

  def tasks_in_sprint
    @tasks_in_sprint ||= @project.tasks_in_sprint(@current_sprint)
  end

  def format_currency(amount)
    view_context.number_to_currency(amount, unit: "€", format: "%n %u")
  end
end
