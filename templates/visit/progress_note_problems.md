

<% patient.problems.each do |p| %>
- <%= p.diagnosis %> <%= "(#{p.icd9})" unless p.icd9.nil? %> <%= "[#{p.note}]" unless p.note.nil? %>
<% end %>
