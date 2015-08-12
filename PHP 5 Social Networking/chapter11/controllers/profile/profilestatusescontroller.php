<?php

class Profilestatusescontroller {
	
	public function __construct( $registry, $directCall=true, $user )
	{
		$this->registry = $registry;
		$this->listRecentStatuses( $user );
	}
	
	/**
	 * List recent statuses on a users profile
	 * @param int $user the user whose profile we are viewing
	 * @return void
	 */
	private function listRecentStatuses( $user )
	{
		// load the template
		$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'profile/statuses/list.tpl.php', 'footer.tpl.php');
		
		
		
		// post status / public message box
		if( $this->registry->getObject('authenticate')->isLoggedIn() == true )
		{
			if( isset( $_POST ) && count( $_POST ) > 0 )
			{
				$this->addStatus( $user );
			}
			$loggedInUser = $this->registry->getObject('authenticate')->getUser()->getUserID();
			if( $loggedInUser == $user )
			{
				$this->registry->getObject('template')->addTemplateBit( 'status_update', 'profile/statuses/update.tpl.php' );	
			}
			else
			{
				require_once( FRAMEWORK_PATH . 'models/relationships.php' );
				$relationships = new Relationships( $this->registry );
				$connections = $relationships->getNetwork( $user, false );
				if( in_array( $loggedInUser, $connections ) )
				{
					$this->registry->getObject('template')->addTemplateBit( 'status_update', 'profile/statuses/post.tpl.php' );	
				}
				else
				{
					$this->registry->getObject('template')->getPage()->addTag( 'status_update', '' );	
				}
			}
		}
		else
		{
			$this->registry->getObject('template')->getPage()->addTag( 'status_update', '' );
		}
		
		
		
		
		$updates = array();
		$ids = array();
		
		// query the updates
		$sql = "SELECT t.type_reference, t.type_name, s.*, pa.name as poster_name, i.image, v.video_id, l.URL, l.description FROM status_types t, profile p, profile pa, statuses s LEFT JOIN statuses_images i ON s.ID=i.id LEFT JOIN statuses_videos v ON s.ID=v.id LEFT JOIN statuses_links l ON s.ID=l.id WHERE t.ID=s.type AND p.user_id=s.profile AND pa.user_id=s.poster AND p.user_id={$user} ORDER BY s.ID DESC LIMIT 20";
		$this->registry->getObject('db')->executeQuery( $sql );
		if( $this->registry->getObject('db')->numRows() > 0 )
		{
			// populate the updates and ids arrays with the updates
			while( $row = $this->registry->getObject('db')->getRows() )
			{
				$updates[] = $row;
				$ids[$row['ID']] = $row;
			}
		}
		
		$post_ids = array_keys( $ids );
		if( count( $post_ids ) > 0 )
		{
			$post_ids = implode( ',', $post_ids );
			$pids =  array_keys( $ids );
			foreach( $pids as $id )
			{

				$blank = array();
				$cache = $this->registry->getObject('db')->cacheData( $blank );
				$this->registry->getObject('template')->getPage()->addPPTag( 'comments-' . $id, array( 'DATA', $cache ) );	
			}
			
			$sql = "SELECT p.name as commenter, c.profile_post, c.comment FROM profile p, comments c WHERE p.user_id=c.creator AND c.approved=1 AND c.profile_post IN ({$post_ids})";
			$this->registry->getObject('db')->executeQuery( $sql );
			if( $this->registry->getObject('db')->numRows() > 0 )
			{
				$comments = array();
				while( $comment = $this->registry->getObject('db')->getRows() )
				{
					if( in_array( $comment['profile_post'], array_keys( $comments ) ) )
					{
						$comments[ $comment['profile_post'] ][] = $comment;
					}
					else
					{
						$comments[ $comment['profile_post'] ] = array();
						$comments[ $comment['profile_post'] ][] = $comment;
					}
				}
				
				foreach( $comments as $pp => $commentlist )
				{
					$cache = $this->registry->getObject('db')->cacheData( $commentlist );
					$this->registry->getObject('template')->getPage()->addPPTag( 'comments-' . $pp, array( 'DATA', $cache ) );	
				}
			}
		}
		
