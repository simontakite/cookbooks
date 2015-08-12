<?php

class Profilestatusescontroller {
	
	public function __construct( $registry, $user )
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
		$updates = array();
		$ids = array();
		
		// query the updates
		$sql = "SELECT t.type_reference, t.type_name, s.*, p.name as poster_name FROM statuses s, status_types t, profile p WHERE t.ID=s.type AND p.user_id=s.poster AND p.user_id={$user} ORDER BY s.ID DESC LIMIT 20";
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
	
	
}

?>