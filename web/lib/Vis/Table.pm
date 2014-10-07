package Vis::Table;

use warnings;
use strict;

use Data::Uniqid qw(suniqid uniqid luniqid);

sub css {['/static/css/theme.grey.css']}
sub js  {['/static/js/jquery.tablesorter.min.js']}

sub do {
	my ($data) = @_;

	my $html = 
'
<table id="myTable" class="tablesorter-grey tablesorter">
  <thead>
    <tr>';

	foreach my $col (@{$data->[0]}) {
		$html.= "<th>$col</th>\n";
	}

	$html .=

    '</tr>
  </thead>
  <tbody>';


	shift @$data;

	foreach my $row (@$data) {
		$html .= '<tr>';
		foreach my $c (@$row) {
			$html .= "<td>$c</td>";
		}
		$html .= '</tr>';
	}

	$html .= '</tbody>
</table>

<script>
$(function(){
  $("#myTable").tablesorter();
});
</script>
';
	return $html;
}

1;

