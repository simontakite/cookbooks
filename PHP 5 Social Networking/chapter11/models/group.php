<?php
/**
 * Group model object
 */
class Group {
	
	/**
	 * Types of group that are available
	 */
	private $types = array('public', 'private', 'private-member-invite', 'private-self-invite');
	
	/**
	 * The registry object
	 */
	private $registry;
	
	/**
	 * ID of the group
	 */
	private $id;
	
	/**
	 * The name of the group
	 */
	private $name;
	
	/**
	 * Description of the group
	 */
	private $description;
	
	/**
	 * The creator of the group
	 */
	private $creator;
	
	/**
	 * Name of the creator of the group
	 */
	private $creatorName;
	
	/**
	 * Time the group was created
	 */
	private $created;
	
	/**
	 * Friendly representation of when the group was created
	 */
	private $createdFriendly;
	
	/**
	 * Type of group
	 */
	private $type;
	
	/**
	 * If the group is active or not
	 */
	private $active=1;
	
	/**
	 * If the selected group is valid or not
	 */
	private $valid;
	
	/**
	 * Group constructor
	 * @param Registry $registry the registry
	 * @param int $id the ID of the group
	 * @return void
	 */
	public function __construct( Registry $registry, $id=0 )
	{
		$this->registry = $registry;
		if( $id > 0 )
		{
			$this->id = $id;
			$sql = "SELECT g.*, DATE_FORMAT(g.created, '%D %M %Y') as created_friendly, p.name as creator_name FROM groups g, profile p WHERE p.user_id=g.creator AND g.ID=" . $this->id;
			$this->registry->getObject('db')->executeQuery( $sql );
			if( $this->registry->getObject('db')->numRows() == 1 )
			{
				$data = $this->registry->getObject('db')->getRows();
				$this->name = $data['name'];
				$this->description = $data['description'];
				$this->creator = $data['creator'];
				$this->valid = true;
				$this->active = $data['active'];
				$this->type = $data['type'];
				$this->created = $data['created'];
				$this->createdFriendly = $data['created_friendly'];
				$this->creator = $data['creator'];
				$this->creatorName = $data['creator_name'];	
			}
			else
			{
				$this->valid = false;
			}
		}
		else
		{
			$this->id = 0;
		}
	}
	
	/**
	 * Set the name of the group
	 * @param String $name
	 * @return void
	 */
	public function setName( $name )
	{
		$this->name = $name;
	}
	
	/**
	 * Set the description of the group
	 * @param String $description the description
	 * @return void
	 */
	public function setDescription( $description )
	{
		$this->description = $description;
	}
	
	/**
	 * Set the creator of the group
	 * @param int $creator
	 * @return void
	 */
	public function setCreator( $creator )
	{
		$this->creator = $creator;
	}
	
	/**
	 * Set the type of the group
	 * @param String $type
	 * @return void
	 */
	public function setType( $type )
	{
		if( in_array( $type, $this->types ) )
		{
			$this->type = $type;
		}
	}
	
	/**
	 * Save the group
	 * @return void
	 */
	public function save()
	{
		if( $this->id > 0 )
		{
			$update = array();
			$update['description'] = $this->description;
			$update['name'] = $this->name;
			$update['type'] = $this->type;
			$update['creator'] = $this->creator;
			$update['active'] = $this->active;
			$update['created'] = $this->created;
			$this->registry->getObject('db')->updateRecords( 'groups', $update, 'ID=' . $this->id );
		}
		else
		{
			$insert = array();
			$insert['description'] = $this->description;
			$insert['name'] = $this->name;
			$insert['type'] = $this->type;
			$insert['creator'] = $this->creator;
			$insert['active'] = $this->active;
			$this->registry->getObject('db')->insertRecords( 'groups', $insert );
			$this->id = $this->registry->getObject('db')->lastInsertID();
		}
	}
	
	/**
	 * Get a list of topics assigned to this group ( we could paginate this if we wanted to later)
	 * @return int (database cache)
	 */
	public function getTopics()
	{
		$sql = "SELECT t.*, (SELECT COUNT(*) FROM posts po WHERE po.topic=t.ID) as posts, DATE_FORMAT(t.created, '%D %M %Y') as created_friendly, p.name as creator_name FROM topics t, profile p WHERE p.user_id=t.creator AND t.group=" . $this->id . " ORDER BY t.ID DESC";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * Get the ID of the group
	 */
	public function getID()
	{
		return $this->id;
	}
	
	public function getType()
	{
		return $this->type;
	}
	
	/**
	 * Convert the group data to template tags
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
	
	public function isValid()
	{
		return $this->valid;
	}
	
	public function isActive()
	{
		return $this->active;
	}
	
	public function getCreator()
	{
		return $this->creator;
	}
	
	
	
	
	
}




?>