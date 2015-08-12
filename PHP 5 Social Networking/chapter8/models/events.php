<?php
/**
 * Events model
 * - builds lists of events
 */
class Events{
	
	/**
	 * Registry object
	 */
	private $registry;
	
	/**
	 * Events constructor
	 * @param Registry $registry
	 * @return void
	 */
	public function __construct( Registry $registry )
	{
		$this->registry = $registry;
	}
	
	/**
	 * List events by connected users in specified month / year
	 * @param int $connectedTo events of users connected to this user
	 * @param int $month
	 * @param int $year
	 * @return int database cacehe
	 */
	public function listEventsMonthYear( $connectedTo, $month, $year )
	{
		require_once( FRAMEWORK_PATH . 'models/relationships.php');
		$relationships = new Relationships( $this->registry );
		$idsSQL = $relationships->getIDsByUser( $connectedTo );
		$sql = "SELECT p.name as creator_name, e.* FROM events e, profile p WHERE p.user_id=e.creator AND e.event_date LIKE '{$year}-{$month}-%' AND e.creator IN ($idsSQL) ";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * List events by connected users in specified time period
	 * @param int $connectedTo events of users connected to this user
	 * @param int $days days in the future
	 * @return int database cacehe
	 */
	public function listEventsFuture( $connectedTo, $days )
	{
		require_once( FRAMEWORK_PATH . 'models/relationships.php');
		$relationships = new Relationships( $this->registry );
		$idsSQL = $relationships->getIDsByUser( $connectedTo );
		$sql = "SELECT p.name as creator_name, e.* FROM events e, profile p WHERE p.user_id=e.creator AND e.event_date >= CURDATE() AND e.event_date <= DATE_ADD(CURDATE(), INTERVAL {$days} DAY ) AND e.creator IN ($idsSQL) ";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * List events by a specific user within next X days
	 * @param int $user user whose events to list
	 * @param int $days
	 * @return int database cache
	 */
	public function listEventsUserFuture( $user, $days )
	{
		$sql = "SELECT p.name as creator_name, e.* FROM events e, profile p WHERE p.user_id=e.creator AND e.event_date >= CURDATE() AND e.event_date <= DATE_ADD(CURDATE(), INTERVAL {$days} DAY ) AND e.creator={$user} ";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * List events in the future user is invited to
	 * @param int $user the user 
	 * @return int database cache
	 */
	public function listEventsInvited( $user )
	{
		$sql = "SELECT p.name as creator_name, e.* FROM events e, profile p WHERE p.user_id=e.creator AND e.event_date >= CURDATE() AND ( SELECT COUNT(*) FROM events_attendees a WHERE a.event_id=e.ID AND a.user_id={$user} AND a.status='invited' ) > 0";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * List events in the future user is attending 
	 * @param int $user the user 
	 * @return int database cache
	 */
	public function listEventsAttending( $user )
	{
		$sql = "SELECT p.name as creator_name, e.* FROM events e, profile p WHERE p.user_id=e.creator AND e.event_date >= CURDATE() AND ( SELECT COUNT(*) FROM events_attendees a WHERE a.event_id=e.ID AND a.user_id={$user} AND a.status='attending' ) > 0";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * List events in the future user is not attending
	 * @param int $user the user 
	 * @return int database cache
	 */
	public function listEventsNotAttending( $user )
	{
		$sql = "SELECT p.name as creator_name, e.* FROM events e, profile p WHERE p.user_id=e.creator AND e.event_date >= CURDATE() AND ( SELECT COUNT(*) FROM events_attendees a WHERE a.event_id=e.ID AND a.user_id={$user} AND a.status='not attending' ) > 0";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
	
	/**
	 * List events in the future user is maybe attending
	 * @param int $user the user 
	 * @return int database cache
	 */
	public function listEventsMaybeAttending( $user )
	{
		$sql = "SELECT p.name as creator_name, e.* FROM events e, profile p WHERE p.user_id=e.creator AND e.event_date >= CURDATE() AND ( SELECT COUNT(*) FROM events_attendees a WHERE a.event_id=e.ID AND a.user_id={$user} AND a.status='maybe' ) > 0";
		$cache = $this->registry->getObject('db')->cacheQuery( $sql );
		return $cache;
	}
		
	
	
}



?>