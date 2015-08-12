<?php
/**
 * Post model object
 */
class Post{
	
	/**
	 * Registry object
	 */
	private $registry;
	
	/**
	 * ID of the post
	 */
	private $id;
	
	/**
	 * ID of the creator of the post
	 */
	private $creator;
	
	/**
	 * Name of the creator of the post
	 */
	private $creatorName;
	
	/**
	 * Timestamp of when the post was created
	 */
	private $created;
	
	/**
	 * Friendly representation of when the post was created
	 */
	private $createdFriendly;
	
	/**
	 * ID of the topic the post relates to
	 */
	private $topic;
	
	/**
	 * The post itself
	 */
	private $post;
	
	/**
	 * Post constructor
	 * @param Registry $registry the registry object
	 * @param int $id the ID of the post
	 * @return void
	 */
	public function __construct( Registry $registry, $id=0 )
	{
		$this->registry = $registry;
		$this->id = $id;
		if( $this->id > 0 )
		{
			$sql = "SELECT p.*, DATE_FORMAT(p.created, '%D %M %Y') as created_friendly, pr.name as creator_name FROM posts p, profile pr WHERE pr.user_id=p.creator AND p.ID=" . $this->id;
			$this->registry->getObject('db')->executeQuery( $sql );
			if( $this->registry->getObject('db')->numRows() > 0 )
			{
				$data = $this->registry->getObject('db')->getRows();
				$this->creator = $data['creator'];
				$this->creatorName = $data['creator_name'];
				$this->createdFriendly = $data['created_friendly'];
				$this->topic = $data['topic'];
				$this->post = $data['post'];
				
			}
			else
			{
				$this->id = 0;
			}
		}
	}
	
	/**
	 * Set the creator of the post
	 * @param int $c the creator
	 * @return void
	 */
	public function setCreator( $c )
	{
		$this->creator = $c;
	}
	
	/**
	 * Set the topic the post relates to
	 * @param int $t the topic ID
	 * @return void
	 */
	public function setTopic( $t )
	{
		$this->topic = $t;
	}
	
	/**
	 * Set the post content
	 * @param String $p the post itself
	 * @return void
	 */
	public function setPost( $p )
	{
		$this->post = $p;
	}
	
	/**
	 * Save the post in the database
	 * @return void
	 */
	public function save()
	{
		if( $this->id > 0 )
		{
			$update = array();
			$update['topic'] = $this->topic;
			$update['post'] = $this->post;
			$update['creator'] = $this->creator;
			$this->registry->getObject('db')->updateRecords( 'posts', $update, 'ID=' . $this->id );
		}
		else
		{
			$insert = array();
			$insert['topic'] = $this->topic;
			$insert['post'] = $this->post;
			$insert['creator'] = $this->creator;
			$this->registry->getObject('db')->insertRecords( 'posts', $insert );
			$this->id = $this->registry->getObject('db')->lastInsertID();
		}
		
	}
	
	
}



?>