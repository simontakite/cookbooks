<?php
/**
 * Calendar controller for events and birthdays
 */
class Calendarcontroller {
	
	public function __construct( $registry, $directCall=true )
	{
		$this->registry = $registry;
		$urlBits = $this->registry->getObject('url')->getURLBits();
		if( isset( $urlBits[1] ) )
		{
			switch( $urlBits[1] )
			{
				case 'test':
					$this->generateTestCalendar();
					break;
				case 'alpha':
					$this->listMembersAlpha( $urlBits[2] , intval( isset( $urlBits[3] ) ? $urlBits[3] : 0 ) );
					break;
				case 'birthdays':
					$this->birthdaysCalendar();
					break;
				case 'search-results':
					$this->searchMembers( false, $urlBits[2] , intval( isset( $urlBits[3] ) ? $urlBits[3] : 0 )  );
					break;	
				default:
					$this->listMembers(0);
					break;
			}
			
		}
		else
		{
			$this->listMembers( 0 );
		}
	}
	
	private function birthdaysCalendar()
	{
		// require the class
		require_once( FRAMEWORK_PATH . 'lib/calendar/calendar.class.php' );
		// set the default month and year, i.e. the current month and year
		$m = date('m');
		$y = date('Y');
		// check for a different Month / Year (i.e. user has moved to another month)
		if( isset( $_GET['month'] ) )
		{
			$m = intval( $_GET['month']);
			if( $m > 0 && $m < 13 )
			{
				
			}
			else
			{
				$m = date('m');
			}
		}
		if( isset( $_GET['year'] ) )
		{
			$y = intval( $_GET['year']);
		}
		// Instantiate the calendar object
		$calendar = new Calendar( '', $m, $y );
		// Get next and previous month / year
		$nm = $calendar->getNextMonth()->getMonth();
		$ny = $calendar->getNextMonth()->getYear();
		$pm = $calendar->getPreviousMonth()->getMonth();
		$py = $calendar->getPreviousMonth()->getYear();
		
		// send next / previous month data to the template		
		$this->registry->getObject('template')->getPage()->addTag('nm', $nm );
		$this->registry->getObject('template')->getPage()->addTag('pm', $pm );
		$this->registry->getObject('template')->getPage()->addTag('ny', $ny );
		$this->registry->getObject('template')->getPage()->addTag('py', $py );
		// send the current month name and year to the template
		$this->registry->getObject('template')->getPage()->addTag('month_name', $calendar->getMonthName() );
		$this->registry->getObject('template')->getPage()->addTag('the_year', $calendar->getYear() );
		// Set the start day of the week
		$calendar->setStartDay(0);
		
		
		require_once( FRAMEWORK_PATH . 'models/relationships.php');
		$relationships = new Relationships( $this->registry );
		$idsSQL = $relationships->getIDsByUser( $this->registry->getObject('authenticate')->getUser()->getUserID() );
		
		$sql = "SELECT DATE_FORMAT(pr.user_dob, '%d' ) as profile_dob, pr.name as profile_name, pr.user_id as profile_id, ( ( YEAR( CURDATE() ) ) - ( DATE_FORMAT(pr.user_dob, '%Y' ) ) ) as profile_new_age FROM profile pr WHERE pr.user_id IN (".$idsSQL.") AND pr.user_dob LIKE '%-{$m}-%'";
		$this->registry->getObject('db')->executeQuery( $sql );
		$dates = array();
		$data = array();
		if( $this->registry->getObject('db')->numRows() > 0 )
		{
			while( $row = $this->registry->getObject('db')->getRows() )
			{
				$dates[] = $row['profile_dob'];
				$data[ intval($row['profile_dob']) ] = "<br />".$row['profile_name']." (". $row['profile_new_age'] . ")<br />";
			}
		}
		
		$calendar->setData( $data );
		// tell the calendar which days should be highlighted
		$calendar->setDaysWithEvents($dates);
		$calendar->buildMonth();
		// days
		$this->registry->getObject('template')->dataToTags( $calendar->getDaysInOrder(),'cal_0_day_' ); 
		// dates
		$this->registry->getObject('template')->dataToTags( $calendar->getDates(),'cal_0_dates_' ); 
		// styles
		$this->registry->getObject('template')->dataToTags( $calendar->getDateStyles(),'cal_0_dates_style_' ); 
		// data
		$this->registry->getObject('template')->dataToTags( $calendar->getDateData(),'cal_0_dates_data_' ); 
		
		$this->registry->getObject('template')->buildFromTemplates( 'header.tpl.php', 'bd-calendar.tpl.php', 'footer.tpl.php' );	
		
	}
	
	private function generateTestCalendar()
	{
		
		
		// Get how many days there are in the month
		
		
		// build the month, generate some data
		$calendar->buildMonth();
		// days
		$this->registry->getObject('template')->dataToTags( $calendar->getDaysInOrder(),'cal_0_day_' ); 
		// dates
		$this->registry->getObject('template')->dataToTags( $calendar->getDates(),'cal_0_dates_' ); 
		// styles
		$this->registry->getObject('template')->dataToTags( $calendar->getDateStyles(),'cal_0_dates_style_' ); 
		// data
		$this->registry->getObject('template')->dataToTags( $calendar->getDateData(),'cal_0_dates_data_' ); 
		
		$this->registry->getObject('template')->buildFromTemplates( 'test-calendar.tpl.php' );	
	
				
	}

	
	
}


?>