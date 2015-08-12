<?php

class Relationshipcontroller {
	
	/**
	 * Controller constructor - direct call to false when being embedded via another controller
	 * @param Registry $registry our registry
	 * @param bool $directCall - are we calling it directly via the framework (true), or via another controller (false)
	 */
	public function __construct( Registry $registry, $directCall )
	{
		$this->registry = $registry;
		if( $this->registry->getObject('authenticate')->isLoggedIn() )
		{
			$urlBits = $this->registry->getObject('url')->getURLBits();
			if( isset( $urlBits[1] ) )
			{
				switch( $urlBits[1] )
				{
					case 'create':
						$this->createEvent();
						break;	
					case 'view':
						$this->viewEvent( intval( $urlBits[2] ) );
						break;
					case 'change-attendance':
						$this->changeAttendance( intval( $urlBits[2] ) );
						break;
					default:
						$this->listUpcomingInNetwork();
						break;
				}
				
			}
			else
			{
				
			}
		}
		
		
		
	}
	
	/**
	 * Create an event
	 * @return void
	 */
	private function createEvent()
	{
		// if post data is set, we are creating an event
		if( isset( $_POST ) && count( $_POST ) > 0 )
		{
			require_once( FRAMEWORK_PATH . 'models/event.php' );
			$event = new Event( $this->registry, 0 );
			$event->setName( $this->registry->getObject('db')->sanitizeData( $_POST['name'] ) );
			$event->setDescription( $this->registry->getObject('db')->sanitizeData( $_POST['description'] ) );
			$event->setDate( $this->registry->getObject('db')->sanitizeData( $_POST['date'] ), false );
			$event->setStartTime( $this->registry->getObject('db')->sanitizeData( $_POST['start_time'] ) );
			$event->setEndTime( $this->registry->getObject('db')->sanitizeData( $_POST['end_time'] ) );
			$event->setCreator( $this->registry->getObject('authenticate')->getUser()->getID() );
			$event->setType( $this->registry->getObject('db')->sanitizeData( $_POST['type'] ) );
			if( isset( $_POST['invitees'] ) && is_array( $_POST['invitees'] ) && count( $_POST['invitees'] ) > 0 )
			{
				// assumes invitees are added to a table using javascript, with a hidden field with name invitees[] for the ID of invitee 
				$is = array();
				foreach( $_POST['invitees'] as $i )
				{
					$is[] = intval( $i );
				}
				$event->setInvitees( $is );
			}
			$event->save();
			$this->registry->redirectUser( $this->registry->buildURL(array( 'event', 'view', $event->getID() ), '', false ), 'Event created', 'Thanks, the event has been created', false );
			
		}
		else
		{
			$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'events/create.tpl.php', 'footer.tpl.php' );
		}
	}
	
	/**
	 * View an event
	 * @param int $id
	 * @return void
	 */
	private function viewEvent( $id )
	{
		require_once( FRAMEWORK_PATH . 'models/event.php' );
		$event = new Event( $this->registry, $id );
		$event->toTags( 'event_' );
		$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'events/view.tpl.php', 'footer.tpl.php' );

	}
	
	private function changeAttendance( $event )
	{
		$sql = "SELECT * FROM event_attendees WHERE event_id={$event} AND user_id=" . $this->registry->getObject('authenticate')->getUser()->getID();
		$this->registry->getObject('db')->executeQuery( $sql );
		if( $this->registry->getObject('db')->numRows() == 1 )
		{
			$data = $this->registry->getObject('db')->getRows();
			$changes = array();
			$changes['status'] = $this->registry->getObject('db')->sanitizeData( $_POST['status'] );
			$this->registry->getObject('db')->updateRecords( 'event_attendees', $changes, 'ID=' . $data['ID'] );
			$this->registry->redirectUser( $this->registry->buildURL(array( 'home' ), '', false ), 'Attendance updated', 'Thanks, your attendance has been updated for that event', false );
			 	
		}
		else
		{
			$this->registry->errorPage('Attendance not logged', 'Sorry, we could not find any record of your attendance for that event, please try again');
		}
	}
	
	private function listUpcomingInNetwork()
	{
		require_once( FRAMEWORK_PATH . 'models/events.php' );
		$events = new Events( $this->registry );
		$cache = $events->listEventsFuture( $this->registry->getObject('authenticate')->getUser()->getID(), 30 );
		$this->registry->getObject('template')->getPage()->addTag( 'events', array( 'SQL', $cache ) );
		$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'events/upcoming.tpl.php', 'footer.tpl.php' );
	}
	
	
	
	
	
	
	
}


?>