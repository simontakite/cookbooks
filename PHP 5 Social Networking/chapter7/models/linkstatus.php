<?php

/**
 * Link status object
 * extends the base status object
 */
class Linkstatus extends status {
	
	private $url;
	private $description;
		
	/**
	 * Constructor
	 * @param Registry $registry
	 * @param int $id
	 * @return void
	 */
	public function __construct( Registry $registry, $id = 0 )
	{
		$this->registry = $registry;
		parent::__construct( $this->registry, $id );
		parent::setTypeReference('link');
	}
	
	/**
	 * Set the URL
	 * @param String $url 
	 * @return void
	 */
	public function setURL( $url )
	{
		$this->url = $url;
	}
	
	/**
	 * Set the description of the link
	 * @param String $description
	 * @return void
	 */
	public function setDescription( $description )
	{
		$this->description = $description;
	}
	
	/**
	 * Save the link status
	 * @return void
	 */
	public function save()
	{
		// save the parent object and thus the status table
		parent::save();
		// grab the newly inserted status ID
		$id = $this->getID();
		// insert into the link status table, using the same ID
		$extended = array();
		$extended['id'] = $id;
		$extended['URL'] = $this->url;
		$extended['description'] = $this->description;
		$this->registry->getObject('db')->insertRecords( 'statuses_links', $extended );
	}
	
}

?>