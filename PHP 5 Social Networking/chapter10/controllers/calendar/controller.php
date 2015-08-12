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
	
	private function removedCode()
	{
		//$dim = $calendar->daysInMonth( $m, $y );
		$current_date = date('Y-m-d');
		//$sql = "SELECT DATE_FORMAT(e.publication_date, '%d') as day FROM content c, content_versions r, content_types t, content_versions_blog_entries e WHERE e.publication_date > '{$y}-{$m}-01' AND e.publication_date < '{$y}-{$m}-{$dim}' AND e.publication_date <= '{$current_date}' AND e.version_id=r.ID AND t.reference='blog' AND c.type=t.ID AND c.active=1 AND r.ID=current_revision";
		$sql = "SELECT DISTINCT DATE_FORMAT(s.date, '%d') as day " .
						"FROM course_sessions s, content c, content_versions v, content_versions_courses co, " .
						"content cven, content_versions vven, content_versions_venues ven, content_types t, content_types tven " .
						"WHERE s.date >= '{$y}-{$m}-01' AND s.date <= '{$y}-{$m}-{$dim}' AND s.active=1 AND s.deleted=0 AND c.ID=course_ID AND " .
						"v.ID=c.current_revision AND co.version_id=c.current_revision AND cven.ID=s.venue_ID AND " .
						"vven.ID=cven.current_revision AND ven.version_id=cven.current_revision AND c.type=t.ID AND " .
						"cven.type=tven.ID AND t.reference='course' AND tven.reference='venue'";
				
		$this->registry->getObject('db')->executeQuery( $sql );
		$days = array();
		if( $this->registry->getObject('db')->numRows() > 0 )
		{
			while( $r = $this->registry->getObject('db')->getRows() )
			{
				$days[] = $r['day'];
			}
		}
		$sql = "SELECT v.name as course_cal_name, ven.address_city as course_cal_location, s.ID as course_cal_path, DATE_FORMAT(s.date, '%d') as day " .
						"FROM course_sessions s, content c, content_versions v, content_versions_courses co, " .
						"content cven, content_versions vven, content_versions_venues ven, content_types t, content_types tven " .
						"WHERE s.date >= '{$y}-{$m}-01' AND s.date <= '{$y}-{$m}-{$dim}' AND s.active=1 AND s.deleted=0 AND c.ID=course_ID AND " .
						"v.ID=c.current_revision AND co.version_id=c.current_revision AND cven.ID=s.venue_ID AND " .
						"vven.ID=cven.current_revision AND ven.version_id=cven.current_revision AND c.type=t.ID AND " .
						"cven.type=tven.ID AND t.reference='course' AND tven.reference='venue'";
				
		$this->registry->getObject('db')->executeQuery( $sql );
		$data = array();
		if( $this->registry->getObject('db')->numRows() > 0 )
		{
			while( $r = $this->registry->getObject('db')->getRows() )
			{
				if( isset( $data[ intval( $r['day'] ) ]  ) )
				{
					$data[ intval ( $r['day'] ) ] .= "<a href='courses/view/".$r['course_cal_path']."' target='_blank'><span class='title'>".$r['course_cal_name']."</span><span class='location'>".$r['course_cal_location']."</span></a> ";
				}
				else
				{
					$data[ intval( $r['day'] ) ] = "<a href='courses/view/".$r['course_cal_path']."' target='_blank'><span class='title'>".$r['course_cal_name']."</span><span class='location'>".$r['course_cal_location']."</span></a> ";
				}

			}
		}
		// pass data to the calendar for inclusion
		$calendar->setData( $data );
		// tell the calendar which days should be highlighted
		$calendar->setDaysWithEvents($days);
	}
	
	
}


?>