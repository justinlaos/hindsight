defmodule Histora.Data do
  def event(user, event) do
    Segment.start_link(System.get_env("SEGMENT_API"))
    Segment.Analytics.track(user.email, event)
  end

  def identify(user) do
    Segment.start_link(System.get_env("SEGMENT_API"))
    Segment.Analytics.identify(user.email, %{organization_id: user.organization_id, role: user.role})
  end

  def group(user) do
    Segment.start_link(System.get_env("SEGMENT_API"))
    Segment.Analytics.group(user.email, user.organization_id)
  end

  def page(user, page_name) do
    Segment.start_link(System.get_env("SEGMENT_API"))
    Segment.Analytics.page(user.email, page_name)
  end

  def decision_event(user, decision) do
    Segment.start_link(System.get_env("SEGMENT_API"))
    Segment.Analytics.track(user.email, "Created Decision",
      %{
        what_string_count: String.length(decision.what),
        why_string_count: String.length(decision.what),
        has_source: (if decision.source != nil, do: true, else: false),
        has_reference: (if decision.reference != nil, do: true, else: false),
        has_reflection_date: (if decision.reflection_id != nil, do: true, else: false)
      }
    )
  end
end
