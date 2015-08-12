			<div id="main">
			
				<div id="rightside">
				
				<ul>
					<li><a href="messages/">Your inbox</a></a>
				</ul>
				</div>
				
				<div id="content">
					<h1>Compose message</h1>
					<form action="messages/create" method="post">
					<label for="recipient">To:</label><br />
					<select id="recipient" name="recipient">
						<!-- START recipients -->
						<option value="{ID}" {opt}>{users_name}</option>
						<!-- END recipients -->
					</select><br />
					<label for="subject">Subject:</label><br />
					<input type="text" id="subject" name="subject" value="{subject}" /><br />
					<label for="message">Message:</label><br />
					<textarea id="message" name="message"></textarea><br />
					
					<input type="submit" id="create" name="create" value="Send message" />
					</form>
					
				</div>
			
			</div>