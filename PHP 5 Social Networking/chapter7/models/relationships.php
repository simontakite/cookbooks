<?php

class Relationships{
	
	
	public function __construct( Registry $registry )
	{
		$this->registry = $registry; 
	}
	
	/**
	 * Get the types of relationships
	 * @param $cache bool - should we cache the types?
	 * @return mixed [int|array]
	 */
	public function getTypes( $cache=false )
	{
		$sql = "SELECT ID as type_id, name as type_name, plural_name as type_plural_name, mutual as type_mutual FROM relationship_types WHERE active=1";
		if( $cache == true )
		{
			$cache = $this->registry->getObject('db')->cacheQuery( $sql );
			return $cache;
		}
		else
		{
			$types = array();
			while( $row = $this->registry->getObject('db')->getRows() )
			{
				$types[] = $row;
			}
			return $types;
		}
	}
	
	/**
	 * Get relationships between users
	 * @param int $usera 
	 * @param int $userb
	 * @param int $approved
	 * @return int cache
	 */
	public function getRelationships( $usera, $userb, $approved=0 )
	{
		$sql = "SELECT t.name as type_name, t.plural_name as type_plural_name, uap.name as usera_name, ubp.name as userb_name, r.ID FROM relationships r, relationship_types t, profile uap, profile ubp WHERE t.ID=r.type AND uap.user_id=r.usera AND ubp.user_id=r.userb AND r.accepted={$approved}";
		if( $usera != 0 && $userb == 0)
		{
			$sql .= " AND ( r.usera={$usera} OR r.userb={$usera} )";
		}
		elseif( $usera == 0 && $userb != 0)
		{
			$sql .= " AND ( r.usera={$userb} OR r.userb={$userb} )";
		}
		elseif( $userb != 0 )
		{
			$sql .= " AND ( ( r.usera={$usera} OR r.userb={$userb} ) OR ( ( r.usera={$userb} OR r.userb={$usera} ) ) ";
		}
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * Get relationships by user
	 * @param int $user the user whose relationships we wish to list
	 * @param boolean $obr should we randomly order the results?
	 * @param int $limit should we limit the results? ( 0 means no, > 0 means limit to $limit )
	 * @return int the query cache ID
	 */
	public function getByUser( $user, $obr=false, $limit=0 )
	{
		// the standard get by user query
		$sql = "SELECT t.plural_name, p.name as users_name, u.ID FROM users u, profile p, relationships r, relationship_types t WHERE t.ID=r.type AND r.accepted=1 AND (r.usera={$user} OR r.userb={$user}) AND IF( r.usera={$user},u.ID=r.userb,u.ID=r.usera) AND p.user_id=u.ID";
		// if we are ordering by random
		if( $obr == true )
		{
			$sql .= " ORDER BY RAND() ";
		}
		// if we are limiting
		if( $limit != 0 )
		{
			$sql .= " LIMIT " . $limit;
		}
		// cache and return
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * Get relationship IDs (network) by user
	 * @param int $user the user whose relationships we wish to list
	 * @return array the IDs of profiles in the network
	 */
	public function getNetwork( $user )
	{
		$sql = "SELECT u.ID FROM users u, profile p, relationships r, relationship_types t WHERE t.ID=r.type AND r.accepted=1 AND (r.usera={$user} OR r.userb={$user}) AND IF( r.usera={$user},u.ID=r.userb,u.ID=r.usera) AND p.user_id=u.ID";
		$this->registry->getObject('db')->executeQuery( $sql );
		$network = array();
		if( $this->registry->getObject('db')->numRows() > 0 )
		{
			while( $r = $this->registry->getObject('db')->getRows() )
			{
				$network[] = $r['ID'];
			}
		}
		return $network;
	}
}

?>