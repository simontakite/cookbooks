<?php
/**
 * Status model
 */
class Status {
	
	/**
	 * The registry object
	 */
	private $registry;
	
	/**
	 * Statuses ID
	 */
	private $id;
	
	/**
	 * Poster of the status update / profile message
	 */
	private $poster;
	
	/**
	 * The profile the status update / profile message was posed on
	 */
	private $profile;
	
	/**
	 * Type of status
	 */
	private $type;
	
	/**
	 * The update / profile message itself
	 */
	private $update;
	
	/**
	 * Reference for the type of status
	 */
	private $typeReference = 'update';
		
	/**
	 * Constructor
	 * @param Registry $registry the registry object
	 * @param int $id ID of the status update / profile message
	 * @return void
	 */
	public function __construct( Registry $registry, $id=0 )
	{
		$this->registry = $registry;
		$this->id = 0;
	}
	
	/**
	 * Set the poster of the status / profile message
	 * @param int $poster the id of the poster
	 * @return void
	 */
	public function setPoster( $poster )
	{
		$this->poster = $poster;
	}
	
	/**
	 * Set the profile the message / status is posted on
	 * @param int $profile the profile ID
	 * @return void
	 */
	public function setProfile( $profile )
	{
		$this->profile = $profile;
	}
	
	/**
	 * Set the status / profile message itself
	 * @param String $status
	 * @return void
	 */
	public function setStatus( $status )
	{
		$this->status = $status;
	}
	
	/**
	 * Set the type of status / profile message
	 * @param int $type
	 * @return void
	 */
	public function setType( $type )
	{
		$this->type = $type;
	}
	
	/**
	 * Set the type reference, so we can get the type ID from the database
	 * @param String $typeReference the reference of the type
	 * @return void
	 */
	public function setTypeReference( $typeReference )
	{
		$this->typeReference = $typeReference;
	}
	
	/**
	 * Generate the type of status based of the type reference
	 * @return void
	 */
	public function generateType()
	{
		$sql = "SELECT * FROM status_types WHERE type_reference='{$this->typeReference}'";
		$this->registry->getObject('db')->executeQuery( $sql );
		$data = $this->registry->getObject('db')->getRows();
		$this->type = $data['ID'];
	}
	
	/**
	 * Save the status / profile message
	 * @return void
	 */
	public function save()
	{
		if( $this->id == 0 )
		{
			$insert = array();
			$insert['update'] = $this->status;
			$insert['type'] = $this->type;
			$insert['poster'] = $this->poster;
			$insert['profile'] = $this->profile;
			$this->registry->getObject('db')->insertRecords( 'statuses', $insert );
			$this->id = $this->registry->getObject('db')->lastInsertID();
		}
	}
	
	public function getID()
	{
		return $this->id;
	}
}


?>