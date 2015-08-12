<?php
/**
 * Calendar object
 */
class Calendar{
	
	/**
	 * The year represented within the calendar
	 */
	private $year; 
	
	/**
	 * The current day being represented within the calendar, if appropriate
	 */
	private $day;
	
	/**
	 * The current month being represented within the calendar
	 */
	private $month;
	
	/**
	 * Tells the calendar which day of the month weeks start at. Sunday is standard for UK calendars.
	 */
	private $startDay = 0;
	
	/**
	 * Array of days...as if we didn't already know...
	 */
	private $days = array('Sun','Mon','Tue','Wed','Thu','Fri', 'Sat');
	
	/**
	 * Array of months
	 */
	private $months = array(	0=> '',
							1 => 'January',
							2 => 'February',
							3 => 'March',
							4 => 'April',
							5 => 'May',
							6 => 'June',
							7 => 'July',
							8 => 'August',
							9 => 'September',
							10 => 'October',
							11 => 'November',
							12 => 'December'	
						);
	
	/**
	 * Days of the week, ordered by our chosen start day
	 */
	private $orderedDays;
	
	/**
	 * Name of the current month
	 */
	private $monthName;
	
	/**
	 * Dates of the month 
	 */
	private $dates=array();
	
	/**
	 * Styles for each day of the month
	 */
	private $dateStyles=array();
	
	/**
	 * List of days with events associated with them
	 */
	private $daysWithEvents = array();
	
	/**
	 * Data to associate with dates
	 */
	private $data=array();
	
	/**
	 * Data associated with dates, in corresponding 42 record array
	 */
	private $datesData = array();
	 
	/**
	 * Calendar constructor
	 * @param int $day selected day in the calendar
	 * @param int $month month being represented in calendar
	 * @param int $year the year being represented in the calendar
	 * @return void
	 */
	public function __construct( $day, $month, $year )
	{
		$this->year = ( $year == '' ) ? date('y') : $year;
		$this->month =  ( $month == '' ) ? date('m') : $month;
		$this->day = ( $day == '' ) ? date('d') : $day;
		$this->monthName =  $this->months[ ltrim( $this->month, '0') ];
	}
	
	/**
	 * Builds the month being represented by the calendar object
	 * @return void
	 */
	public function buildMonth()
	{
		$this->orderedDays = $this->getDaysInOrder();
		
		$this->monthName =  $this->months[ ltrim( $this->month, '0') ];
		
		// start of whichever month we are building
		$start_of_month = getdate( mktime(12, 0, 0, $this->month, 1, $this->year ) );
		
		$first_day_of_month = $start_of_month['wday'];
		
		$days = $this->startDay - $first_day_of_month;
		
		if( $days > 1 )
		{
			// get an offset
			$days -= 7;
			
		}

		$num_days = $this->daysInMonth($this->month, $this->year);
		// 42 iterations
		$start = 0;
		$cal_dates = array();
		$cal_dates_style = array();
		$cal_events = array();
		while( $start < 42 )
		{
			// off set dates
			if( $days < 0 )
			{
				$cal_dates[] = '';
				$cal_dates_style[] = 'calendar-empty';
				$cal_dates_data[] = '';
			}
			else
			{
				if( $days < $num_days )
				{
					// real days
					$cal_dates[] = $days+1;
					if( in_array( $days+1, $this->daysWithEvents ) )
					{
						$cal_dates_style[] = 'has-events';
						$cal_dates_data[] = $this->data[ $days+1 ];
					}
					else
					{
						$cal_dates_style[] = '';
						$cal_dates_data[] = '';
					}
					
				}
				else
				{
					// surplus
					$cal_dates[] = '';
					$cal_dates_style[] = 'calendar-empty';
					$cal_dates_data[] = '';
				}
				
			}
			// increment and loop
			$start++;
			$days++;
		}
		
		// done
		$this->dates = $cal_dates;
		$this->dateStyles = $cal_dates_style;
		$this->dateData = $cal_dates_data;
	}
	
	public function setData( $data )
	{
		$this->data = $data;
	}
	
	/**
	 * Get dates
	 * A calendars month view has 41 spaces for dates, this gets the contents of these 41 spaces, indicating which should have numbers and which should be blank!
	 * @return array
	 */
	public function getDates()
	{
		return $this->dates;
	}
	
	
	/**
	 * Get date styles
	 * Returns the array of date styles built by the buildMonth method
	 * @return array
	 */
	public function getDateStyles()
	{
		return $this->dateStyles;
	}
	
	/**
	 * Get next month
	 * @return Object calendar object
	 */
	public function getNextMonth()
	{
		$nm = new Calendar( '', ( ($this->month < 12 ) ? $this->month + 1 : 1), ( ( $this->month == 12 ) ? $this->year + 1 : $this->year ) );
		return $nm;
	}
	
	/**
	 * Get previous month
	 * @return Object calendar object
	 */
	public function getPreviousMonth()
	{
		$pm = new Calendar( '', ( ( $this->month > 1 ) ? $this->month - 1 : 12 ), ( ( $this->month == 1 ) ? $this->year-1 : $this->year ) );
		return $pm;
	}
	
	public function setStartDay( $day )
	{
		$this->start_day = $day;
	}
	
	public function getDateData()
	{
		return $this->dateData;
	}
	
	/**
	 * Set month
	 * @param int $m
	 * @return void
	 */
	public function setMonth( $m )
	{
		$this->month = $m; 	
	}
	
	/**
	 * Set days with events
	 * Sets which days have events so when building months, style can be appropriately changed
	 * @param array $days
	 * @return void
	 */
	public function setDaysWithEvents( $days )
	{
		$this->daysWithEvents = $days;
	}
	
	/**
	 * Set year
	 * @param int $y
	 */
	public function setYear( $y )
	{
		$this->year = $y;
	}
	
	/**
	 * Get days in order
	 * @return array array of days (as strings)
	 */
	function getDaysInOrder()
	{
		$ordered_days = array();
		for( $i = 0; $i < 7; $i++ )
		{
			$ordered_days[] = $this->days[ ( $this->startDay + $i ) % 7 ];
		}
		return $ordered_days;
	}
	
	/**
	 * How many days are in a month?
	 * @param int $m month
	 * @param int $y year
	 * @return int the number of days in the month
	 */
	function daysInMonth($m, $y)
	{
		if( $m < 1 || $m > 12 )
		{
			return 0;
		}
		else
		{
			// 30: 9, 4, 6, 11
			if( $m == 9 || $m == 4 || $m == 6 || $m == 11 )
			{
				return 30;
			}
			else if( $m != 2 )
			{
				// all the rest have 31
				return 31;
			}
			else
			{
				// except for february alone
				if( $y % 4 != 0 )
				{
					// which has 28
					return 28;
				}
				else
				{
					if( $y % 100 != 0 ) 
					{
						// and on leap years 29
						return 29;
					}
					else
					{
						if( $y % 400 != 0 )
						{
							// deja vu: which has 28
							return 28;
						}
						else
						{
							// deja vu: and on leap years 29
							return 29;
						}
					}
				}
			}
		}
	}
	
	/**
	 * Get month
	 * @return int
	 */
	public function getMonth()
	{
		return $this->month;
		
	}
	
	/**
	 * Get year
	 * @return int
	 */
	public function getYear()
	{
		return $this->year;
	}
	
	/**
	 * Get month name
	 * @return String
	 */
	public function getMonthName()
	{
		return $this->monthName;
	}
	
	
	
	
}

?>