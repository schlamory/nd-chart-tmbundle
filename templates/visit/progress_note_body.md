<!-- <%= patient.last_name %>, <%= patient.first_name %>  ::  <%= date.strftime "%Y_%m_%d" %> ::  progress_note.md  -->
<% unless previous_visit.nil? %>
<!-- Copied from: --><%= render_file previous_visit.progress_note_body_path %>
<% end %>
