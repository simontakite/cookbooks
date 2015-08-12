<?php
/**
 * Group membership model
 */
class Groupmembership{
	
	/**
	 * ID of the membership record
	 */
	private $id;
	
	private $valid = false;
	
	/**
	 * ID of the user
	 */
	private $user;
	
	/**
	 * ID of the group
	 */
	private $group;
	
	/**
	 * Indicates if the membership is active / approved
	 */
	private $approved = 0;
	
	/**
	 * Indicates if the user was invited
	 */
	private $invited;
	
	/**
	 * Indicates if the user has requested to join
	 */
	private $requested;
	
	/**
	 * Date user was invited to join
	 */
	private $invitedDate;
	
	/**
	 * Date user requested to join
	 */
	private $requestedDate;
	
	/**
	 * Join date
	 */
	private $joinDate;
	
	/**
	 * User who invited the user to join the group
	 */
	private $inviter;
	
	/**
	 * Constructor
	 * @param Registry $registry
	 * @param int $id
	 * @return void
	 */
	public function __construct( Registry $registry, $id=0 )
	{
		$this->registry = $registry;
		if( $id > 0 )
		{
			$sql = "SELECT * FROM group_membership WHERE ID={$id} LIMIT 1";
			$this->registry->getObject('db')->executeQuery( $sql );
			if( $this->registry->getObject('db')->numRows() == 1 )
			{
				$this->valid = true;
				$data = $this->registry->getObject('db')->getRows();
				$this->approved = $data['approved'];
				$this->invited = $data['invited'];
				$this->requested = $data['requested'];	
				$this->invitedDate = $data['invited_date'];
				$this->requestedDate = $data['requested_date'];
				$this->joinDate = $data['join_date'];
				$this->inviter = $data['inviter'];
			}
		}
		else
		{
			$this->id = 0;
		}
	}
	
	public function getID()
	{
		return $this->id;
	}
	
	/**
	 * Get membership information by user and group
	 * @param int $user
	 * @param int $group
	 * @return void
	 */
	public function getByUserAndGroup( $user, $group )
	{
		$this->user = $user;
		$this->group = $group;
		$sql = "SELECT * FROM group_membership WHERE user={$user} AND `group`={$group} LIMIT 1";
		$this->registry->getObject('db')->executeQuery( $sql );
		if( $this->registry->getObject('db')->numRows() == 1 )
		{
			$data = $this->registry->getObject('db')->getRows();
			$this->valid = true;
			$this->approved = $data['approved'];
			$this->invited = $data['invited'];
			$this->requested = $data['requested'];	
		}
		
	}
	
	public function isValid()
	{
		return $this->valid;
	}
	
	/**
	 * Get if the membership is approved
	 * @return boolean
	 */
	public function getApproved()
	{
		return $this->approved;
	}
	
	/**
	 * Get if the user was invited
	 * @return boolean
	 */
	public function getInvited()
	{
		return $this->invited;
	}
	
	/**
	 * Get if the user requested to join
	 * @return boolean
	 */
	public function getRequested()
	{
		return $this->requested;
	}
	
	
	/**
	 * Get the user who invited this user to the group
	 * @return int
	 */
	public function getInviter()
	{
		return $this->inviter;
	}
	
	/**
	 * Set membership to approved
	 * @param boolean $approved
	 * @return void
	 */
	public function setApproved( $approved )
	{
		$this->approved = $approved;
	}
	
	/**
	 * Set membership status to requested
	 * @param boolean $requested
	 * @return void
	 */
	public function setRequested( $requested )
	{
		$this->requested = $requested;
	}
	
	/**
	 * Set if the user was invited
	 * @param boolean $invited
	 * @return void
	 */
	public function setInvited( $invited )
	{
		$this->invited = $invited;
	}
	
	/**
	 * Set the inviter
	 * @param int $inviter
	 * @return void
	 */
	public function setInviter( $inviter )
	{
		$this->inviter = $inviter;
	}
	

	/**
	 * Save the membership record
	 * @return void
	 */
	public function save()
	{
		if( $this->id > 0 )
		{
			$update = array();
			$update['user'] = $this->user;
			$update['group'] = $this->group;
			$update['approved'] = $this->approved;
			$update['requested'] = $this->requested;
			$update['invited'] = $this->invited;
			$update['invited_date'] = $this->invitedDate;
			$update['requested_date'] = $this->requestedDate;
			$update['join_date'] = $this->joinDate;
			$update['inviter'] = $this->inviter;
			$this->registry->getObject('db')->updateRecords( 'group_membership', $update, 'ID=' . $this->id );
			
		}
		else
		{
			$insert = array();
			$insert['user'] = $this->user;
			$insert['group'] = $this->group;
			$insert['approved'] = $this->approved;
			$insert['requested'] = $this->requested;
			$insert['invited'] = $this->invited;
			$insert['invited_date'] = $this->invitedDate;
			$insert['requested_date'] = $this->requestedDate;
			$insert['join_date'] = $this->joinDate;
			$insert['inviter'] = $this->inviter;
			$this->registry->getObject('db')->insertRecords( 'group_membership', $insert );
			$this->id = $this->registry->getObject('db')->lastInsertID();
		}
	}
	
	
	
	
}



?>