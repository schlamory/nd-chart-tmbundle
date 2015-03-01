<!-- <%= patient.last_name %>, <%= patient.first_name %>  ::  <%= date.strftime "%Y_%m_%d" %> ::  progress_note.md  -->
<% if not previous_visit.nil? and File.exists?(previous_visit.note_body_path("progress")) %>
<!-- Copied from: --><%= render_file previous_visit.note_body_path("progress") %>
<% end %>
