# frozen_string_literal: true

class SprintFeedback::TimeDistribution
  Client = Data.define(:id, :name, :hours, :percentage, :projects).freeze
  Project = Data.define(:id, :name, :entries).freeze
  Entry = Data.define(:id, :hours, :percentage, :task).freeze
  Task = Data.define(:id, :title, :issue_number).freeze

  attr_reader :sprint_feedback

  def initialize(sprint_feedback)
    @sprint_feedback = sprint_feedback
  end

  def total_hours
    @total_hours ||= time_entries.sum(&:hours)
  end

  def clients
    @clients ||= time_entries
      .group_by(&:client_name)
      .map { |client_name, entries| build_client(client_name, entries) }
      .sort_by { -it.hours }
  end

  private

  def time_entries
    @time_entries ||= sprint_feedback.sprint.time_entries.select { it.user_id == sprint_feedback.user_id }
  end

  def build_client(client_name, entries)
    Client.new(
      id: id_for(client_name),
      name: client_name,
      hours: entries.sum(&:hours),
      percentage: percentage(entries),
      projects: build_projects(client_name, entries)
    )
  end

  def build_projects(client_name, entries)
    entries
      .group_by(&:project_name)
      .map { |project_name, project_entries| build_project(client_name, project_name, project_entries) }
      .sort_by { |project| -project.entries.sum(&:hours) }
  end

  def build_project(client_name, project_name, entries)
    Project.new(
      id: id_for(client_name, project_name),
      name: project_name,
      entries: build_entries(client_name, project_name, entries)
    )
  end

  def build_entries(client_name, project_name, entries)
    entries
      .group_by(&:task_id)
      .map do |task_id, task_entries|
        Entry.new(
          id: id_for(client_name, project_name, task_id || "none"),
          hours: task_entries.sum(&:hours),
          percentage: percentage(task_entries),
          task: build_task(task_entries.first.task_object)
        )
      end
      .sort_by { -it.hours }
  end

  def build_task(task_object)
    return nil unless task_object

    Task.new(id: task_object.id, title: task_object.title, issue_number: task_object.issue_number)
  end

  def percentage(entries)
    entries.sum(&:hours) / total_hours
  end

  def id_for(*keys)
    [sprint_feedback.id, *keys].join("/")
  end
end
