<?php

class Groupcontroller {
	
	/**
	 * Controller constructor - direct call to false when being embedded via another controller
	 * @param Registry $registry our registry
	 * @param bool $directCall - are we calling it directly via the framework (true), or via another controller (false)
	 */
	public function __construct( Registry $registry, $directCall )
	{
		$this->registry = $registry;
		$urlBits = $this->registry->getObject('url')->getURLBits();
		
		if( $this->registry->getObject('authenticate')->isLoggedIn() )
		{
			if( isset( $urlBits[1] ) )
			{
				
				require_once( FRAMEWORK_PATH . 'models/group.php');
				$this->group = new Group( $this->registry, intval( $urlBits[1] ) );
				$this->groupID = intval( $urlBits[1] );
				if( $this->group->isValid() && $this->group->isActive() )
				{
					require_once( FRAMEWORK_PATH . 'models/groupmembership.php');
					$gm = new Groupmembership( $this->registry );
					$user = $this->registry->getObject('authenticate')->getUser()->getUserID();
					$gm->getByUserAndGroup( $user, $this->groupID );
					if( $this->group->getCreator() == $user || $gm->getApproved() )
					{
						if( isset( $urlBits[2] ) )
						{
							switch( $urlBits[2] )
							{
								case 'create-topic':
									$this->createTopic();
									break;
								case 'view-topic':
									$this->viewTopic( intval( $urlBits[3] ) );
									break;
								case 'reply-to-topic':
									$this->replyToTopic( intval( $urlBits[3] ) );
									break;
								case 'membership':
									$this->manageMembership( intval( $urlBits[3] ) );
									break;
								default:
									$this->viewGroup();
									break;
							}
						}
						else
						{
							$this->viewGroup();
						}
					} 
					else
					{
						require_once( FRAMEWORK_PATH . 'controllers/group/membership.php');
						$membership = new Membershipcontroller( $this->registry, $this->groupID );
						$membership->join();
					}					
				}
				else
				{
					$this->registry->errorPage( 'Group not found', 'Sorry, the group you requested was not found' );
				}
				

			}
			else
			{
				$this->registry->errorPage( 'Group not found', 'Sorry, the group you requested was not found' );
			}
		}
		else
		{
			
			$this->registry->errorPage( 'Please login', 'Sorry, you must be logged in to view groups' );
		}
		
		
	}
	
	private function viewGroup()
	{
		$this->group->toTags( 'group_' );
		$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'groups/view.tpl.php', 'footer.tpl.php' );
		$cache = $this->group->getTopics();
		$this->registry->getObject('template')->getPage()->addTag( 'topics', array( 'SQL', $cache ) );
	}
	
	/**
	 * View a topic within the group
	 * @return void
	 */
	private function viewTopic( $topic )
	{
		$this->group->toTags( 'group_' );
		require_once( FRAMEWORK_PATH . 'models/topic.php' );
		$topic = new Topic( $this->registry, $topic );
		if( $topic->getGroup() == $this->groupID )
		{
			$topic->toTags( 'topic_' );
			$sql = $topic->getPostsQuery();
			$cache = $this->registry->getObject('db')->cacheQuery( $sql );
			$this->registry->getObject('template')->getPage()->addTag('posts', array( 'SQL', $cache ) );
			$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'groups/view-topic.tpl.php', 'footer.tpl.php' );
		}
		else
		{
			$this->registry->errorPage( 'Invalid topic', 'Sorry, you tried to view an invalid topic');
		}
		
				
	}
	
	/**
	 * Reply to a topic within a group
	 * @param int $topic
	 * @return void
	 */
	private function replyToTopic( $topici )
	{
		$this->group->toTags( 'group_' );
		require_once( FRAMEWORK_PATH . 'models/topic.php' );
		$topic = new Topic( $this->registry, $topici );
		if( $topic->getGroup() == $this->groupID )
		{
			require_once( FRAMEWORK_PATH . 'models/post.php' );
			$post = new Post( $this->registry, 0 );
			$user = $this->registry->getObject('authenticate')->getUser()->getUserID();
			
			$post->setPost( $this->registry->getObject('db')->sanitizeData( $_POST['post'] ) );
			$post->setCreator( $user );
			$post->setTopic( $topici );
			$post->save();
			$this->registry->redirectUser( $this->registry->buildURL(array( 'group', $this->groupID, 'view-topic', $topici ), '', false ), 'Reply saved', 'Thanks, the topic topic reply has been saved', false );
			
		}
		else
		{
			$this->registry->errorPage( 'Invalid topic', 'Sorry, you tried to view an invalid topic');
		}
	}
	
	/**
	 * Create a new topic within the group
	 * @return void
	 */
	private function createTopic()
	{
		if( isset( $_POST ) && is_array( $_POST ) && count( $_POST ) > 0  )
		{
			require_once( FRAMEWORK_PATH . 'models/topic.php' );
			$topic = new Topic( $this->registry, 0 );
			$topic->includeFirstPost( true );
			$user = $this->registry->getObject('authenticate')->getUser()->getUserID();
			$topic->setCreator( $user );
			$topic->setGroup( $this->groupID );
			$topic->setName( $this->registry->getObject('db')->sanitizeData( $_POST['name'] ) );
			$topic->getFirstPost()->setCreator( $user );	
			$topic->getFirstPost()->setPost( $this->registry->getObject('db')->sanitizeData( $_POST['name'] ) );
			$topic->save();
			$this->registry->redirectUser( $this->registry->buildURL(array( 'group', $this->groupID ), '', false ), 'Topic created', 'Thanks, the topic has been created', false );
				
		}
		else
		{
			$this->group->toTags( 'group_' );
			$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'groups/create-topic.tpl.php', 'footer.tpl.php' );
		
		}
	}
	
	private function manageMembership()
	{
		if( $group->getCreator() == $this->registry->getObject('authenticate')->getUser()->getUserID() )
		{
			require_once( FRAMEWORK_PATH . 'controllers/group/membership.php');
			$membership = new Membershipcontroller( $this->registry, $this->groupID );
			$membership->manage();
		}
		else
		{
			$this->registry->errorPage( 'Permission denied', 'Only the gorup creator can manage membership' );
		}
		
	}
	
	
}



?>