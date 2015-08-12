			<div id="main">
			
				<div id="rightside">
				
				<ul>
					<li><a href="messages/create">Create a new message</a></a>
				</ul>
				</div>
				
				<div id="content">
					<h1>Your inbox</h1>
					<table>
						<tr>
							<th>From</th>
							<th>Subject</th>
							<th>Sent</th>
						</tr>
						<!-- START messages -->
						<tr class="{read_style}">
							<td>{sender_name}</td>
							<td><a href="messages/view/{ID}">{subject}</a></td>
							<td>{sent_friendly}</td>
						</tr>
						<!-- END messages -->
					</table>
				</div>
			
			</div>