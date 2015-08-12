			<div id="main">
			
				<div id="rightside">
				

				</div>
				
				<div id="content">
					<h1>Create a new group</h1>
					<form action="groups/create" method="post">
					<label for="name">Name</label><br />
					<input type="text" id="name" name="name" value="" /><br />
					<label for="description">Description</label><br />
					<textarea id="description" name="description"></textarea><br />
					<label for="type">Type</label><br />
					
					<select id="type" name="type">
						<option value="public">Public Group</option>
						<option value="private">Private Group</option>
						<option value="private-member-invite">Private (Invite Only) Group</option>
						<option value="private-self-invite">Private (Self-Invite) Group</option>
					</select><br />
					
					<input type="submit" id="create" name="create" value="Create group" />
					</form>
					
				</div>
			
			</div>