<?php
/**
 * Discussion topic class
 */
class Topic {

	/**
	 * The registry object
	 */
	private $registry;
	
	/**
	 * ID of the topic
	 */
	private $id=0;
	
	/**
	 * ID of the creator
	 */
	private $creator;
	
	/**
	 * Name of the creator
	 */
	private $creatorName;
	
	
	/**
	 * Name of the topic
	 */
	private $name;
	
	/**
	 * When the topic was created (TIMESTAMP)
	 */
	private $created;
	
	/**
	 * Friendly reference for the date the topic was created
	 */
	private $createdFriendly;
	
	/**
	 * Number of posts in the topic
	 */
	 private $numPosts;
	
	/**
	 * If we are also saving the first post
	 */
	private $includeFirstPost;
	
	/**
	 * Post object - if saving the first post too
	 */
	private $post;
	
	/**
	 * Group the topic was posted within
	 */
	private $group;
	
	
	/**
	 * Topic constructor
	 * @param Registry $registry the registry object
	 * @param int $id the ID of the topic
	 * @return void
	 */
	public function __construct( Registry $registry, $id=0 )
	{
		$this->registry = $registry;
		$this->id = $id;
		if( $this->id > 0 )
		{
			$sql = "SELECT t.*, (SELECT COUNT(*) FROM posts po WHERE po.topic=t.ID) as posts, DATE_FORMAT(t.created, '%D %M %Y') as created_friendly, p.name as creator_name FROM topics t, profile p WHERE p.user_id=t.creator AND t.ID=" . $this->id;
			$this->registry->getObject('db')->executeQuery( $sql );
			if( $this->registry->getObject('db')->numRows() > 0 )
			{
				$data = $this->registry->getObject('db')->getRows();
				$this->creator = $data['creator'];
				$this->creatorName = $data['creator_name'];
				$this->createdFriendly = $data['created_friendly'];
				$this->name = $data['name'];
				$this->numPosts = $data['posts'];
				$this->group = $data['group'];
				
			}
			else
			{
				$this->id = 0;
			}
		}
	}
	
	/**
	 * Get query of the posts in the topic (i.e. collection of posts == topic )
	 */
	public function getPostsQuery()
	{
		$sql = "SELECT p.*, DATE_FORMAT(p.created, '%D %M %Y') as friendly_created_post, pr.name as creator_friendly_post FROM posts p, profile pr WHERE pr.user_id=p.creator AND p.topic=" . $this->id;
		return $sql;
	}
	
	/**
	 * Set if this save should also save the first post
	 * @param bool $ifp
	 * @return void
	 */
	public function includeFirstPost( $ifp )
	{
		$this->includeFirstPost = $ifp;
		require_once( FRAMEWORK_PATH . 'models/post.php' );
		$this->post = new Post( $this->registry, 0 );
	}
	
	/**
	 * Return the object for the first post, for setting fields
	 * @return Object
	 */
	public function getFirstPost()
	{
		return $this->post;
	}
	
	/**
	 * Set the group this topic should be part of
	 * @param int $group
	 * @return void
	 */
	public function setGroup( $group )
	{
		$this->group = $group;
	}
	
	
	/**
	 * Set the creator of the topic
	 * @param int $creator
	 * @return void
	 */
	public function setCreator( $creator )
	{
		$this->creator = $creator;	
	}
	
	/**
	 * Set the name of the topic
	 * @param String $name
	 * @return void
	 */
	public function setName( $name )
	{
		$this->name = $name;
	}
	
	
	/**
	 * Save the topic into the database
	 * @return void
	 */
	public function save()
	{
		if( $this->id > 0 )
		{
			$update = array();
			$update['creator'] = $this->creator;
			$update['name'] = $this->name;
			$update['group'] = $this->group;
			$this->registry->getObject('db')->updateRecords( 'topics', $update, 'ID=' . $this->id );
		}
		else
		{
			$insert = array();
			$insert['creator'] = $this->creator;
			$insert['name'] = $this->name;
			$insert['group'] = $this->group;
			$this->registry->getObject('db')->insertRecords( 'topics', $insert );
			$this->id = $this->registry->getObject('db')->lastInsertID();
			if( $this->includeFirstPost == true )
			{
				$this->post->setTopic( $this->id );
				$this->post->save();
			}
		}
	}
	
	/**
	 * Get the name of the topic
	 */
	public function getName()
	{
		return $this->name;
	}
	
	/**
	 * Convert the topic data to template tags
	 * @param String $prefix prefix for the template tags
	 * @return void
	 */
	public function toTags( $prefix='' )
	{
		foreach( $this as $field => $data )
		{
			if( ! is_object( $data ) && ! is_array( $data ) )
			{
				$this->registry->getObject('template')->getPage()->addTag( $prefix.$field, $data );
			}
		}
	}
	
	/**
	 * Get the group this topic was posted within
	 * @return int
	 */
	public function getGroup()
	{
		return $this->group;
	}
	
	/**
	 * Delete the current topic
	 * @return boolean
	 */
	public function delete()
	{
		$sql = "DELETE FROM topics WHERE ID=" . $this->id;
		$this->registry->getObject('db')->executeQuery( $sql );
		if( $this->registry->getObject('db')->affectedRows() > 0 )
		{
			$sql = "DELETE FROM posts WHERE topic=" . $this->id;
			$this->registry->getObject('db')->executeQuery( $sql );
			$this->id =0;
			return true;
		}
		else
		{
			return false;
		}
	}
	
	
	
}


?>