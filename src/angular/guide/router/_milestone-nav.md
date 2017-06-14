<strong>Milestone </strong>
<select id="router-milestone">
  <option value="1">1: Routing basics</option>
  <option value="2">2: Default, redirect and wildcard routes</option>
  <option value="3">3: Heroes feature</option>
  <option value="4">4: Crisis center feature</option>
  <option value="5">5: Router lifecycle hooks</option>
  <option value="6">6: Asynchronous routing</option>
  <option value="appendices">Appendices</option>
</select>
<script>
  $('#router-milestone').change(function() {
    var href = $(this).val();
    $(location).attr('href', href);
  });
  $('#router-milestone').val('{{include.selectedOption}}')
</script>
