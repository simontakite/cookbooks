<?php
/**
 * Manage our statuses in the form of a stream
 */
class Stream{
	
	/**
	 * Array of types: to allow us to extend this feature in the future...(chapter 7)
	 */
	private $types = array();
	
	/**
	 * Indicates if the stream is empty
	 */
	private $empty = true;
	
	/**
	 * The stream itself
	 */
	private $stream = array();
	
	/**
	 * IDs of the statuses in the stream
	 */
	private $IDs = array();
	
	/**
	 * Our registry
	 */
	private $registry;
	
	
	/**
	 * Constructor
	 * @param Registry $registry the registry object
	 * @return void
	 */
	public function __construct( Registry $registry )
	{
		$this->registry = $registry;
	}	
	
	/**
	 * Build a users stream
	 * @param int $user the user whose network we want to stream
	 * @param int $offset - useful if we add in an AJAX based "view more statuses" feature
	 * @return void
	 */
	public function buildStream( $user, $offset=0 )
	{
		// prepare an array
		$network = array();
		// use the relationships model to get relationships
		require_once( FRAMEWORK_PATH . 'models/relationships.php' );
		$relationships = new Relationships( $this->registry );
		$network = $relationships->getNetwork( $user );
		// Add a zero element; so if network is empty the IN part of the query won't fail
		$network[] = 0;
		$network = implode( ',', $network );
		// query the statuses table
		$sql = "SELECT t.type_reference, t.type_name, s.*, UNIX_TIMESTAMP(s.posted) as timestamp, p.name as poster_name, r.name as profile_name FROM statuses s, status_types t, profile p, profile r WHERE t.ID=s.type AND p.user_id=s.poster AND r.user_id=s.profile AND ( p.user_id={$user} OR r.user_id={$user} OR ( p.user_id IN ({$network}) AND r.user_id IN ({$network}) ) ) ORDER BY s.ID DESC LIMIT {$offset}, 20";
		$this->registry->getObject('db')->executeQuery( $sql );
		if( $this->registry->getObject('db')->numRows() > 0 )
		{
			$this->empty = false;
			// iterate through the statuses, adding the ID to the IDs array, making the time friendly, and saving the stream
			while( $row = $this->registry->getObject('db')->getRows() )
			{
				$row['friendly_time'] = $this->generateFriendlyTime( $row['timestamp'] );
				$this->IDs[] = $row['ID'];
				$this->stream[] = $row;			
			}
		}
	}
	
	/**
	 * Get the stream
	 * @return array
	 */
	public function getStream()
	{
		return $this->stream;
	}
	
	/**
	 * Get the status IDs in the stream
	 * @return array
	 */
	public function getIDs()
	{
		return $this->IDs;
	}
	
	/**
	 * Is the stream empty?
	 * @return bool
	 */
	public function isEmpty()
	{
		return $this->empty;
	}
	
	/**
	 * Generate a more user friendly time
	 * @param int $time - timestamp
	 * @return String - friendly time
	 */
	private function generateFriendlyTime( $time )
	{
		$current_time = time();
		if( $current_time < ( $time + 60 ) )
		{
			// the update was in the past minute
			return "less than a minute ago";
		}
		elseif( $current_time < ( $time + 120 ) )
		{
			// it was less than 2 minutes ago, more than 1, but we don't want to say 1 minuteS ago do we?
			return "just over a minute ago";
		}
		elseif( $current_time < ( $time + ( 60*60 ) ) )
		{
			// it was less than 60 minutes ago: so say X minutes ago
			return round( ( $current_time - $time ) / 60 ) . " minutes ago";
		}
		elseif( $current_time < ( $time + ( 60*120 ) ) )
		{
			// it was more than 1 hour ago, but less than two, again we dont want to say 1 hourS do we?
			return "just over an hour ago";
		}
		elseif( $current_time < ( $time + ( 60*60*24 ) ) )
		{
			// it was in the last day: X hours
			return round( ( $current_time - $time ) / (60*60) ) . " hours ago";
		}
		else
		{
			// longer than a day ago: give up, and display the date / time
			return "at " . date( 'h:ia \o\n l \t\h\e jS \o\f M',$time);
		}
	}
	
	
	
	
	
}


?>