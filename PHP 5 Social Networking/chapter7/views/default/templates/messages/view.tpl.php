			<div id="main">
			
				<div id="rightside">
				
				<ul>
					<li><a href="messages/">Your inbox</a></a>
					<li><a href="messages/create/{inbox_id}">Reply to this message</a></a>
					<li><a href="messages/delete/{inbox_id}">Delete this message</a></a>
					<li><a href="messages/create">Create a new message</a></a>
				</ul>
				</div>
				
				<div id="content">
					<h1>View message</h1>
					<table>
						<tr>
							<th>Subject</th>
							<td>{inbox_subject}</td>
						</tr>
						<tr>
							<th>From</th>
							<td>{inbox_senderName}</td>
						</tr>
						<tr>
							<th>Sent</th>
							<td>{inbox_sentFriendlyTime}</td>
						</tr>
						<tr>
							<th>Message</th>
							<td>{inbox_message}</td>
						</tr>
					</table>
				</div>
			
			</div>