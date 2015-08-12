			<div id="main">
			
				<div id="rightside">
					<div style="text-align:center; padding-top: 5px;">
						<img src="uploads/profile/{profile_photo}" />
					</div>
					<div style="padding: 5px;">
						<h2>Friends</h2>
						<ul>
							<!-- START profile_friends_sample -->
							<li><a href="profile/view/{ID}">{users_name}</a></li>
							<!-- END profile_friends_sample -->
							<li><a href="relationships/all/{p_user_id}">View all</a></li>
							<li><a href="relationships/mutual/{p_user_id}">View mutual friends</a></li>
						</ul>
						<h2>Rest of my profile</h2>
						<ul>
							<li><a href="profile/statuses/{p_user_id}">Status updates</a></li>
						</ul>
					</div>
				</div>
				
				<div id="content"><h1>{profile_name}</h1>
					<p>{p_bio}</p>
					<h2>My Dinosaur</h2>
					<table>
						<tr>
							<th>Name</th>
							<td>{p_dino_name}</td>
						</tr>
						<tr>
							<th>DOB</th>
							<td>{p_dino_dob}</td>
						</tr>
						<tr>
							<th>Breed</th>
							<td>{p_dino_breed}</td>
						</tr>
						<tr>
							<th>Gender</th>
							<td>{p_dino_gender}</td>
						</tr>
						
					</table>
				</div>
			</div>