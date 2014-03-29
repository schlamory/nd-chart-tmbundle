

<% patient.medications.each do |m| %>
- <%= m.name %> <%= "(#{m.dose})" unless m.dose.nil? %>  <%= "[#{m.note}]" unless m.note.nil? %>
<% end %>