		// cache the updates to build the loop which gives us a template tag for each status updates, for a template bit to go in 
		$cache = $this->registry->getObject('db')->cacheData( $updates );
		$this->registry->getObject('template')->getPage()->addTag( 'updates', array( 'DATA', $cache ) );
		foreach( $ids as $id => $data )
		{
			// iterate through the statuses, adding the update template bit, and populating it with the status information.
			// remember: the idea is we can extend the query to include other updates, which include different template bits
			$this->registry->getObject('template')->addTemplateBit( 'update-' . $id, 'profile/updates/' . $data['type_reference'] . '.tpl.php', $data);	
		}
		
	}
	
	/**
	 * Process a new status submission / profile message
	 * @param int $user the profile the message is being posted on
	 * @return void
	 */
	private function addStatus( $user )
	{
		$loggedInUser = $this->registry->getObject('authenticate')->getUser()->getUserID();
		if( $loggedInUser == $user )
		{
			require_once( FRAMEWORK_PATH . 'models/status.php' );
			if( isset( $_POST['status_type'] ) && $_POST['status_type'] != 'update' )
			{
				
				if( $_POST['status_type'] == 'image' )
				{
					require_once( FRAMEWORK_PATH . 'models/imagestatus.php' );
					$status = new Imagestatus( $this->registry, 0 );
					$status->processImage( 'image_file' );
					
				}
				elseif( $_POST['status_type'] == 'video' )
				{
					require_once( FRAMEWORK_PATH . 'models/videostatus.php' );
					$status = new Videostatus( $this->registry, 0 );
					$status->setVideoIdFromURL( $_POST['video_url'] );
				}
				elseif( $_POST['status_type'] == 'link' )
				{
					require_once( FRAMEWORK_PATH . 'models/linkstatus.php' );
					$status = new Linkstatus( $this->registry, 0 );
					$status->setURL( $this->registry->getObject('db')->sanitizeData( $_POST['link_url'] ) );
					$status->setDescription( $this->registry->getObject('db')->sanitizeData( $_POST['link_description'] ) );
				}
			}
			else
			{
				$status = new Status( $this->registry, 0 );
			}
				
			//$status = new Status( $this->registry, 0 );
			$status->setProfile( $user );
			$status->setPoster( $loggedInUser );
			$status->setStatus( $this->registry->getObject('db')->sanitizeData( $_POST['status'] ) );
			$status->generateType();
			$status->save();
			// success message display
			$this->registry->getObject('template')->addTemplateBit( 'status_update_message', 'profile/statuses/update_confirm.tpl.php' );	
		}
		else
		{
			require_once( FRAMEWORK_PATH . 'models/relationships.php' );
			$relationships = new Relationships( $this->registry );
			$connections = $relationships->getNetwork( $user, false );
			if( in_array( $loggedInUser, $connections ) )
			{
				require_once( FRAMEWORK_PATH . 'models/status.php' );
				if( isset( $_POST['status_type'] ) && $_POST['status_type'] != 'update' )
				{
					
					if( $_POST['status_type'] == 'image' )
					{
						require_once( FRAMEWORK_PATH . 'models/imagestatus.php' );
						$status = new Imagestatus( $this->registry, 0 );
						$status->processImage( 'image_file' );
						
					}
					elseif( $_POST['status_type'] == 'video' )
					{
						require_once( FRAMEWORK_PATH . 'models/videostatus.php' );
						$status = new Videostatus( $this->registry, 0 );
						$status->setVideoIdFromURL( $_POST['video_url'] );
					}
					elseif( $_POST['status_type'] == 'link' )
					{
						require_once( FRAMEWORK_PATH . 'models/linkstatus.php' );
						$status = new Linkstatus( $this->registry, 0 );
						$status->setURL( $this->registry->getObject('db')->sanitizeData( $_POST['link_url'] ) );
						$status->setDescription( $this->registry->getObject('db')->sanitizeData( $_POST['link_description'] ) );
					}
				}
				else
				{
					$status = new Status( $this->registry, 0 );
				}
				$status->setProfile( $user );
				$status->setPoster( $loggedInUser );
				$status->setStatus( $this->registry->getObject('db')->sanitizeData( $_POST['status'] ) );
				$status->generateType();
				$status->save();
				// success message display
				$this->registry->getObject('template')->addTemplateBit( 'status_update_message', 'profile/statuses/post_confirm.tpl.php' );	
			}
			else
			{
				// error message display
				$this->registry->getObject('template')->addTemplateBit( 'status_update_message', 'profile/statuses/error.tpl.php' );	
			}
		}
	}
	
	
}

?>